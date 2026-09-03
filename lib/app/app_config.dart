import 'package:flutter/services.dart';

class AppConfig {
  static String get baseUrl {
    switch (appFlavor) {
      case 'development':
        return 'https://unobstructed-kindredly-jeanmarie.ngrok-free.dev';
      case 'staging':
        return 'http://staging.memmserve.com';
      case 'production':
        return 'https://momaspay.memmserve.com';
      default:
        return 'https://momaspay.memmserve.com';
    }
  }
}
