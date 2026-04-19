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

import '../../shared/network/api_client.dart';
import 'vet.dart';

class VetService {
  VetService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Vet>> listVets() async {
    try {
      final data = await _apiClient.getJson('vets') as List<dynamic>;
      return data
          .map((item) => Vet.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        return const [];
      }
      rethrow;
    }
  }

  Future<Vet> getVet(int vetId) async {
    final data =
        await _apiClient.getJson('vets/$vetId') as Map<String, dynamic>;
    return Vet.fromJson(data);
  }

  Future<Vet> createVet(Vet vet) async {
    final data =
        await _apiClient.postJson('vets', vet.toWriteJson())
            as Map<String, dynamic>;
    return Vet.fromJson(data);
  }

  Future<void> updateVet(Vet vet) async {
    await _apiClient.putJson('vets/${vet.id}', vet.toWriteJson());
  }

  Future<void> deleteVet(int vetId) async {
    await _apiClient.delete('vets/$vetId');
  }
}
