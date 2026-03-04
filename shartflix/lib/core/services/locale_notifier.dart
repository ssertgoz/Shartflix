import 'package:flutter/material.dart';
import 'secure_storage_service.dart';

/// Holds the current app locale and persists the choice across sessions.
class LocaleNotifier extends ValueNotifier<Locale> {
  final SecureStorageService _storage;

  LocaleNotifier(this._storage) : super(const Locale('tr'));

  Future<void> initialize() async {
    final saved = await _storage.getSavedLocale();
    if (saved != null) {
      value = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (value == locale) return;
    value = locale;
    await _storage.saveLocale(locale.languageCode);
  }
}
