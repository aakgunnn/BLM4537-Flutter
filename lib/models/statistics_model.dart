import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_model.freezed.dart';
part 'statistics_model.g.dart';

/// Genel kütüphane istatistikleri
@freezed
class LibraryStatistics with _$LibraryStatistics {
  const factory LibraryStatistics({
    @Default(0) int totalBooks,
    @Default(0) int availableBooks,
    @Default(0) int totalUsers,
    @Default(0) int totalLoans,
    @Default(0) int activeLoans,
    @Default(0) int pendingLoans,
    @Default(0) int lateLoans,
    @Default(0) int returnedLoans,
    @Default(0) int totalCategories,
  }) = _LibraryStatistics;

  factory LibraryStatistics.fromJson(Map<String, dynamic> json) =>
      _$LibraryStatisticsFromJson(json);
}

/// Kategori bazlı istatistikler
@freezed
class CategoryStatistics with _$CategoryStatistics {
  const factory CategoryStatistics({
    required int categoryId,
    required String categoryName,
    @Default(0) int bookCount,
    @Default(0) int loanCount,
  }) = _CategoryStatistics;

  factory CategoryStatistics.fromJson(Map<String, dynamic> json) =>
      _$CategoryStatisticsFromJson(json);
}

/// Aylık ödünç istatistikleri
@freezed
class MonthlyLoanStatistics with _$MonthlyLoanStatistics {
  const factory MonthlyLoanStatistics({
    required int year,
    required int month,
    required String monthName,
    @Default(0) int loanCount,
    @Default(0) int returnCount,
  }) = _MonthlyLoanStatistics;

  factory MonthlyLoanStatistics.fromJson(Map<String, dynamic> json) =>
      _$MonthlyLoanStatisticsFromJson(json);
}

/// En popüler kitaplar
@freezed
class TopBook with _$TopBook {
  const factory TopBook({
    required int bookId,
    required String title,
    required String author,
    String? categoryName,
    String? imageUrl,
    @Default(0) int loanCount,
  }) = _TopBook;

  factory TopBook.fromJson(Map<String, dynamic> json) =>
      _$TopBookFromJson(json);
}
