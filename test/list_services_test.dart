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
