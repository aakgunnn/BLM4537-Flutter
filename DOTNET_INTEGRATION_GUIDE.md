# 🔗 .NET Backend Entegrasyon Rehberi

## ✅ TAMAMLANAN DEĞİŞİKLİKLER

### 1. **Paketler ve Bağımlılıklar**
- ✅ `dio` paketi eklendi (HTTP client)
- ✅ `flutter_secure_storage` paketi eklendi (JWT token storage)
- ✅ Firebase paketleri kaldırıldı (firebase_core, firebase_auth, cloud_firestore, etc.)

### 2. **API Infrastructure**
- ✅ `lib/core/constants/api_constants.dart` - API endpoint'leri ve URL'ler
- ✅ `lib/services/api_client.dart` - Dio wrapper, JWT token management

**Base URL:**
```dart
// Android Emulator için
static const String baseUrl = 'http://10.0.2.2:5065/api';

// Web için
static const String baseUrlWeb = 'http://localhost:5065/api';

// iOS Simulator için
static const String baseUrlIOS = 'http://localhost:5065/api';
```

### 3. **Model Güncellemeleri**
Tüm model'ler .NET DTO yapısına uygun hale getirildi:

**Değişiklikler:**
- `String id` → `int id` (PostgreSQL identity)
- `BookModel`: `availableCopies`, `totalCopies` kaldırıldı → `bool isAvailable` eklendi
- `BookModel`: `categoryName` eklendi (backend'den geliyor)
- `LoanModel`: Tamamen yeniden yapılandırıldı (LoanResponseDto'ya uygun)
  - `bookTitle`, `bookAuthor`, `categoryName` eklendi
  - `userFullName`, `userEmail` eklendi
  - `isLate`, `daysRemaining` computed properties eklendi
- `UserModel`: Basitleştirildi (id, fullName, email, role)

### 4. **Service Güncellemeleri**
Tüm Firebase service'ler REST API service'lere dönüştürüldü:

#### ✅ **AuthService** (`lib/services/auth_service.dart`)
```dart
// Metodlar:
- register(fullName, email, password) → AuthResponse
- login(email, password) → AuthResponse
- getCurrentUser() → UserModel?
- logout()
- isLoggedIn() → bool
```

#### ✅ **BookService** (`lib/services/book_service.dart`)
```dart
// Metodlar:
- getAllBooks() → List<BookModel>
- searchBooks(query, categoryId, author) → List<BookModel>
- getBookById(id) → BookModel?
- createBook(...) → BookModel
- updateBook(id, ...) → BookModel
- deleteBook(id) → bool
```

#### ✅ **LoanService** (`lib/services/loan_service.dart`)
```dart
// User Endpoints:
- createLoanRequest(bookId) → LoanModel
- getMyLoans() → List<LoanModel>
- returnLoan(loanId) → LoanModel
- getLoanById(loanId) → LoanModel?

// Admin Endpoints:
- getAllLoans(status, userId, categoryId) → List<LoanModel>
- getPendingLoans() → List<LoanModel>
- getLateLoans() → List<LoanModel>
- approveLoan(loanId, daysToLoan) → LoanModel
- rejectLoan(loanId, reason) → LoanModel
```

#### ✅ **CategoryService** (`lib/services/category_service.dart`)
```dart
// Metodlar:
- getAllCategories() → List<CategoryModel>
- getActiveCategories() → List<CategoryModel>
- getCategoryById(id) → CategoryModel?
- createCategory(...) → CategoryModel
- updateCategory(id, ...) → CategoryModel
- deleteCategory(id) → bool
```

### 5. **Provider Güncellemeleri**
Stream provider'lar Future provider'lara dönüştürüldü:

#### ✅ **auth_provider.dart**
```dart
- authNotifierProvider → StateNotifierProvider<AuthNotifier, AuthState>
- currentUserProvider → FutureProvider<UserModel?>
- isLoggedInProvider → FutureProvider<bool>
- isAdminProvider → FutureProvider<bool>
```

#### ✅ **book_provider.dart**
```dart
- allBooksProvider → FutureProvider<List<BookModel>>
- bookByIdProvider → FutureProvider.family<BookModel?, int>
- searchBooksProvider → FutureProvider.family<List<BookModel>, SearchParams>
```

#### ✅ **loan_provider.dart**
```dart
- myLoansProvider → FutureProvider<List<LoanModel>>
- allLoansProvider → FutureProvider<List<LoanModel>>
- pendingLoansProvider → FutureProvider<List<LoanModel>>
- lateLoansProvider → FutureProvider<List<LoanModel>>
- loanByIdProvider → FutureProvider.family<LoanModel?, int>
- filteredLoansProvider → FutureProvider.family<List<LoanModel>, LoanFilter>
```

#### ✅ **category_provider.dart**
```dart
- allCategoriesProvider → FutureProvider<List<CategoryModel>>
- activeCategoriesProvider → FutureProvider<List<CategoryModel>>
- categoryByIdProvider → FutureProvider.family<CategoryModel?, int>
```

### 6. **Silinen Dosyalar**
- ❌ `lib/services/seed_service.dart` (.NET backend kendi seed'ini yapıyor)
- ❌ `lib/core/utils/firebase_config.dart`
- ❌ `lib/firebase_options.dart`

### 7. **Güncellenen Dosyalar**
- ✅ `lib/main.dart` - Firebase initialization kaldırıldı
- ✅ `lib/core/utils/router.dart` - authStateProvider → authNotifierProvider
- ✅ `lib/screens/auth/splash_screen.dart` - Yeni auth yapısına uyarlandı
- ✅ `pubspec.yaml` - Firebase paketleri kaldırıldı, dio ve flutter_secure_storage eklendi

---

## ⚠️ GÜNCELLENMESİ GEREKEN EKRANLAR

Aşağıdaki ekranlar henüz yeni API yapısına uyarlanmadı ve hata verecektir:

### 🔴 **Acil Güncelleme Gerekiyor:**

1. **lib/screens/auth/login_screen.dart**
   - `authService.signInWithEmailAndPassword()` → `authNotifier.login()`
   - Error handling düzenlenmeli

2. **lib/screens/auth/register_screen.dart**
   - `authService.createUserWithEmailAndPassword()` → `authNotifier.register()`
   - Error handling düzenlenmeli

3. **lib/screens/user/home_screen.dart**
   - `allBooksProvider` kullanımı değişmedi ama widget'lar güncellenmeli
   - `BookCard` widget'ı `isAvailable` boolean'ı kullanmalı (`availableCopies` yerine)

4. **lib/screens/user/book_detail_screen.dart**
   - `bookId` parametresi `String` → `int`
   - `bookByIdProvider` family provider kullanımı güncellenmeli
   - `isAvailable` kontrolü yapılmalı

5. **lib/screens/user/profile_screen.dart**
   - `currentUserProvider` ve `myLoansProvider` kullanımı güncellenmeli
   - Stream → Future yapısına uyarlanmalı

6. **lib/screens/admin/admin_dashboard_screen.dart**
   - Tüm provider'lar Future'a dönüştü, `.when()` kullanımı güncellenmeli
   - İstatistik hesaplamaları model değişikliklerine göre düzenlenmeli

7. **lib/screens/admin/book_management_screen.dart**
   - `createBook()`, `updateBook()`, `deleteBook()` metodları güncellenmeli
   - `isAvailable` boolean'ı kullanılmalı
   - ID'ler int olarak işlenmeli

8. **lib/screens/admin/loan_management_screen.dart**
   - `pendingLoansProvider`, `allLoansProvider`, `lateLoansProvider` Future'a dönüştü
   - `approveLoan()`, `rejectLoan()` metodları güncellenmeli
   - `ref.refresh()` ile manuel refresh eklenmeli

9. **lib/widgets/common/book_card.dart**
   - `book.availableCopies > 0` → `book.isAvailable`
   - `categoryId` int olarak işlenmeli

---

## 🚀 NASIL TEST EDİLİR

### 1. .NET Backend'i Başlatın

```bash
cd C:\Users\90506\source\repos\Library.Net2\Library.Net2
dotnet run
```

Backend'in çalıştığından emin olun: **http://localhost:5065/swagger**

### 2. API Constants'ı Güncelleyin (Gerekirse)

Eğer .NET API farklı bir portta çalışıyorsa, `lib/core/constants/api_constants.dart` dosyasındaki `baseUrl`'i güncelleyin.

### 3. Flutter Uygulamasını Çalıştırın

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d emulator-5554
```

### 4. Test Senaryoları

#### ✅ **Authentication Testi**
1. Kayıt ol (Register)
2. Giriş yap (Login)
3. Token'ın secure storage'a kaydedildiğini kontrol et
4. Çıkış yap (Logout)

#### ✅ **Books Testi**
1. Kitap listesini görüntüle
2. Kitap ara (search)
3. Kitap detayına git
4. Admin olarak kitap ekle/düzenle/sil

#### ✅ **Loans Testi**
1. User olarak ödünç talebi oluştur
2. Admin olarak talebi görüntüle
3. Talebi onayla
4. Kitabı iade et

---

## 📝 NOTLAR

### JWT Token Management
- Token otomatik olarak `FlutterSecureStorage` ile saklanır
- Her API isteğinde `Authorization: Bearer {token}` header'ı eklenir
- Token expired olursa otomatik logout yapılır

### Real-Time Updates
- Firebase Streams yerine manual refresh kullanılıyor
- `ref.refresh(providerName)` ile provider'lar yenileniyor
- Kritik işlemlerden sonra (approve, reject, create) refresh yapılmalı

### Error Handling
- Dio interceptor'lar ile detaylı log'lama yapılıyor
- HTTP hataları `DioException` olarak yakalanıyor
- Error mesajları backend'den `.data['message']` ile alınıyor

### Model Compatibility
- .NET'teki `int Id` → Flutter'da `int id`
- .NET'teki `PascalCase` → Flutter'da `camelCase` (JSON serialization otomatik handle ediyor)
- DateTime'lar ISO 8601 string olarak serialize ediliyor

---

## 🔧 GELECEKTEKİ İYİLEŞTİRMELER

1. **SignalR Entegrasyonu**: Real-time updates için SignalR WebSocket bağlantısı
2. **Offline Support**: Hive/Isar ile local cache
3. **Retry Mechanism**: Failed requests için otomatik retry
4. **Pagination**: Büyük listeler için sayfalama
5. **Image Upload**: Book cover upload için multipart/form-data

---

**Tarih:** 24 Kasım 2025  
**Proje:** Kütüphane Yönetim Sistemi  
**Backend:** .NET 8 + PostgreSQL  
**Frontend:** Flutter 3.35.7 + Dart 3.9.2

