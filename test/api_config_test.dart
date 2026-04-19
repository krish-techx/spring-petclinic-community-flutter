import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spring_petclinic_flutter/shared/config/api_config.dart';

void main() {
  group('ApiConfig.resolveBaseUrl', () {
    test('uses the override when provided', () {
      expect(
        ApiConfig.resolveBaseUrl(
          override: ' http://example.test/api ',
          isWeb: false,
          platform: TargetPlatform.android,
        ),
        'http://example.test/api',
      );
    });

    test('uses localhost on web even if the host platform is Android', () {
      expect(
        ApiConfig.resolveBaseUrl(
          override: '',
          isWeb: true,
          platform: TargetPlatform.android,
        ),
        'http://localhost:9966/petclinic/api',
      );
    });

    test('uses 10.0.2.2 on Android when there is no override', () {
      expect(
        ApiConfig.resolveBaseUrl(
          override: '',
          isWeb: false,
          platform: TargetPlatform.android,
        ),
        'http://10.0.2.2:9966/petclinic/api',
      );
    });

    test('uses localhost on non-Android native platforms', () {
      expect(
        ApiConfig.resolveBaseUrl(
          override: '',
          isWeb: false,
          platform: TargetPlatform.linux,
        ),
        'http://localhost:9966/petclinic/api',
      );
    });
  });
}
