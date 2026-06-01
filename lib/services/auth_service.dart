import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import '../core/pocketbase_service.dart';

class AuthService extends ChangeNotifier {
  PocketBase get _pb => PocketBaseService.instance.pb;

  bool get isLoggedIn => PocketBaseService.instance.isLoggedIn;
  bool get hasToken => isLoggedIn;

  String? get username {
    final model = _pb.authStore.model;
    if (model is RecordModel) {
      final name = model.getStringValue('name');
      if (name.isNotEmpty) return name;
      final uname = model.getStringValue('username');
      if (uname.isNotEmpty) return uname;
      return model.getStringValue('email');
    }
    return null;
  }

  // Stub para ApiService legacy — no se usa
  String? get token => null;

  Future<void> loadFromPrefs() async {
    await PocketBaseService.instance.loadAuthFromPrefs();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      await PocketBaseService.instance.login(email, password);
      notifyListeners();
    } on ClientException catch (e) {
      final code = e.statusCode;
      if (code == 400 || code == 401) {
        throw AuthException('Usuario o contraseña incorrectos');
      }
      throw AuthException('Error del servidor ($code)');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerUnreachableException(
          'No se pudo conectar. Verifica tu conexión.');
    }
  }

  Future<void> logout() async {
    await PocketBaseService.instance.logout();
    notifyListeners();
  }

  /// Llama authRefresh en PocketBase para validar el token guardado.
  Future<bool> tryAutoLogin() async {
    if (!isLoggedIn) return false;
    try {
      await _pb.collection('users').authRefresh();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
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
