import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/loan_service.dart';
import '../models/loan_model.dart';

// Loan Service Provider
final loanServiceProvider = Provider<LoanService>((ref) => LoanService());

// My Loans Provider (User)
final myLoansProvider = FutureProvider<List<LoanModel>>((ref) async {
  try {
    final loanService = ref.watch(loanServiceProvider);
    final loans = await loanService.getMyLoans();
    print('📋 Loaded ${loans.length} my loans');
    return loans;
  } catch (e) {
    print('❌ myLoansProvider error: $e');
    return [];
  }
});

// All Loans Provider (Admin)
final allLoansProvider = FutureProvider<List<LoanModel>>((ref) async {
  try {
    final loanService = ref.watch(loanServiceProvider);
    final loans = await loanService.getAllLoans();
    print('📋 Loaded ${loans.length} all loans');
    return loans;
  } catch (e) {
    print('❌ allLoansProvider error: $e');
    return [];
  }
});

// Pending Loans Provider (Admin)
final pendingLoansProvider = FutureProvider<List<LoanModel>>((ref) async {
  try {
    final loanService = ref.watch(loanServiceProvider);
    final loans = await loanService.getPendingLoans();
    print('📋 Loaded ${loans.length} pending loans');
    return loans;
  } catch (e) {
    print('❌ pendingLoansProvider error: $e');
    return [];
  }
});

// Late Loans Provider (Admin)
final lateLoansProvider = FutureProvider<List<LoanModel>>((ref) async {
  try {
    final loanService = ref.watch(loanServiceProvider);
    final loans = await loanService.getLateLoans();
    print('📋 Loaded ${loans.length} late loans');
    return loans;
  } catch (e) {
    print('❌ lateLoansProvider error: $e');
    return [];
  }
});

// Loan By ID Provider
final loanByIdProvider = FutureProvider.family<LoanModel?, int>((ref, id) async {
  try {
    final loanService = ref.watch(loanServiceProvider);
    return await loanService.getLoanById(id);
  } catch (e) {
    print('❌ loanByIdProvider error: $e');
    return null;
  }
});

// Filtered Loans Provider (Admin)
final filteredLoansProvider = FutureProvider.family<List<LoanModel>, LoanFilter>((ref, filter) async {
  try {
    final loanService = ref.watch(loanServiceProvider);
    return await loanService.getAllLoans(
      status: filter.status,
      userId: filter.userId,
      categoryId: filter.categoryId,
    );
  } catch (e) {
    print('❌ filteredLoansProvider error: $e');
    return [];
  }
});

// Loan Filter Parameters
class LoanFilter {
  final String? status;
  final int? userId;
  final int? categoryId;

  LoanFilter({this.status, this.userId, this.categoryId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanFilter &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          userId == other.userId &&
          categoryId == other.categoryId;

  @override
  int get hashCode => status.hashCode ^ userId.hashCode ^ categoryId.hashCode;
}
