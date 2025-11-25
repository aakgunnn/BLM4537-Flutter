import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/book_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/category_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.logout();
      if (mounted) {
        context.go('/auth/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Çıkış başarısız: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final filteredBooksAsync = ref.watch(filteredBooksProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: currentUserAsync.when(
          data: (user) => Text('Merhaba, ${user?.fullName ?? 'Kullanıcı'}'),
          loading: () => const Text('Yükleniyor...'),
          error: (_, __) => const Text('Kütüphane'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Kitap ara (başlık veya yazar)',
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
          // Categories
          categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) return const SizedBox();
              return SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // All Books Chip
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Tümü'),
                        selected: selectedCategory == null,
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        onSelected: (_) {
                          ref.read(selectedCategoryProvider.notifier).state = null;
                        },
                      ),
                    ),
                    // Category Chips
                    ...categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: selectedCategory == category.id,
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          onSelected: (_) {
                            ref.read(selectedCategoryProvider.notifier).state =
                                category.id;
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 8),
          // Books List
          Expanded(
            child: filteredBooksAsync.when(
              data: (books) {
                if (books.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'Kitap Bulunamadı',
                    subtitle: _searchController.text.isEmpty
                        ? 'Henüz eklenmiş kitap yok'
                        : 'Aradığınız kriterlere uygun kitap bulunamadı',
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
                      return BookCard(
                        book: book,
                        onTap: () => context.push('/book/${book.id}'),
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
