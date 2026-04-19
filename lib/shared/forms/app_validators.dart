typedef StringValidator = String? Function(String? value);

class AppValidators {
  static StringValidator compose(List<StringValidator> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }

  static StringValidator required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required.';
      }
      return null;
    };
  }

  static StringValidator lettersOnly(
    String fieldName, {
    required int minLength,
    required int maxLength,
  }) {
    final pattern = RegExp(r'^[A-Za-z]+$');
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return '$fieldName is required.';
      }
      if (text.length < minLength) {
        return '$fieldName must be at least $minLength character long.';
      }
      if (text.length > maxLength) {
        return '$fieldName may be at most $maxLength characters long.';
      }
      if (!pattern.hasMatch(text)) {
        return '$fieldName must contain letters only.';
      }
      return null;
    };
  }

  static StringValidator digitsOnly(
    String fieldName, {
    required int minLength,
    required int maxLength,
  }) {
    final pattern = RegExp(r'^[0-9]+$');
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return '$fieldName is required.';
      }
      if (text.length < minLength) {
        return '$fieldName must be at least $minLength digit long.';
      }
      if (text.length > maxLength) {
        return '$fieldName may be at most $maxLength digits long.';
      }
      if (!pattern.hasMatch(text)) {
        return '$fieldName must contain digits only.';
      }
      return null;
    };
  }

  static StringValidator exactDigits(String fieldName, {required int length}) {
    final pattern = RegExp(r'^[0-9]+$');
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return '$fieldName is required.';
      }
      if (!pattern.hasMatch(text)) {
        return '$fieldName must contain digits only.';
      }
      if (text.length != length) {
        return '$fieldName must be exactly $length digits long.';
      }
      return null;
    };
  }

  static StringValidator plainText(
    String fieldName, {
    required int minLength,
    required int maxLength,
  }) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return '$fieldName is required.';
      }
      if (text.length < minLength) {
        return '$fieldName must be at least $minLength character long.';
      }
      if (text.length > maxLength) {
        return '$fieldName may be at most $maxLength characters long.';
      }
      return null;
    };
  }

  static StringValidator alphaNumericStart(
    String fieldName, {
    required int minLength,
    required int maxLength,
  }) {
    final pattern = RegExp(r'^[A-Za-z0-9].*$');
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) {
        return '$fieldName is required.';
      }
      if (text.length < minLength) {
        return '$fieldName must be at least $minLength character long.';
      }
      if (text.length > maxLength) {
        return '$fieldName may be at most $maxLength characters long.';
      }
      if (!pattern.hasMatch(text)) {
        return '$fieldName must start with a letter or digit.';
      }
      return null;
    };
  }
}
