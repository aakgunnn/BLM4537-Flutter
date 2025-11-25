import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../providers/book_provider.dart';
import '../../providers/loan_provider.dart';
import '../../providers/auth_provider.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  Future<void> _requestLoan(BuildContext context, WidgetRef ref, int bookIdInt) async {
    try {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lütfen giriş yapın'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      final loanService = ref.read(loanServiceProvider);
      await loanService.createLoanRequest(bookIdInt);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ödünç alma talebi oluşturuldu! Admin onayını bekleyiniz.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = 'Talep oluşturulamadı';
        
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
    final bookIdInt = int.tryParse(bookId) ?? 0;
    final bookAsync = ref.watch(bookByIdProvider(bookIdInt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Detayı'),
      ),
      body: bookAsync.when(
        data: (book) {
          if (book == null) {
            return const CustomErrorWidget(
              message: 'Kitap bulunamadı',
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                if (book.imageUrl != null && book.imageUrl!.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: book.imageUrl!.startsWith('http')
                              ? book.imageUrl!
                              : 'http://10.0.2.2:5000${book.imageUrl}',
                          height: 300,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 300,
                            color: AppColors.greyLight,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 300,
                            color: AppColors.greyLight,
                            child: const Icon(Icons.book, size: 100),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Book Info
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.author,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.categoryName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: book.isAvailable
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.isAvailable ? 'Mevcut' : 'Mevcut Değil',
                          style: TextStyle(
                            color: book.isAvailable
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (book.publishYear != null) ...[
                        _buildInfoRow(
                          context,
                          'Yayın Yılı',
                          book.publishYear.toString(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (book.isbn != null && book.isbn!.isNotEmpty) ...[
                        _buildInfoRow(context, 'ISBN', book.isbn!),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Kitap yüklenirken hata oluştu',
          onRetry: () {
            ref.invalidate(bookByIdProvider(bookIdInt));
          },
        ),
      ),
      bottomNavigationBar: bookAsync.when(
        data: (book) {
          if (book == null || !book.isAvailable) return null;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _requestLoan(context, ref, bookIdInt),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Ödünç Al',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
