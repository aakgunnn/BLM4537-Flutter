import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../providers/loan_provider.dart';

class LoanManagementScreen extends ConsumerStatefulWidget {
  const LoanManagementScreen({super.key});

  @override
  ConsumerState<LoanManagementScreen> createState() =>
      _LoanManagementScreenState();
}

class _LoanManagementScreenState extends ConsumerState<LoanManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  Future<void> _approveLoan(int loanId) async {
    // Ask for loan duration
    final TextEditingController daysController = TextEditingController(text: '14');
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Talebi Onayla'),
        content: TextField(
          controller: daysController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Ödünç Süresi (Gün)',
            hintText: '14',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Onayla'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final days = int.tryParse(daysController.text) ?? 14;
      await ref.read(loanServiceProvider).approveLoan(loanId, days);

      if (mounted) {
        // Refresh all loan providers
        ref.invalidate(pendingLoansProvider);
        ref.invalidate(allLoansProvider);
        ref.invalidate(lateLoansProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Talep onaylandı!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Onaylama başarısız';
        
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

  Future<void> _rejectLoan(int loanId) async {
    final TextEditingController reasonController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Talebi Reddet'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Red Sebebi (Opsiyonel)',
            hintText: 'Reddetme sebebini yazınız...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reddet'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(loanServiceProvider).rejectLoan(
        loanId,
        reasonController.text.isEmpty ? 'Admin tarafından reddedildi' : reasonController.text,
      );

      if (mounted) {
        // Refresh all loan providers
        ref.invalidate(pendingLoansProvider);
        ref.invalidate(allLoansProvider);
        ref.invalidate(lateLoansProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Talep reddedildi'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Red işlemi başarısız';
        
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödünç Yönetimi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Bekleyen'),
            Tab(text: 'Tümü'),
            Tab(text: 'Gecikmeler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingLoans(),
          _buildAllLoans(),
          _buildLateLoans(),
        ],
      ),
    );
  }

  Widget _buildPendingLoans() {
    final loansAsync = ref.watch(pendingLoansProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(pendingLoansProvider);
      },
      child: loansAsync.when(
        data: (loans) {
          if (loans.isEmpty) {
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: EmptyStateWidget(
                  icon: Icons.check_circle_outline,
                  title: 'Bekleyen Talep Yok',
                  subtitle: 'Tüm talepler işlendi',
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _buildLoanCard(loan, showActions: true);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Bekleyen talepler yüklenirken hata oluştu',
          onRetry: () {
            ref.invalidate(pendingLoansProvider);
          },
        ),
      ),
    );
  }

  Widget _buildAllLoans() {
    final loansAsync = ref.watch(allLoansProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allLoansProvider);
      },
      child: loansAsync.when(
        data: (loans) {
          if (loans.isEmpty) {
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: EmptyStateWidget(
                  icon: Icons.library_books_outlined,
                  title: 'Henüz Ödünç Kaydı Yok',
                  subtitle: 'Kullanıcılar ödünç talebi oluşturduğunda burada görünecek',
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _buildLoanCard(loan);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Ödünçler yüklenirken hata oluştu',
          onRetry: () {
            ref.invalidate(allLoansProvider);
          },
        ),
      ),
    );
  }

  Widget _buildLateLoans() {
    final loansAsync = ref.watch(lateLoansProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(lateLoansProvider);
      },
      child: loansAsync.when(
        data: (loans) {
          if (loans.isEmpty) {
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: EmptyStateWidget(
                  icon: Icons.check_circle_outline,
                  title: 'Gecikmiş Ödünç Yok',
                  subtitle: 'Harika! Herkes kitaplarını zamanında iade ediyor',
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _buildLoanCard(loan);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gecikmiş ödünçler yüklenirken hata oluştu',
          onRetry: () {
            ref.invalidate(lateLoansProvider);
          },
        ),
      ),
    );
  }

  Widget _buildLoanCard(dynamic loan, {bool showActions = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
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
                    ],
                  ),
                ),
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
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    loan.userFullName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    loan.userEmail,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Text(
                  'Talep: ${_formatDate(loan.loanDate)}',
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
            if (loan.isLate) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.warning, size: 16, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    'GECİKMİŞ!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
            if (loan.adminNote != null && loan.adminNote!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note, size: 16, color: AppColors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loan.adminNote!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (showActions && loan.status.toLowerCase() == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approveLoan(loan.id),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Onayla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _rejectLoan(loan.id),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reddet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
