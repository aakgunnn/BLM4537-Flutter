// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LibraryStatisticsImpl _$$LibraryStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$LibraryStatisticsImpl(
  totalBooks: (json['totalBooks'] as num?)?.toInt() ?? 0,
  availableBooks: (json['availableBooks'] as num?)?.toInt() ?? 0,
  totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
  totalLoans: (json['totalLoans'] as num?)?.toInt() ?? 0,
  activeLoans: (json['activeLoans'] as num?)?.toInt() ?? 0,
  pendingLoans: (json['pendingLoans'] as num?)?.toInt() ?? 0,
  lateLoans: (json['lateLoans'] as num?)?.toInt() ?? 0,
  returnedLoans: (json['returnedLoans'] as num?)?.toInt() ?? 0,
  totalCategories: (json['totalCategories'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$LibraryStatisticsImplToJson(
  _$LibraryStatisticsImpl instance,
) => <String, dynamic>{
  'totalBooks': instance.totalBooks,
  'availableBooks': instance.availableBooks,
  'totalUsers': instance.totalUsers,
  'totalLoans': instance.totalLoans,
  'activeLoans': instance.activeLoans,
  'pendingLoans': instance.pendingLoans,
  'lateLoans': instance.lateLoans,
  'returnedLoans': instance.returnedLoans,
  'totalCategories': instance.totalCategories,
};

_$CategoryStatisticsImpl _$$CategoryStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryStatisticsImpl(
  categoryId: (json['categoryId'] as num).toInt(),
  categoryName: json['categoryName'] as String,
  bookCount: (json['bookCount'] as num?)?.toInt() ?? 0,
  loanCount: (json['loanCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$CategoryStatisticsImplToJson(
  _$CategoryStatisticsImpl instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'bookCount': instance.bookCount,
  'loanCount': instance.loanCount,
};

_$MonthlyLoanStatisticsImpl _$$MonthlyLoanStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$MonthlyLoanStatisticsImpl(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  monthName: json['monthName'] as String,
  loanCount: (json['loanCount'] as num?)?.toInt() ?? 0,
  returnCount: (json['returnCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$MonthlyLoanStatisticsImplToJson(
  _$MonthlyLoanStatisticsImpl instance,
) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'monthName': instance.monthName,
  'loanCount': instance.loanCount,
  'returnCount': instance.returnCount,
};

_$TopBookImpl _$$TopBookImplFromJson(Map<String, dynamic> json) =>
    _$TopBookImpl(
      bookId: (json['bookId'] as num).toInt(),
      title: json['title'] as String,
      author: json['author'] as String,
      categoryName: json['categoryName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      loanCount: (json['loanCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TopBookImplToJson(_$TopBookImpl instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'title': instance.title,
      'author': instance.author,
      'categoryName': instance.categoryName,
      'imageUrl': instance.imageUrl,
      'loanCount': instance.loanCount,
    };
