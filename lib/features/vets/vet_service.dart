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
