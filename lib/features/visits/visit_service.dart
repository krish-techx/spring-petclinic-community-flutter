import '../../shared/network/api_client.dart';
import 'visit.dart';

class VisitService {
  VisitService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Visit> getVisit(int visitId) async {
    final data =
        await _apiClient.getJson('visits/$visitId') as Map<String, dynamic>;
    return Visit.fromJson(data);
  }

  Future<Visit> createVisit(int ownerId, int petId, Visit visit) async {
    final data = await _apiClient.postJson(
      'owners/$ownerId/pets/$petId/visits',
      visit.toWriteJson(),
    ) as Map<String, dynamic>;
    return Visit.fromJson(data);
  }

  Future<void> updateVisit(Visit visit) async {
    await _apiClient.putJson('visits/${visit.id}', visit.toWriteJson());
  }

  Future<void> deleteVisit(int visitId) async {
    await _apiClient.delete('visits/$visitId');
  }
}
