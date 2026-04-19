import '../../shared/network/api_client.dart';
import 'pet.dart';

class PetService {
  PetService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Pet> getPet(int petId) async {
    final data =
        await _apiClient.getJson('pets/$petId') as Map<String, dynamic>;
    return Pet.fromJson(data);
  }

  Future<Pet> createPet(int ownerId, Pet pet) async {
    final data = await _apiClient.postJson(
      'owners/$ownerId/pets',
      pet.toWriteJson(),
    ) as Map<String, dynamic>;
    return Pet.fromJson(data);
  }

  Future<void> updatePet(Pet pet) async {
    await _apiClient.putJson('pets/${pet.id}', pet.toWriteJson());
  }

  Future<void> deletePet(int petId) async {
    await _apiClient.delete('pets/$petId');
  }
}
