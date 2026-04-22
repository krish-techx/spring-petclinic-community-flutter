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
import 'package:flutter_test/flutter_test.dart';
import 'package:spring_petclinic_flutter/main.dart';

void main() {
  void configureSurface(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });
  }

  testWidgets('renders desktop home navigation and footer', (
    WidgetTester tester,
  ) async {
    configureSurface(tester, const Size(1400, 1000));

    await tester.pumpWidget(const PetClinicApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Petclinic'), findsOneWidget);
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('OWNERS'), findsOneWidget);
    expect(find.text('VETERINARIANS'), findsOneWidget);
    expect(
      find.text('Spring Petclinic Flutter Sample Application'),
      findsOneWidget,
    );
    expect(find.byType(Image), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders desktop top bar without overflow near breakpoint', (
    WidgetTester tester,
  ) async {
    configureSurface(tester, const Size(912, 700));

    await tester.pumpWidget(const PetClinicApp());
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('OWNERS'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders home without overflow on short landscape screens', (
    WidgetTester tester,
  ) async {
    configureSurface(tester, const Size(740, 260));

    await tester.pumpWidget(const PetClinicApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Petclinic'), findsOneWidget);
    expect(
      find.text('Spring Petclinic Flutter Sample Application'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'opens navigation drawer without overflow on short landscape screens',
    (WidgetTester tester) async {
      configureSurface(tester, const Size(740, 260));

      await tester.pumpWidget(const PetClinicApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Owners'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}
