import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../config/app_config.dart';

class UpdateService {
  static const String _apiUrl =
      'https://api.github.com/repos/'
      '${AppConfig.githubOwner}/${AppConfig.githubRepo}/releases/latest';

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      print('[UPDATE] Verificando actualizaciones...');
      print('[UPDATE] URL: $_apiUrl');

      final response = await http
          .get(Uri.parse(_apiUrl), headers: {
            'Accept': 'application/vnd.github.v3+json',
            if (AppConfig.githubToken.isNotEmpty)
              'Authorization': 'Bearer ${AppConfig.githubToken}',
          })
          .timeout(const Duration(seconds: 10));

      print('[UPDATE] Status: ${response.statusCode}');
      print('[UPDATE] Body: ${response.body}');

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final latestVersion =
          (data['tag_name'] as String).replaceAll('v', '');

      print('[UPDATE] Versión actual: ${AppConfig.version}');
      print('[UPDATE] Versión GitHub: $latestVersion');
      print('[UPDATE] ¿Hay update?: ${_isNewerVersion(latestVersion, AppConfig.version)}');

      if (!_isNewerVersion(latestVersion, AppConfig.version)) return;

      final assets = data['assets'] as List<dynamic>;
      final installerAsset = assets.cast<Map<String, dynamic>>().firstWhere(
            (a) => (a['name'] as String).endsWith('.exe'),
            orElse: () => {},
          );

      if (installerAsset.isEmpty) return;

      final downloadUrl =
          installerAsset['browser_download_url'] as String;

      if (context.mounted) {
        _showUpdateDialog(context, latestVersion, downloadUrl);
      }
    } catch (e) {
      print('[UPDATE] Error verificando actualización: $e');
    }
  }

  static bool _isNewerVersion(String latest, String current) {
    final l = latest.split('.').map(int.tryParse).toList();
    final c = current.split('.').map(int.tryParse).toList();
    for (int i = 0; i < 3; i++) {
      final lv = (i < l.length ? l[i] : null) ?? 0;
      final cv = (i < c.length ? c[i] : null) ?? 0;
      if (lv > cv) return true;
      if (lv < cv) return false;
    }
    return false;
  }

  static void _showUpdateDialog(
    BuildContext context,
    String newVersion,
    String downloadUrl,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva versión disponible'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppConfig.appName} ${AppConfig.version} → $newVersion',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hay una actualización disponible. '
              '¿Deseas instalarla ahora?',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Después'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _downloadAndInstall(context, downloadUrl, newVersion);
            },
            child: const Text('Actualizar ahora'),
          ),
        ],
      ),
    );
  }

  static Future<void> _downloadAndInstall(
    BuildContext context,
    String downloadUrl,
    String version,
  ) async {
    if (!context.mounted) return;

    // ValueNotifier permite actualizar el progreso sin reconstruir todo el árbol
    final progressNotifier = ValueNotifier<double>(-1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Descargando actualización'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('KatyDecor Admin $version'),
            const SizedBox(height: 16),
            ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (_, value, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: value >= 0 ? value : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value >= 0
                        ? '${(value * 100).toStringAsFixed(0)}%'
                        : 'Iniciando descarga...',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await client.send(request);

      final total = response.contentLength ?? 0;
      var received = 0;

      final tmpDir = await getTemporaryDirectory();
      final exePath = '${tmpDir.path}/KatyDecorAdmin_setup.exe';
      final sink = File(exePath).openWrite();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) progressNotifier.value = received / total;
      }

      await sink.close();
      client.close();
      progressNotifier.dispose();

      if (context.mounted) Navigator.of(context).pop();

      print('[UPDATE] Descarga completa: $exePath');
      await Process.start(
        exePath,
        [],
        runInShell: true,
        mode: ProcessStartMode.detached,
      );
      exit(0);
    } catch (e) {
      print('[UPDATE] Error descargando: $e');
      progressNotifier.dispose();
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar la actualización: $e')),
        );
      }
    }
  }
}
