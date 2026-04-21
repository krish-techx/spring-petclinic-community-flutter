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
import 'package:spring_petclinic_flutter/features/specialties/specialty.dart';
import 'package:spring_petclinic_flutter/features/vets/vet.dart';
import 'package:spring_petclinic_flutter/features/vets/vet_list_screen.dart';
import 'package:spring_petclinic_flutter/features/vets/vet_service.dart';

class FakeVetService extends VetService {
  FakeVetService(List<Vet> vets) : _vets = vets;

  final List<Vet> _vets;
  int deleteCalls = 0;

  @override
  Future<List<Vet>> listVets() async => List<Vet>.unmodifiable(_vets);

  @override
  Future<void> deleteVet(int vetId) async {
    deleteCalls++;
    _vets.removeWhere((vet) => vet.id == vetId);
  }
}

void main() {
  testWidgets('requires confirmation before deleting a veterinarian', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1400, 1000);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    final vetService = FakeVetService([
      const Vet(
        id: 1,
        firstName: 'James',
        lastName: 'Carter',
        specialties: [Specialty(id: 1, name: 'radiology')],
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(home: VetListScreen(vetService: vetService)),
    );
    await tester.pumpAndSettle();

    expect(find.text('James Carter'), findsOneWidget);

    final deleteButton = find
        .widgetWithText(OutlinedButton, 'Delete Vet')
        .first;
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(vetService.deleteCalls, 0);
    expect(find.text('Delete veterinarian?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(vetService.deleteCalls, 1);
    expect(find.text('James Carter'), findsNothing);
  });
}
