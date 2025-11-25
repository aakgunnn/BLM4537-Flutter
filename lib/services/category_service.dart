import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../core/constants/api_constants.dart';
import 'api_client.dart';

class CategoryService {
  final ApiClient _apiClient = ApiClient();

  /// Tüm kategorileri getir
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getAllCategories error: ${e.message}');
      throw Exception('Kategoriler yüklenemedi: ${e.message}');
    }
  }

  /// Sadece aktif kategorileri getir
  Future<List<CategoryModel>> getActiveCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.categoriesActive);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getActiveCategories error: ${e.message}');
      throw Exception('Kategoriler yüklenemedi: ${e.message}');
    }
  }

  /// ID'ye göre kategori getir
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final response = await _apiClient.get(ApiConstants.categoryById(id));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return CategoryModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('❌ getCategoryById error: ${e.message}');
      return null;
    }
  }

  /// Yeni kategori ekle (Admin)
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    bool isActive = true,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.categories,
        data: {
          'name': name,
          'description': description,
          'isActive': isActive,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return CategoryModel.fromJson(data);
      } else {
        throw Exception('Kategori eklenemedi: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kategori eklenemedi';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Kategori güncelle (Admin)
  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    String? description,
    bool isActive = true,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.categoryById(id),
        data: {
          'name': name,
          'description': description,
          'isActive': isActive,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return CategoryModel.fromJson(data);
      } else {
        throw Exception('Kategori güncellenemedi: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kategori güncellenemedi';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Kategori sil (Admin)
  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _apiClient.delete(ApiConstants.categoryById(id));

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('❌ deleteCategory error: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kategori silinemedi';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }
}
