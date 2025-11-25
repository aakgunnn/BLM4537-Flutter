import 'package:dio/dio.dart';
import '../models/loan_model.dart';
import '../core/constants/api_constants.dart';
import 'api_client.dart';

class LoanService {
  final ApiClient _apiClient = ApiClient();

  // ========== USER ENDPOINTS ==========

  /// Ödünç alma talebi oluştur (Kullanıcı - Member only)
  Future<LoanModel> createLoanRequest(int bookId) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loans,
        data: {'bookId': bookId},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return LoanModel.fromJson(data);
      } else {
        throw Exception('Ödünç talebi oluşturulamadı: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Ödünç talebi oluşturulamadı';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Kullanıcının kendi ödünçlerini listele
  Future<List<LoanModel>> getMyLoans() async {
    try {
      final response = await _apiClient.get(ApiConstants.loansMyLoans);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => LoanModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getMyLoans error: ${e.message}');
      throw Exception('Ödünçler yüklenemedi: ${e.message}');
    }
  }

  /// Kitap iade talebi (Kullanıcı)
  Future<LoanModel> returnLoan(int loanId) async {
    try {
      final response = await _apiClient.put(ApiConstants.loanReturn(loanId));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return LoanModel.fromJson(data);
      } else {
        throw Exception('İade işlemi başarısız: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'İade işlemi başarısız';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Ödünç detayını getir
  Future<LoanModel?> getLoanById(int loanId) async {
    try {
      final response = await _apiClient.get(ApiConstants.loanById(loanId));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return LoanModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('❌ getLoanById error: ${e.message}');
      return null;
    }
  }

  // ========== ADMIN ENDPOINTS ==========

  /// Tüm ödünçleri listele (filtreleme ile) - ADMIN
  Future<List<LoanModel>> getAllLoans({
    String? status,
    int? userId,
    int? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (userId != null) queryParams['userId'] = userId;
      if (categoryId != null) queryParams['categoryId'] = categoryId;

      final response = await _apiClient.get(
        ApiConstants.adminLoans,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => LoanModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getAllLoans error: ${e.message}');
      throw Exception('Ödünçler yüklenemedi: ${e.message}');
    }
  }

  /// Bekleyen talepleri listele - ADMIN
  Future<List<LoanModel>> getPendingLoans() async {
    try {
      final response = await _apiClient.get(ApiConstants.adminLoansPending);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => LoanModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getPendingLoans error: ${e.message}');
      throw Exception('Bekleyen talepler yüklenemedi: ${e.message}');
    }
  }

  /// Gecikmiş ödünçleri listele - ADMIN
  Future<List<LoanModel>> getLateLoans() async {
    try {
      final response = await _apiClient.get(ApiConstants.adminLoansLate);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => LoanModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getLateLoans error: ${e.message}');
      throw Exception('Gecikmiş ödünçler yüklenemedi: ${e.message}');
    }
  }

  /// Ödünç talebini onayla - ADMIN
  Future<LoanModel> approveLoan(int loanId, int daysToLoan) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.adminLoanApprove(loanId),
        data: {'daysToLoan': daysToLoan},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return LoanModel.fromJson(data);
      } else {
        throw Exception('Onaylama başarısız: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Onaylama başarısız';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Ödünç talebini reddet - ADMIN
  Future<LoanModel> rejectLoan(int loanId, String reason) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.adminLoanReject(loanId),
        data: {'reason': reason},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return LoanModel.fromJson(data);
      } else {
        throw Exception('Red işlemi başarısız: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Red işlemi başarısız';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }
}
