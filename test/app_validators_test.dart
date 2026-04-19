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
