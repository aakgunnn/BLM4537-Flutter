import 'package:dio/dio.dart';
import '../models/book_model.dart';
import '../core/constants/api_constants.dart';
import 'api_client.dart';

class BookService {
  final ApiClient _apiClient = ApiClient();

  /// Tüm kitapları getir
  Future<List<BookModel>> getAllBooks() async {
    try {
      final response = await _apiClient.get(ApiConstants.books);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => BookModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getAllBooks error: ${e.message}');
      throw Exception('Kitaplar yüklenemedi: ${e.message}');
    }
  }

  /// Kitap ara (başlık, yazar, kategori)
  Future<List<BookModel>> searchBooks({
    String? query,
    int? categoryId,
    String? author,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (query != null && query.isNotEmpty) queryParams['q'] = query;
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (author != null && author.isNotEmpty) queryParams['author'] = author;

      final response = await _apiClient.get(
        ApiConstants.booksSearch,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => BookModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ searchBooks error: ${e.message}');
      throw Exception('Arama başarısız: ${e.message}');
    }
  }

  /// ID'ye göre kitap getir
  Future<BookModel?> getBookById(int id) async {
    try {
      final response = await _apiClient.get(ApiConstants.bookById(id));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return BookModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('❌ getBookById error: ${e.message}');
      return null;
    }
  }

  /// Yeni kitap ekle (Admin)
  Future<BookModel> createBook({
    required String title,
    required String author,
    required int categoryId,
    String? isbn,
    int? publishYear,
    String? imageUrl,
    bool isAvailable = true,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.books,
        data: {
          'title': title,
          'author': author,
          'categoryId': categoryId,
          'isbn': isbn,
          'publishYear': publishYear,
          'imageUrl': imageUrl,
          'isAvailable': isAvailable,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return BookModel.fromJson(data);
      } else {
        throw Exception('Kitap eklenemedi: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kitap eklenemedi';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Kitap güncelle (Admin)
  Future<BookModel> updateBook({
    required int id,
    required String title,
    required String author,
    required int categoryId,
    String? isbn,
    int? publishYear,
    String? imageUrl,
    bool isAvailable = true,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.bookById(id),
        data: {
          'title': title,
          'author': author,
          'categoryId': categoryId,
          'isbn': isbn,
          'publishYear': publishYear,
          'imageUrl': imageUrl,
          'isAvailable': isAvailable,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return BookModel.fromJson(data);
      } else {
        throw Exception('Kitap güncellenemedi: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kitap güncellenemedi';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }

  /// Kitap sil (Admin)
  Future<bool> deleteBook(int id) async {
    try {
      final response = await _apiClient.delete(ApiConstants.bookById(id));

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('❌ deleteBook error: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Kitap silinemedi';
        throw Exception(message);
      }
      throw Exception('Bağlantı hatası: ${e.message}');
    }
  }
}
