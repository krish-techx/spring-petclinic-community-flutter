import '../../shared/network/api_client.dart';
import 'owner.dart';

class OwnerService {
  OwnerService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Owner>> listOwners({String? lastName}) async {
    try {
      final data =
          await _apiClient.getJson(
                'owners',
                queryParameters: {'lastName': lastName},
              )
              as List<dynamic>;
      return data
          .map((item) => Owner.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        return const [];
      }
      rethrow;
    }
  }

  Future<Owner> getOwner(int ownerId) async {
    final data =
        await _apiClient.getJson('owners/$ownerId') as Map<String, dynamic>;
    return Owner.fromJson(data);
  }

  Future<Owner> createOwner(Owner owner) async {
    final data =
        await _apiClient.postJson('owners', owner.toWriteJson())
            as Map<String, dynamic>;
    return Owner.fromJson(data);
  }

  Future<void> updateOwner(Owner owner) async {
    await _apiClient.putJson('owners/${owner.id}', owner.toWriteJson());
  }

  Future<void> deleteOwner(int ownerId) async {
    await _apiClient.delete('owners/$ownerId');
  }
}
