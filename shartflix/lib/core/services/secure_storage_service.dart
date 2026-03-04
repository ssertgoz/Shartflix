import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logger_service.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _localeKey = 'app_locale';

  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      logger.info('Token saved securely');
    } catch (e) {
      logger.error('Failed to save token', e);
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      logger.error('Failed to read token', e);
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      logger.info('Token deleted');
    } catch (e) {
      logger.error('Failed to delete token', e);
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e) {
      logger.error('Failed to save user id', e);
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      logger.error('Failed to read user id', e);
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      logger.info('All secure storage cleared');
    } catch (e) {
      logger.error('Failed to clear storage', e);
    }
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveLocale(String languageCode) async {
    try {
      await _storage.write(key: _localeKey, value: languageCode);
    } catch (e) {
      logger.error('Failed to save locale', e);
    }
  }

  Future<String?> getSavedLocale() async {
    try {
      return await _storage.read(key: _localeKey);
    } catch (e) {
      logger.error('Failed to read locale', e);
      return null;
    }
  }
}
