import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  static const String _keyToken = 'auth_token';
  static const String _keyUsername = 'auth_username';
  static const String serverUrl = 'https://katydecor-admin.onrender.com';

  String? _token;
  String? _username;

  String? get token => _token;
  String? get username => _username;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  bool get hasToken => _token != null && _token!.isNotEmpty;

  /// Carga token y username desde SharedPreferences al iniciar la app.
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_keyToken);
    _username = prefs.getString(_keyUsername);
    notifyListeners();
  }

  /// Verifica si hay token guardado y si sigue siendo válido en el servidor.
  /// Regresa true si el token es válido, false si no hay token o expiró.
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http
          .get(
            Uri.parse('$serverUrl/api/auth/verify'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        _token = token;
        _username = prefs.getString(_keyUsername);
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Llama a POST /api/auth/login y guarda el token en prefs.
  /// Lanza [AuthException] si las credenciales son incorrectas.
  /// Lanza [ServerUnreachableException] si el servidor no responde.
  Future<void> login(String username, String password) async {
    final url = Uri.parse('$serverUrl/api/auth/login');
    print('[AUTH] Intentando login → $url');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      print('[AUTH] statusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _token = data['token'] as String;
        _username = data['username'] as String? ?? username;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyToken, _token!);
        await prefs.setString(_keyUsername, _username!);

        print('[AUTH] notifyListeners llamado');
        notifyListeners();
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw AuthException(
          data['error'] as String? ?? 'Usuario o contraseña incorrectos',
        );
      } else {
        throw AuthException('Error del servidor (${response.statusCode})');
      }
    } on AuthException {
      rethrow;
    } catch (e, st) {
      print('[AUTH] Error tipo: ${e.runtimeType}');
      print('[AUTH] Error detalle: $e');
      print('[AUTH] Stacktrace: $st');
      throw ServerUnreachableException(
        'No se pudo conectar al servidor. Verifica tu conexión.',
      );
    }
  }

  /// Cierra sesión y limpia prefs.
  Future<void> logout() async {
    _token = null;
    _username = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsername);

    notifyListeners();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class ServerUnreachableException implements Exception {
  final String message;
  ServerUnreachableException(this.message);
}
