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

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(vetService.deleteCalls, 0);
    expect(find.text('Delete veterinarian?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(vetService.deleteCalls, 1);
    expect(find.text('James Carter'), findsNothing);
  });
}
