import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_model.freezed.dart';
part 'loan_model.g.dart';

@freezed
class LoanModel with _$LoanModel {
  const factory LoanModel({
    required int id,
    // Book Info
    required int bookId,
    required String bookTitle,
    required String bookAuthor,
    required String categoryName,
    // User Info
    required int userId,
    required String userFullName,
    required String userEmail,
    // Loan Info
    required DateTime loanDate,
    DateTime? dueDate,
    DateTime? returnDate,
    required String status, // Pending, Borrowed, Returned, Late, Cancelled
    String? adminNote,
    // Computed properties
    @Default(false) bool isLate,
    int? daysRemaining,
  }) = _LoanModel;

  factory LoanModel.fromJson(Map<String, dynamic> json) =>
      _$LoanModelFromJson(json);
}
