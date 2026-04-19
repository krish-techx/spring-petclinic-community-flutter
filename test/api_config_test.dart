/*
 * Copyright 2002-2017 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
