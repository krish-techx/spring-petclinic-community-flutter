import '../../shared/network/api_client.dart';
import 'pet_type.dart';

class PetTypeService {
  PetTypeService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<PetType>> listPetTypes() async {
    try {
      final data = await _apiClient.getJson('pettypes') as List<dynamic>;
      return data
          .map((item) => PetType.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        return const [];
      }
      rethrow;
    }
  }

  Future<PetType> getPetType(int typeId) async {
    final data =
        await _apiClient.getJson('pettypes/$typeId') as Map<String, dynamic>;
    return PetType.fromJson(data);
  }

  Future<PetType> createPetType(PetType petType) async {
    final data =
        await _apiClient.postJson('pettypes', petType.toWriteJson())
            as Map<String, dynamic>;
    return PetType.fromJson(data);
  }

  Future<void> updatePetType(PetType petType) async {
    await _apiClient.putJson('pettypes/${petType.id}', petType.toWriteJson());
  }

  Future<void> deletePetType(int typeId) async {
    await _apiClient.delete('pettypes/$typeId');
  }
}
