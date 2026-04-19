import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:spring_petclinic_flutter/features/owners/owner_service.dart';
import 'package:spring_petclinic_flutter/features/pettypes/pet_type_service.dart';
import 'package:spring_petclinic_flutter/features/specialties/specialty_service.dart';
import 'package:spring_petclinic_flutter/features/vets/vet_service.dart';
import 'package:spring_petclinic_flutter/shared/network/api_client.dart';

void main() {
  group('list services', () {
    ApiClient buildApiClient({
      required Future<http.Response> Function(http.Request request) handler,
    }) {
      return ApiClient(
        client: MockClient(handler),
        baseUrl: 'http://localhost',
      );
    }

    test('OwnerService returns an empty list on 404', () async {
      final service = OwnerService(
        apiClient: buildApiClient(handler: (_) async => http.Response('', 404)),
      );

      final owners = await service.listOwners();

      expect(owners, isEmpty);
    });

    test('VetService returns an empty list on 404', () async {
      final service = VetService(
        apiClient: buildApiClient(handler: (_) async => http.Response('', 404)),
      );

      final vets = await service.listVets();

      expect(vets, isEmpty);
    });

    test('PetTypeService returns an empty list on 404', () async {
      final service = PetTypeService(
        apiClient: buildApiClient(handler: (_) async => http.Response('', 404)),
      );

      final petTypes = await service.listPetTypes();

      expect(petTypes, isEmpty);
    });

    test('SpecialtyService returns an empty list on 404', () async {
      final service = SpecialtyService(
        apiClient: buildApiClient(handler: (_) async => http.Response('', 404)),
      );

      final specialties = await service.listSpecialties();

      expect(specialties, isEmpty);
    });

    test('detail endpoints still surface 404 as an error', () async {
      final service = OwnerService(
        apiClient: buildApiClient(handler: (_) async => http.Response('', 404)),
      );

      expect(
        service.getOwner(1),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });
  });
}
