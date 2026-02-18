import 'dart:convert';

import 'package:momaspayplus/domain/data/request/login.dart';
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
}
