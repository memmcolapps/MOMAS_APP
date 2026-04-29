import 'dart:convert';

import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/promo.dart';
import 'package:momaspayplus/domain/data/response/setting_response.dart';
import 'package:momaspayplus/features/auth/data/models/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/data/response/user_model.dart';

class SharedPreferenceHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance => _prefs;

  // Keys
  static const String _keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const String _keyUser = 'user';
  static const String _keyLogin = 'Login';
  static const String _token = 'TOKEN';
  static const String _balance = 'balance_visible';
  static const String _unit = 'unit_visible';
  static const String _promoCache = 'promo_cache';
  static const String _featureCache = 'feature_cache';
  static const String _supportCache = 'support_cache';

  static bool get hasSeenOnboarding =>
      _prefs.getBool(_keyHasSeenOnboarding) ?? false;

  static Future<void> setOnboardingSeen(bool value) =>
     _prefs.setBool(_keyHasSeenOnboarding, value);



  static Future<void> clearUser() async {
    // final _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_keyUser);
    _prefs.remove(_token);
    // _prefs.clear();
  }

  static Future<void> saveUser(Map user) async {
    // final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_keyUser, json.encode(user));
  }

  static Future<void> saveToken(String token) async {
    // final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_token, token);
  }

  static Future<User?> getUser() async {
    // final _prefs = await SharedPreferences.getInstance();
    var data = _prefs.getString(
      _keyUser,
    );
    return data == null ? null : User.fromJson(json.decode(data));
  }

  static Future<String?> getToken() async {
    // final _prefs = await SharedPreferences.getInstance();
    var data = _prefs.getString(_token);
    return data;
  }

  static Future<void> saveLogin(Map login) async {
    // final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_keyLogin, json.encode(login));
  }

  static Future<Login?> getLogin() async {
    // final _prefs = await SharedPreferences.getInstance();
    var data = _prefs.getString(
      _keyLogin,
    );
    return data == null ? null : Login.fromJson(json.decode(data));
  }

  static Future<bool> getBalanceVisibility() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_balance) ?? true;
  }

  static Future<void> saveBalanceVisibility(bool isVisible) async {
    // final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(_balance, isVisible);
  }

  static Future<bool> getUnitVisibility() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_unit) ?? true;
  }

  static Future<void> saveUnitVisibility(bool isVisible) async {
    // final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(_unit, isVisible);
  }

  static Future<void> savePromo(List promos) async {
    await _prefs.setString(_promoCache, json.encode(promos));
  }

  static List<Promo>? getCachedPromo() {
    final data = _prefs.getString(_promoCache);
    return data == null
        ? null
        : (json.decode(data) as List)
        .map((e) => Promo.fromJson(e))
        .toList();
  }

  static Future<void> saveFeature(Feature feature) async {
    await _prefs.setString(
      _featureCache,
      json.encode(feature.toJson()),
    );
  }

  static Feature? getCachedFeature() {
    final data = _prefs.getString(_featureCache);
    return data == null
        ? null
        : Feature.fromJson(json.decode(data));
  }

  static Future<void> saveSupport(SupportData supportData) async {
    await _prefs.setString(
      _supportCache,
      json.encode( supportData.toJson()),
    );
  }

  static SupportData? getSupport() {
    final data = _prefs.getString(_supportCache);
    return data == null
        ? null
        : SupportData.fromJson(json.decode(data));
  }
}
