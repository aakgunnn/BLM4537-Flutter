import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/loan_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'borrowed':
        return AppColors.info;
      case 'returned':
        return AppColors.success;
      case 'late':
        return AppColors.error;
      case 'cancelled':
        return AppColors.grey;
      default:
        return AppColors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Beklemede';
      case 'borrowed':
        return 'Ödünç Alındı';
      case 'returned':
        return 'İade Edildi';
      case 'late':
        return 'Gecikmiş';
      case 'cancelled':
        return 'İptal Edildi';
      default:
        return status;
    }
  }

  Future<void> _returnBook(BuildContext context, WidgetRef ref, int loanId) async {
    try {
      await ref.read(loanServiceProvider).returnLoan(loanId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kitap başarıyla iade edildi!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Refresh the loans list
        ref.invalidate(myLoansProvider);
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = 'İade işlemi başarısız';
        
        final errorStr = e.toString();
        if (errorStr.contains('Exception:')) {
          errorMessage = errorStr.replaceFirst('Exception:', '').trim();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final myLoansAsync = ref.watch(myLoansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          ref.invalidate(myLoansProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // User Info Card
              currentUserAsync.when(
                data: (user) {
                  if (user == null) return const SizedBox();
                  return Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 32,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: user.role.toLowerCase() == 'admin'
                                  ? AppColors.error.withOpacity(0.1)
                                  : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.role.toLowerCase() == 'admin' ? 'Admin' : 'Üye',
                              style: TextStyle(
                                color: user.role.toLowerCase() == 'admin'
                                    ? AppColors.error
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: LoadingWidget(),
                ),
                error: (_, __) => const SizedBox(),
              ),

              // Loans Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.library_books, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Ödünç Aldığım Kitaplar',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              // Loans List
              myLoansAsync.when(
                data: (loans) {
                  if (loans.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: EmptyStateWidget(
                        icon: Icons.book_outlined,
                        title: 'Henüz ödünç kitap yok',
                        subtitle: 'Kütüphanedeki kitaplara göz atarak ödünç alabilirsiniz',
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      final loan = loans[index];
                      final canReturn = loan.status.toLowerCase() == 'borrowed';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loan.bookTitle,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                loan.bookAuthor,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(loan.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getStatusText(loan.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getStatusColor(loan.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Alış: ${_formatDate(loan.loanDate)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (loan.dueDate != null) ...[
                                    const SizedBox(width: 16),
                                    const Icon(Icons.event, size: 16, color: AppColors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      'İade: ${_formatDate(loan.dueDate!)}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ],
                              ),
                              if (loan.isLate)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.warning, size: 16, color: AppColors.error),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Gecikmiş!',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (canReturn) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _returnBook(context, ref, loan.id),
                                    icon: const Icon(Icons.assignment_return, size: 18),
                                    label: const Text('İade Et'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: LoadingWidget(),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomErrorWidget(
                    message: 'Ödünçler yüklenirken hata oluştu',
                    onRetry: () {
                      ref.invalidate(myLoansProvider);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
