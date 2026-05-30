import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  final AuthService _auth;

  ApiService(this._auth);

  DateTime? _lastOnlineCheck;
  bool _lastOnlineResult = false;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_auth.token ?? ''}',
  };

  String _url(String endpoint) => '${AuthService.serverUrl}$endpoint';

  /// Maneja la respuesta: lanza excepción según el código HTTP.
  dynamic _handle(http.Response response) {
    if (response.statusCode == 401) {
      _auth.logout();
      throw ApiUnauthorizedException();
    }
    if (response.statusCode >= 400) {
      String message = 'Error del servidor (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        message = body['error'] as String? ?? body['message'] as String? ?? message;
      } catch (_) {}
      throw ApiException(message, response.statusCode);
    }
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse(_url(endpoint)), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handle(response);
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiOfflineException();
    } catch (e) {
      throw ApiOfflineException();
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse(_url(endpoint)),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handle(response);
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiOfflineException();
    } catch (e) {
      throw ApiOfflineException();
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
            Uri.parse(_url(endpoint)),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handle(response);
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiOfflineException();
    } catch (e) {
      throw ApiOfflineException();
    }
  }

  /// Ping rápido al servidor (timeout 3s). Resultado cacheado 10 segundos
  /// para evitar múltiples requests en ráfagas de operaciones offline.
  Future<bool> get isOnline async {
    final now = DateTime.now();
    if (_lastOnlineCheck != null &&
        now.difference(_lastOnlineCheck!).inSeconds < 10) {
      return _lastOnlineResult;
    }
    try {
      final response = await http
          .head(Uri.parse('${AuthService.serverUrl}/api/auth/verify'))
          .timeout(const Duration(seconds: 3));
      _lastOnlineResult = response.statusCode < 500;
      _lastOnlineCheck = now;
      return _lastOnlineResult;
    } catch (_) {
      _lastOnlineResult = false;
      _lastOnlineCheck = now;
      return false;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse(_url(endpoint)), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handle(response);
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiOfflineException();
    } catch (e) {
      throw ApiOfflineException();
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
}

class ApiUnauthorizedException implements Exception {}

class ApiOfflineException implements Exception {}
