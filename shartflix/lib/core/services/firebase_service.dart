import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'logger_service.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _instance = FirebaseService._();
  static FirebaseService get instance => _instance;

  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;

  bool _initialized = false;

  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // Forward Flutter errors to Crashlytics
      FlutterError.onError = (errorDetails) {
        _crashlytics?.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics?.recordError(error, stack, fatal: true);
        return true;
      };

      // Disable Crashlytics in debug mode
      await _crashlytics?.setCrashlyticsCollectionEnabled(!kDebugMode);

      _initialized = true;
      logger.info('Firebase initialized successfully');
    } catch (e) {
      logger.error('Firebase initialization failed', e);
    }
  }

  Future<void> logScreenView(String screenName) async {
    if (!_initialized) return;
    try {
      await _analytics?.logScreenView(screenName: screenName);
      logger.debug('Analytics: screen_view - $screenName');
    } catch (e) {
      logger.error('Analytics logScreenView failed', e);
    }
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_initialized) return;
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
      logger.debug('Analytics: $name - $parameters');
    } catch (e) {
      logger.error('Analytics logEvent failed', e);
    }
  }

  Future<void> logLogin(String method) async {
    if (!_initialized) return;
    try {
      await _analytics?.logLogin(loginMethod: method);
    } catch (e) {
      logger.error('Analytics logLogin failed', e);
    }
  }

  Future<void> logSignUp(String method) async {
    if (!_initialized) return;
    try {
      await _analytics?.logSignUp(signUpMethod: method);
    } catch (e) {
      logger.error('Analytics logSignUp failed', e);
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!_initialized) return;
    try {
      await _analytics?.setUserId(id: userId);
    } catch (e) {
      logger.error('Analytics setUserId failed', e);
    }
  }

  void recordError(dynamic exception, StackTrace? stackTrace, {bool fatal = false}) {
    if (!_initialized) return;
    try {
      _crashlytics?.recordError(exception, stackTrace, fatal: fatal);
      logger.error('Crashlytics error recorded', exception, stackTrace);
    } catch (e) {
      logger.error('Crashlytics recordError failed', e);
    }
  }

  FirebaseAnalyticsObserver? get analyticsObserver {
    if (!_initialized || _analytics == null) return null;
    return FirebaseAnalyticsObserver(analytics: _analytics!);
  }
}

final firebaseService = FirebaseService.instance;
