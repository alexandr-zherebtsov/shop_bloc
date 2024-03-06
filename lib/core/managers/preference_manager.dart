import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  final SharedPreferences _pref;

  PreferenceManager(this._pref);

  static const String _accessToken = 'accessToken';

  Future<bool> setAccessToken(final String? e) async {
    return await _pref.setString(_accessToken, e ?? '');
  }

  String getAccessToken() {
    return _pref.getString(_accessToken) ?? '';
  }

  Future<void> clear() async => await _pref.clear();
}
