// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanModelImpl _$$LoanModelImplFromJson(Map<String, dynamic> json) =>
    _$LoanModelImpl(
      id: (json['id'] as num).toInt(),
      bookId: (json['bookId'] as num).toInt(),
      bookTitle: json['bookTitle'] as String,
      bookAuthor: json['bookAuthor'] as String,
      categoryName: json['categoryName'] as String,
      userId: (json['userId'] as num).toInt(),
      userFullName: json['userFullName'] as String,
      userEmail: json['userEmail'] as String,
      loanDate: DateTime.parse(json['loanDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      returnDate: json['returnDate'] == null
          ? null
          : DateTime.parse(json['returnDate'] as String),
      status: json['status'] as String,
      adminNote: json['adminNote'] as String?,
      isLate: json['isLate'] as bool? ?? false,
      daysRemaining: (json['daysRemaining'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LoanModelImplToJson(_$LoanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'bookAuthor': instance.bookAuthor,
      'categoryName': instance.categoryName,
      'userId': instance.userId,
      'userFullName': instance.userFullName,
      'userEmail': instance.userEmail,
      'loanDate': instance.loanDate.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'returnDate': instance.returnDate?.toIso8601String(),
      'status': instance.status,
      'adminNote': instance.adminNote,
      'isLate': instance.isLate,
      'daysRemaining': instance.daysRemaining,
    };
