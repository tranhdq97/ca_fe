import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(baseUrl: ApiEndpoints.baseUrl);

  Future<List<Map<String, dynamic>>> fetchOrdersByPhone() async {
    try {
      // Retrieve the current phone number from SharedPreferences
      final phone = await _getPhoneNumber();

      // Pass the phone number as a query parameter
      final data = await _apiClient.get(
        ApiEndpoints.orders,
        queryParameters: {'phone': phone},
      );
      return List<Map<String, dynamic>>.from(data["orders"]);
    } on ApiException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Failed to fetch orders. Please try again later.';
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllOrders(
      {int page = 1, int limit = 2}) async {
    try {
      // Pass the phone number as a query parameter
      final data = await _apiClient.get(
        ApiEndpoints.orders,
      );
      return List<Map<String, dynamic>>.from(data["orders"]);
    } on ApiException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Failed to fetch orders. Please try again later.';
    }
  }

  Future<void> checkOrder(int orderId) async {
    try {
      // Implement the logic to check order status
      // This could involve making an API call or checking local data
      // For now, we'll just print a message
      final phone = await _getPhoneNumber();
      final checkOrderEndpoint =
          ApiEndpoints.checkOrder.replaceFirst('<id>', orderId.toString());
      await _apiClient.put(
        checkOrderEndpoint,
        body: {'phone': phone},
      );
    } catch (e) {
      throw "Failed to fetch orders. Please try again later.";
    }
  }

  Future<String> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone') ?? '';
    if (phone.isEmpty) {
      // Navigate to the login screen
      // Assuming a navigation service or context is available
      // Example using a navigation service:
      // NavigationService.navigateTo('/login');
      throw 'Phone number not found. Please log in again.';
    }
    return phone;
  }
}
