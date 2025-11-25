import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../core/constants/api_constants.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// Kullanıcı kaydı
  Future<AuthResponse> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authRegister,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;

        // Token'ı kaydet
        await _apiClient.saveToken(token);

        return AuthResponse(
          token: token,
          user: UserModel.fromJson(userJson),
        );
      } else {
        throw Exception('Kayıt başarısız: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kayıt başarısız';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Kullanıcı girişi
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;

        // Token'ı kaydet
        await _apiClient.saveToken(token);
        
        final user = UserModel.fromJson(userJson);
        return AuthResponse(
          token: token,
          user: user,
        );
      } else {
        throw Exception('Giriş başarısız: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Giriş başarısız';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Mevcut kullanıcı bilgilerini getir
  Future<UserModel?> getCurrentUser() async {
    try {
      final hasToken = await _apiClient.hasToken();
      if (!hasToken) {
        return null;
      }

      final response = await _apiClient.get(ApiConstants.authMe);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('❌ getCurrentUser error: ${e.message}');
      // Token geçersiz, sil
      await logout();
      return null;
    }
  }

  /// Çıkış yap
  Future<void> logout() async {
    await _apiClient.deleteToken();
  }

  /// Token var mı kontrol et
  Future<bool> isLoggedIn() async {
    return await _apiClient.hasToken();
  }
}

/// Auth response model
class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({
    required this.token,
    required this.user,
  });
}
