import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/book_service.dart';
import '../models/book_model.dart';

// Book Service Provider
final bookServiceProvider = Provider<BookService>((ref) => BookService());

// All Books Provider
final allBooksProvider = FutureProvider<List<BookModel>>((ref) async {
  try {
    final bookService = ref.watch(bookServiceProvider);
    final books = await bookService.getAllBooks();
    print('📚 Loaded ${books.length} books');
    return books;
  } catch (e) {
    print('❌ allBooksProvider error: $e');
    return [];
  }
});

// Single Book Provider
final bookByIdProvider = FutureProvider.family<BookModel?, int>((ref, id) async {
  try {
    final bookService = ref.watch(bookServiceProvider);
    return await bookService.getBookById(id);
  } catch (e) {
    print('❌ bookByIdProvider error: $e');
    return null;
  }
});

// Search Books Provider
final searchBooksProvider = FutureProvider.family<List<BookModel>, SearchParams>((ref, params) async {
  try {
    final bookService = ref.watch(bookServiceProvider);
    return await bookService.searchBooks(
      query: params.query,
      categoryId: params.categoryId,
      author: params.author,
    );
  } catch (e) {
    print('❌ searchBooksProvider error: $e');
    return [];
  }
});

// Search Parameters
class SearchParams {
  final String? query;
  final int? categoryId;
  final String? author;

  SearchParams({this.query, this.categoryId, this.author});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          categoryId == other.categoryId &&
          author == other.author;

  @override
  int get hashCode => query.hashCode ^ categoryId.hashCode ^ author.hashCode;
}

// Search Query State Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected Category State Provider
final selectedCategoryProvider = StateProvider<int?>((ref) => null);

// Filtered Books Provider (with search and category filter)
final filteredBooksProvider = FutureProvider<List<BookModel>>((ref) async {
  try {
    final allBooks = await ref.watch(allBooksProvider.future);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final selectedCategory = ref.watch(selectedCategoryProvider);

    var filtered = allBooks;
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((book) {
        return book.title.toLowerCase().contains(searchQuery) ||
            book.author.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Filter by category
    if (selectedCategory != null) {
      filtered = filtered.where((book) => book.categoryId == selectedCategory).toList();
    }
    return filtered;
  } catch (e) {
    print('❌ filteredBooksProvider error: $e');
    return [];
  }
});
