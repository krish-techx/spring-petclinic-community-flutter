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
