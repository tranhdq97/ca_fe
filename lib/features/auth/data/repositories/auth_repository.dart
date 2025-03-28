import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(baseUrl: ApiEndpoints.baseUrl);

  Future<UserModel> loginClient(String phone) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoints.login,
        body: {'phone': phone, 'is_staff': false},
      );

      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Đăng nhập thất bại, vui lòng thử lại sau';
    }
  }

  Future<UserModel> loginStore(String phone, String password) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoints.login,
        body: {'phone': phone, 'password': password, 'is_staff': true},
      );

      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Đăng nhập thất bại, vui lòng thử lại sau';
    }
  }
}
