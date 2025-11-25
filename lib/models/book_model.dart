import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
class BookModel with _$BookModel {
  const factory BookModel({
    required int id,
    required String title,
    required String author,
    required int categoryId,
    required String categoryName,
    String? isbn,
    int? publishYear,
    String? imageUrl,
    @Default(true) bool isAvailable,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
}
