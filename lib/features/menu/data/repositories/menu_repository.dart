import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';

class MenuRepository {
  final ApiClient _apiClient;

  MenuRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(baseUrl: ApiEndpoints.baseUrl);

  Future<List<Map<String, dynamic>>> fetchMenuItems() async {
    // return await _apiClient.get(ApiEndpoints.menu);
    try {
      final data = await _apiClient.get(ApiEndpoints.menu);
      return List<Map<String, dynamic>>.from(data["menu_items"]);
    } catch (e) {
      throw 'Failed to fetch menu items. Please try again later.';
    }
  }
}
