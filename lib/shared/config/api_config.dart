import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _envKey = 'PETCLINIC_API_BASE_URL';
  static const _androidBaseUrl = 'http://10.0.2.2:9966/petclinic/api';
  static const _localBaseUrl = 'http://localhost:9966/petclinic/api';

  static String get baseUrl {
    return resolveBaseUrl(
      override: const String.fromEnvironment(_envKey),
      isWeb: kIsWeb,
      platform: defaultTargetPlatform,
    );
  }

  static String resolveBaseUrl({
    required String override,
    required bool isWeb,
    required TargetPlatform platform,
  }) {
    final trimmedOverride = override.trim();
    if (trimmedOverride.isNotEmpty) {
      return trimmedOverride;
    }

    if (isWeb) {
      return _localBaseUrl;
    }

    if (platform == TargetPlatform.android) {
      return _androidBaseUrl;
    }

    return _localBaseUrl;
  }
}
