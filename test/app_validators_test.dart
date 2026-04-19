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

import 'package:flutter_test/flutter_test.dart';
import 'package:spring_petclinic_flutter/shared/forms/app_validators.dart';

void main() {
  group('AppValidators.exactDigits', () {
    final validator = AppValidators.exactDigits('Telephone', length: 10);

    test('accepts exactly 10 digits', () {
      expect(validator('1234567890'), isNull);
    });

    test('rejects fewer than 10 digits', () {
      expect(validator('12345'), 'Telephone must be exactly 10 digits long.');
    });

    test('rejects non-digit characters', () {
      expect(validator('12345abcde'), 'Telephone must contain digits only.');
    });
  });
}
