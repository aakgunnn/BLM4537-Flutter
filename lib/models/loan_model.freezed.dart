// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoanModel _$LoanModelFromJson(Map<String, dynamic> json) {
  return _LoanModel.fromJson(json);
}

/// @nodoc
mixin _$LoanModel {
  int get id => throw _privateConstructorUsedError; // Book Info
  int get bookId => throw _privateConstructorUsedError;
  String get bookTitle => throw _privateConstructorUsedError;
  String get bookAuthor => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError; // User Info
  int get userId => throw _privateConstructorUsedError;
  String get userFullName => throw _privateConstructorUsedError;
  String get userEmail => throw _privateConstructorUsedError; // Loan Info
  DateTime get loanDate => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get returnDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // Pending, Borrowed, Returned, Late, Cancelled
  String? get adminNote =>
      throw _privateConstructorUsedError; // Computed properties
  bool get isLate => throw _privateConstructorUsedError;
  int? get daysRemaining => throw _privateConstructorUsedError;

  /// Serializes this LoanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanModelCopyWith<LoanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanModelCopyWith<$Res> {
  factory $LoanModelCopyWith(LoanModel value, $Res Function(LoanModel) then) =
      _$LoanModelCopyWithImpl<$Res, LoanModel>;
  @useResult
  $Res call({
    int id,
    int bookId,
    String bookTitle,
    String bookAuthor,
    String categoryName,
    int userId,
    String userFullName,
    String userEmail,
    DateTime loanDate,
    DateTime? dueDate,
    DateTime? returnDate,
    String status,
    String? adminNote,
    bool isLate,
    int? daysRemaining,
  });
}

/// @nodoc
class _$LoanModelCopyWithImpl<$Res, $Val extends LoanModel>
    implements $LoanModelCopyWith<$Res> {
  _$LoanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? categoryName = null,
    Object? userId = null,
    Object? userFullName = null,
    Object? userEmail = null,
    Object? loanDate = null,
    Object? dueDate = freezed,
    Object? returnDate = freezed,
    Object? status = null,
    Object? adminNote = freezed,
    Object? isLate = null,
    Object? daysRemaining = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as int,
            bookTitle: null == bookTitle
                ? _value.bookTitle
                : bookTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            bookAuthor: null == bookAuthor
                ? _value.bookAuthor
                : bookAuthor // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            userFullName: null == userFullName
                ? _value.userFullName
                : userFullName // ignore: cast_nullable_to_non_nullable
                      as String,
            userEmail: null == userEmail
                ? _value.userEmail
                : userEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            loanDate: null == loanDate
                ? _value.loanDate
                : loanDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            returnDate: freezed == returnDate
                ? _value.returnDate
                : returnDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            adminNote: freezed == adminNote
                ? _value.adminNote
                : adminNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLate: null == isLate
                ? _value.isLate
                : isLate // ignore: cast_nullable_to_non_nullable
                      as bool,
            daysRemaining: freezed == daysRemaining
                ? _value.daysRemaining
                : daysRemaining // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoanModelImplCopyWith<$Res>
    implements $LoanModelCopyWith<$Res> {
  factory _$$LoanModelImplCopyWith(
    _$LoanModelImpl value,
    $Res Function(_$LoanModelImpl) then,
  ) = __$$LoanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int bookId,
    String bookTitle,
    String bookAuthor,
    String categoryName,
    int userId,
    String userFullName,
    String userEmail,
    DateTime loanDate,
    DateTime? dueDate,
    DateTime? returnDate,
    String status,
    String? adminNote,
    bool isLate,
    int? daysRemaining,
  });
}

/// @nodoc
class __$$LoanModelImplCopyWithImpl<$Res>
    extends _$LoanModelCopyWithImpl<$Res, _$LoanModelImpl>
    implements _$$LoanModelImplCopyWith<$Res> {
  __$$LoanModelImplCopyWithImpl(
    _$LoanModelImpl _value,
    $Res Function(_$LoanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? categoryName = null,
    Object? userId = null,
    Object? userFullName = null,
    Object? userEmail = null,
    Object? loanDate = null,
    Object? dueDate = freezed,
    Object? returnDate = freezed,
    Object? status = null,
    Object? adminNote = freezed,
    Object? isLate = null,
    Object? daysRemaining = freezed,
  }) {
    return _then(
      _$LoanModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as int,
        bookTitle: null == bookTitle
            ? _value.bookTitle
            : bookTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        bookAuthor: null == bookAuthor
            ? _value.bookAuthor
            : bookAuthor // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        userFullName: null == userFullName
            ? _value.userFullName
            : userFullName // ignore: cast_nullable_to_non_nullable
                  as String,
        userEmail: null == userEmail
            ? _value.userEmail
            : userEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        loanDate: null == loanDate
            ? _value.loanDate
            : loanDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        returnDate: freezed == returnDate
            ? _value.returnDate
            : returnDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        adminNote: freezed == adminNote
            ? _value.adminNote
            : adminNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLate: null == isLate
            ? _value.isLate
            : isLate // ignore: cast_nullable_to_non_nullable
                  as bool,
        daysRemaining: freezed == daysRemaining
            ? _value.daysRemaining
            : daysRemaining // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanModelImpl implements _LoanModel {
  const _$LoanModelImpl({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.categoryName,
    required this.userId,
    required this.userFullName,
    required this.userEmail,
    required this.loanDate,
    this.dueDate,
    this.returnDate,
    required this.status,
    this.adminNote,
    this.isLate = false,
    this.daysRemaining,
  });

  factory _$LoanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanModelImplFromJson(json);

  @override
  final int id;
  // Book Info
  @override
  final int bookId;
  @override
  final String bookTitle;
  @override
  final String bookAuthor;
  @override
  final String categoryName;
  // User Info
  @override
  final int userId;
  @override
  final String userFullName;
  @override
  final String userEmail;
  // Loan Info
  @override
  final DateTime loanDate;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? returnDate;
  @override
  final String status;
  // Pending, Borrowed, Returned, Late, Cancelled
  @override
  final String? adminNote;
  // Computed properties
  @override
  @JsonKey()
  final bool isLate;
  @override
  final int? daysRemaining;

  @override
  String toString() {
    return 'LoanModel(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, categoryName: $categoryName, userId: $userId, userFullName: $userFullName, userEmail: $userEmail, loanDate: $loanDate, dueDate: $dueDate, returnDate: $returnDate, status: $status, adminNote: $adminNote, isLate: $isLate, daysRemaining: $daysRemaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookAuthor, bookAuthor) ||
                other.bookAuthor == bookAuthor) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userFullName, userFullName) ||
                other.userFullName == userFullName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.loanDate, loanDate) ||
                other.loanDate == loanDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.returnDate, returnDate) ||
                other.returnDate == returnDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adminNote, adminNote) ||
                other.adminNote == adminNote) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.daysRemaining, daysRemaining) ||
                other.daysRemaining == daysRemaining));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    bookId,
    bookTitle,
    bookAuthor,
    categoryName,
    userId,
    userFullName,
    userEmail,
    loanDate,
    dueDate,
    returnDate,
    status,
    adminNote,
    isLate,
    daysRemaining,
  );

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanModelImplCopyWith<_$LoanModelImpl> get copyWith =>
      __$$LoanModelImplCopyWithImpl<_$LoanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanModelImplToJson(this);
  }
}

abstract class _LoanModel implements LoanModel {
  const factory _LoanModel({
    required final int id,
    required final int bookId,
    required final String bookTitle,
    required final String bookAuthor,
    required final String categoryName,
    required final int userId,
    required final String userFullName,
    required final String userEmail,
    required final DateTime loanDate,
    final DateTime? dueDate,
    final DateTime? returnDate,
    required final String status,
    final String? adminNote,
    final bool isLate,
    final int? daysRemaining,
  }) = _$LoanModelImpl;

  factory _LoanModel.fromJson(Map<String, dynamic> json) =
      _$LoanModelImpl.fromJson;

  @override
  int get id; // Book Info
  @override
  int get bookId;
  @override
  String get bookTitle;
  @override
  String get bookAuthor;
  @override
  String get categoryName; // User Info
  @override
  int get userId;
  @override
  String get userFullName;
  @override
  String get userEmail; // Loan Info
  @override
  DateTime get loanDate;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get returnDate;
  @override
  String get status; // Pending, Borrowed, Returned, Late, Cancelled
  @override
  String? get adminNote; // Computed properties
  @override
  bool get isLate;
  @override
  int? get daysRemaining;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanModelImplCopyWith<_$LoanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
