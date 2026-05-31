import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketBaseService {
  PocketBaseService._();
  static final PocketBaseService instance = PocketBaseService._();

  static const _baseUrl = 'https://katydecorpocketbase.fly.dev';
  static const _keyToken = 'pb_auth_token';
  static const _keyModel = 'pb_auth_model';

  final PocketBase pb = PocketBase(_baseUrl);

  Future<void> loadAuthFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    final modelJson = prefs.getString(_keyModel);
    if (token != null && modelJson != null) {
      pb.authStore.save(token, RecordModel.fromJson(jsonDecode(modelJson)));
    }
  }

  Future<void> saveAuthToken(String token, RecordModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyModel, jsonEncode(model.toJson()));
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyModel);
    pb.authStore.clear();
  }
}
