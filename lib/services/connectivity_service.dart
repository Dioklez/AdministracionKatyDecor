import 'dart:async';
import 'package:flutter/material.dart';
import '../core/pocketbase_service.dart';

class ConnectivityService extends ChangeNotifier {
  static ConnectivityService? _instance;
  static bool get currentlyOnline => _instance?.isOnline ?? true;

  ConnectivityService() {
    _instance = this;
  }

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Callback invocado automáticamente cuando se recupera la conexión.
  /// Se asigna desde app.dart al construir SyncService.
  VoidCallback? onReconnect;

  Future<bool> checkConnectivity() async {
    try {
      final pb = PocketBaseService.instance.pb;
      await pb.health.check();
      if (!_isOnline) {
        _isOnline = true;
        notifyListeners();
        onReconnect?.call();
      }
      return true;
    } catch (_) {
      if (_isOnline) {
        _isOnline = false;
        notifyListeners();
      }
      return false;
    }
  }

  void startMonitoring() {
    Timer.periodic(const Duration(seconds: 30), (_) => checkConnectivity());
  }
}
