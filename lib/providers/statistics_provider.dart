import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/statistics_model.dart';
import '../services/statistics_service.dart';

/// Statistics service provider
final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService();
});

/// Genel kütüphane istatistikleri provider
final libraryStatisticsProvider = FutureProvider<LibraryStatistics>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getLibraryStatistics();
});

/// Kategori istatistikleri provider
final categoryStatisticsProvider = FutureProvider<List<CategoryStatistics>>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getCategoryStatistics();
});

/// Aylık ödünç istatistikleri provider
final monthlyLoanStatisticsProvider = FutureProvider<List<MonthlyLoanStatistics>>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getMonthlyLoanStatistics();
});

/// En popüler kitaplar provider
final topBooksProvider = FutureProvider<List<TopBook>>((ref) async {
  final service = ref.watch(statisticsServiceProvider);
  return await service.getTopBooks();
});
