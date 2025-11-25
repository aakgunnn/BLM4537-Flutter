import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/book_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../providers/book_provider.dart';
import '../../providers/category_provider.dart';

class BookManagementScreen extends ConsumerStatefulWidget {
  const BookManagementScreen({super.key});

  @override
  ConsumerState<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends ConsumerState<BookManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddBookDialog() async {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final isbnController = TextEditingController();
    final yearController = TextEditingController();
    final imageUrlController = TextEditingController();
    int? selectedCategoryId;

    final categories = await ref.read(activeCategoriesProvider.future);

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Kitap Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Kitap Adı *'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Yazar *'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Kategori *'),
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategoryId = value;
                },
              ),
              TextField(
                controller: isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
              ),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yayın Yılı'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Resim URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (confirmed != true || selectedCategoryId == null) return;

    try {
      await ref.read(bookServiceProvider).createBook(
            title: titleController.text,
            author: authorController.text,
            categoryId: selectedCategoryId!,
            isbn: isbnController.text.isEmpty ? null : isbnController.text,
            publishYear: int.tryParse(yearController.text),
            imageUrl: imageUrlController.text.isEmpty ? null : imageUrlController.text,
          );

      if (mounted) {
        ref.invalidate(allBooksProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kitap başarıyla eklendi!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Kitap eklenemedi';
        
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

  Future<void> _deleteBook(int bookId, String bookTitle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitabı Sil'),
        content: Text('$bookTitle kitabını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(bookServiceProvider).deleteBook(bookId);

      if (mounted) {
        ref.invalidate(allBooksProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kitap başarıyla silindi!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Kitap silinemedi';
        
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
    final filteredBooksAsync = ref.watch(filteredBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Yönetimi'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBookDialog,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Kitap'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Kitap ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          // Books List
          Expanded(
            child: filteredBooksAsync.when(
              data: (books) {
                if (books.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.book_outlined,
                    title: 'Kitap Bulunamadı',
                    subtitle: 'Yeni kitap eklemek için + butonuna tıklayın',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(allBooksProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Dismissible(
                        key: Key(book.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppColors.error,
                          child: const Icon(Icons.delete, color: AppColors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Kitabı Sil'),
                              content: Text('${book.title} kitabını silmek istediğinize emin misiniz?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('İptal'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                  child: const Text('Sil'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          _deleteBook(book.id, book.title);
                        },
                        child: BookCard(
                          book: book,
                          onTap: () {
                            // TODO: Show edit dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Düzenleme özelliği yakında eklenecek'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Kitaplar yüklenirken hata oluştu',
                onRetry: () {
                  ref.invalidate(allBooksProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
