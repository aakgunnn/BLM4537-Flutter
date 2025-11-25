class AppConstants {
  // App Info
  static const String appName = 'Kütüphane Yönetim Sistemi';
  static const String appVersion = '1.0.0';
  
  // Firebase Collection Names
  static const String usersCollection = 'users';
  static const String booksCollection = 'books';
  static const String categoriesCollection = 'categories';
  static const String loansCollection = 'loans';
  
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleMember = 'member';
  
  // Loan Status
  static const String loanStatusPending = 'pending';
  static const String loanStatusBorrowed = 'borrowed';
  static const String loanStatusReturned = 'returned';
  static const String loanStatusLate = 'late';
  static const String loanStatusCancelled = 'cancelled';
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Loan Duration (days)
  static const int loanDurationDays = 14;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxBookTitleLength = 100;
  static const int maxAuthorNameLength = 50;
}

