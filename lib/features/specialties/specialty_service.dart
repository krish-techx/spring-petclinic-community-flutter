import '../../shared/network/api_client.dart';
import 'specialty.dart';

class SpecialtyService {
  SpecialtyService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Specialty>> listSpecialties() async {
    try {
      final data = await _apiClient.getJson('specialties') as List<dynamic>;
      return data
          .map((item) => Specialty.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        return const [];
      }
      rethrow;
    }
  }

  Future<Specialty> getSpecialty(int specialtyId) async {
    final data =
        await _apiClient.getJson('specialties/$specialtyId')
            as Map<String, dynamic>;
    return Specialty.fromJson(data);
  }

  Future<Specialty> createSpecialty(Specialty specialty) async {
    final data =
        await _apiClient.postJson('specialties', specialty.toWriteJson())
            as Map<String, dynamic>;
    return Specialty.fromJson(data);
  }

  Future<void> updateSpecialty(Specialty specialty) async {
    await _apiClient.putJson(
      'specialties/${specialty.id}',
      specialty.toWriteJson(),
    );
  }

  Future<void> deleteSpecialty(int specialtyId) async {
    await _apiClient.delete('specialties/$specialtyId');
  }
}
