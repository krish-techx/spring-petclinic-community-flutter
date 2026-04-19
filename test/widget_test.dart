import 'package:flutter_test/flutter_test.dart';

import 'package:spring_petclinic_flutter/main.dart';

void main() {
  testWidgets('renders Spring Petclinic home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PetClinicApp());

    expect(find.text('Spring Petclinic'), findsAtLeastNWidgets(1));
    expect(find.text('Owners'), findsOneWidget);
    expect(find.text('Veterinarians'), findsOneWidget);
  });
}
