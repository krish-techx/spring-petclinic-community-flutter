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

import 'package:flutter/material.dart';

class ClassicPalette {
  static const text = Color(0xFF34302D);
  static const navbar = Color(0xFF34302D);
  static const tableHeader = Color(0xFF3C3834);
  static const accent = Color(0xFF6DB33F);
  static const background = Color(0xFFF1F1F1);
  static const surface = Colors.white;
  static const border = Color(0xFFD9D9D9);

  static ThemeData buildTheme() {
    final base = ThemeData.light(useMaterial3: false);
    final bodyTextTheme = base.textTheme.apply(
      bodyColor: text,
      displayColor: text,
      fontFamily: 'VarelaRound',
    );
    final textTheme = bodyTextTheme.copyWith(
      headlineMedium: bodyTextTheme.headlineMedium?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: bodyTextTheme.headlineSmall?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      titleLarge: bodyTextTheme.titleLarge?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      titleMedium: bodyTextTheme.titleMedium?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      titleSmall: bodyTextTheme.titleSmall?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
      labelLarge: bodyTextTheme.labelLarge?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
      ),
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: const BorderSide(color: border),
    );

    return base.copyWith(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: accent,
            brightness: Brightness.light,
          ).copyWith(
            primary: accent,
            secondary: accent,
            surface: surface,
            onSurface: text,
          ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: navbar,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
      dividerColor: border,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: accent, width: 2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          backgroundColor: surface,
          side: const BorderSide(color: border),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: navbar,
          foregroundColor: Colors.white,
          side: const BorderSide(color: accent, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: navbar,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: accent, width: 1.5),
          borderRadius: BorderRadius.all(Radius.zero),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: const WidgetStatePropertyAll(tableHeader),
        headingTextStyle: textTheme.titleSmall?.copyWith(color: Colors.white),
        dataTextStyle: textTheme.bodyMedium,
        dividerThickness: 1,
      ),
    );
  }
}
