import '../models/statistics_model.dart';
import 'api_client.dart';

/// İstatistik API servisi
class StatisticsService {
  final ApiClient _apiClient = ApiClient();

  /// Genel kütüphane istatistiklerini getir
  Future<LibraryStatistics> getLibraryStatistics() async {
    try {
      final response = await _apiClient.get('/Statistics');
      final data = response.data;
      
      if (data['success'] == true && data['data'] != null) {
        return LibraryStatistics.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'İstatistikler yüklenemedi');
    } catch (e) {
      print('🔴 Statistics error: $e');
      rethrow;
    }
  }

  /// Kategori bazlı istatistikleri getir
  Future<List<CategoryStatistics>> getCategoryStatistics() async {
    try {
      final response = await _apiClient.get('/Statistics/categories');
      final data = response.data;
      
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> items = data['data'];
        return items.map((json) => CategoryStatistics.fromJson(json)).toList();
      }
      throw Exception(data['message'] ?? 'Kategori istatistikleri yüklenemedi');
    } catch (e) {
      print('🔴 Category statistics error: $e');
      rethrow;
    }
  }

  /// Aylık ödünç istatistiklerini getir
  Future<List<MonthlyLoanStatistics>> getMonthlyLoanStatistics({int months = 6}) async {
    try {
      final response = await _apiClient.get(
        '/Statistics/monthly-loans',
        queryParameters: {'months': months},
      );
      final data = response.data;
      
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> items = data['data'];
        return items.map((json) => MonthlyLoanStatistics.fromJson(json)).toList();
      }
      throw Exception(data['message'] ?? 'Aylık istatistikler yüklenemedi');
    } catch (e) {
      print('🔴 Monthly statistics error: $e');
      rethrow;
    }
  }

  /// En popüler kitapları getir
  Future<List<TopBook>> getTopBooks({int count = 5}) async {
    try {
      final response = await _apiClient.get(
        '/Statistics/top-books',
        queryParameters: {'count': count},
      );
      final data = response.data;
      
      if (data['success'] == true && data['data'] != null) {
        final List<dynamic> items = data['data'];
        return items.map((json) => TopBook.fromJson(json)).toList();
      }
      throw Exception(data['message'] ?? 'Popüler kitaplar yüklenemedi');
    } catch (e) {
      print('🔴 Top books error: $e');
      rethrow;
    }
  }
}

