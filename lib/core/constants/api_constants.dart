class ApiConstants {
  // Base URL - .NET API'nin çalıştığı adres
  // localhost için Android emülatörden erişim: 10.0.2.2
  // localhost için iOS simulator: localhost
  // localhost için web: localhost
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // Alternative URLs (gerekirse değiştirilebilir)
  static const String baseUrlWeb = 'http://localhost:5000/api';
  static const String baseUrlIOS = 'http://localhost:5000/api';
  
  // Auth endpoints
  static const String authLogin = '/Auth/login';
  static const String authRegister = '/Auth/register';
  static const String authMe = '/Auth/me';
  
  // Book endpoints
  static const String books = '/Books';
  static const String booksSearch = '/Books/search';
  static String bookById(int id) => '/Books/$id';
  
  // Category endpoints
  static const String categories = '/Categories';
  static const String categoriesActive = '/Categories/active';
  static String categoryById(int id) => '/Categories/$id';
  
  // Loan endpoints (User)
  static const String loans = '/Loans';
  static const String loansMyLoans = '/Loans/my';
  static String loanReturn(int id) => '/Loans/$id/return';
  static String loanById(int id) => '/Loans/$id';
  
  // Admin Loan endpoints
  static const String adminLoans = '/Admin/Loans';
  static const String adminLoansPending = '/Admin/Loans/pending';
  static const String adminLoansLate = '/Admin/Loans/late';
  static String adminLoanApprove(int id) => '/Admin/Loans/$id/approve';
  static String adminLoanReject(int id) => '/Admin/Loans/$id/reject';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

