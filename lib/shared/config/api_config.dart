import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _envKey = 'PETCLINIC_API_BASE_URL';

  static String get baseUrl {
    const override = String.fromEnvironment(_envKey);
    if (override.isNotEmpty) {
      return override;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://192.168.1.71:9966/petclinic/api';
    }

    return 'http://localhost:9966/petclinic/api';
  }
}
