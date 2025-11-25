# Kütüphane Yönetim Sistemi

**Ankara Üniversitesi - Bilgisayar Mühendisliği Bölümü**  
Mobil Uygulama Geliştirme Dersi - Dönem Projesi

## 📱 Proje Hakkında

Flutter ve Firebase kullanılarak geliştirilen iOS kütüphane yönetim sistemi uygulaması. Kullanıcılar kitap arayabilir, ödünç alabilir ve iade edebilir. Yöneticiler ise katalog, stok ve ödünç yönetimi yapabilir.

## 🎯 Özellikler

### Kullanıcı (Üye) Özellikleri
- ✅ Firebase Authentication ile kayıt/giriş
- ✅ Kitap arama ve filtreleme
- ✅ Kategori bazlı listeleme
- ✅ Kitap detaylarını görüntüleme
- ✅ Ödünç alma talebi oluşturma
- ✅ Aktif ödünçleri görüntüleme
- ✅ Kitap iade işlemi
- ✅ Profil yönetimi

### Admin (Görevli) Özellikleri
- ✅ Dashboard ve istatistikler
- ✅ Kitap yönetimi (ekle/düzenle/sil)
- ✅ Kategori yönetimi
- ✅ Ödünç taleplerini onaylama/reddetme
- ✅ Gecikmeleri izleme
- ✅ Tüm ödünç kayıtlarını görüntüleme

## 🛠️ Teknolojiler

- **Framework:** Flutter 3.35.7
- **Dil:** Dart 3.9.2
- **Backend:** Firebase (Firestore, Auth)
- **State Management:** Riverpod
- **Navigation:** go_router
- **Code Generation:** freezed, json_serializable
- **UI:** Material Design 3

## 📦 Kurulum

### 1. Gereksinimler
- Flutter SDK 3.35.7 veya üzeri
- Dart SDK 3.9.2 veya üzeri
- iOS için: Xcode 14+
- Firebase hesabı

### 2. Projeyi Klonlayın
```bash
git clone https://github.com/aakgunnn/libraryApp.git
cd libraryApp
```

### 3. Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### 4. Firebase Yapılandırması

#### a) Firebase Console'da Proje Oluşturun
1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. Yeni proje oluşturun
3. iOS uygulaması ekleyin (Bundle ID: `com.ankara.university.libraryApp`)

#### b) Firebase CLI ile Yapılandırın
```bash
# Firebase CLI'yi yükleyin (eğer yoksa)
npm install -g firebase-tools

# Firebase'e giriş yapın
firebase login

# FlutterFire CLI'yi yükleyin
dart pub global activate flutterfire_cli

# Firebase projenizi yapılandırın
flutterfire configure
```

#### c) Firebase Hizmetlerini Aktifleştirin
Firebase Console'da:
1. **Authentication** → Email/Password'ü aktifleştirin
2. **Firestore Database** → Veritabanı oluşturun (Test mode)
3. `firestore.rules` dosyasını Firestore'a yükleyin

### 5. Uygulamayı Çalıştırın
```bash
# iOS simülatörde çalıştırın
flutter run -d ios

# Veya cihazda
flutter run -d [DEVICE_ID]
```

## 🗂️ Proje Yapısı

```
lib/
├── core/
│   ├── constants/      # Sabitler
│   ├── theme/          # Tema ve renkler
│   └── utils/          # Yardımcı fonksiyonlar
├── models/             # Veri modelleri (Freezed)
├── providers/          # Riverpod providers
├── services/           # Firebase servisleri
├── screens/            # Ekranlar
│   ├── auth/          # Giriş/Kayıt
│   ├── user/          # Kullanıcı ekranları
│   └── admin/         # Admin ekranları
└── widgets/           # Ortak widget'lar

```

## 🔐 Firestore Güvenlik Kuralları

Proje güvenli Firestore kuralları içerir:
- Rol bazlı erişim kontrolü (admin/member)
- Kullanıcılar sadece kendi verilerini görebilir
- Admin tüm verilere erişebilir
- Kitap ekleme/silme sadece admin

## 📝 Firestore Veri Yapısı

### users
```javascript
{
  id: string,
  fullName: string,
  email: string,
  role: 'admin' | 'member',
  createdAt: timestamp,
  photoUrl: string?,
  isActive: boolean
}
```

### books
```javascript
{
  id: string,
  title: string,
  author: string,
  categoryId: string,
  available: boolean,
  publishYear: number?,
  imageUrl: string?,
  description: string?,
  isbn: string?,
  totalCopies: number,
  availableCopies: number
}
```

### categories
```javascript
{
  id: string,
  name: string,
  isActive: boolean,
  description: string?,
  iconName: string?
}
```

### loans
```javascript
{
  id: string,
  userId: string,
  bookId: string,
  loanDate: timestamp,
  dueDate: timestamp,
  returnDate: timestamp?,
  status: 'pending' | 'borrowed' | 'returned' | 'late' | 'cancelled',
  notes: string?,
  adminId: string?
}
```

## 🧪 Test Kullanıcıları

Firebase Console'dan test kullanıcıları oluşturabilirsiniz:

**Admin:**
- Email: admin@ankara.edu.tr
- Password: admin123
- Role: admin (Firestore'da manuel ayarlayın)

**Kullanıcı:**
- Email: user@ankara.edu.tr
- Password: user123
- Role: member (Otomatik)

## 🚀 Deployment

### iOS TestFlight
```bash
# Release build
flutter build ios --release

# Xcode'da Archive
# Xcode → Product → Archive
# Upload to App Store Connect
```

## 📊 İlerleme Durumu

### ✅ Tamamlananlar (Midterm - %70)
- ✅ Proje altyapısı ve Firebase yapılandırması
- ✅ Veri modelleri (Freezed)
- ✅ Firebase servisleri (Auth, Book, Loan, Category)
- ✅ Riverpod providers
- ✅ Authentication ekranları
- ✅ Kullanıcı ana ekranı (arama, filtreleme)
- ✅ Kitap detay ekranı
- ✅ Ödünç alma sistemi
- ✅ Profil ekranı
- ✅ Admin dashboard
- ✅ Kitap yönetimi (CRUD)
- ✅ Ödünç talep yönetimi

### 🔄 Devam Eden (Final için)
- 🔄 Firebase Crashlytics entegrasyonu
- 🔄 Firebase Analytics entegrasyonu
- 🔄 Push bildirimleri (FCM)
- 🔄 QR kod ile hızlı işlemler
- 🔄 Dark theme desteği
- 🔄 Kategori yönetimi ekranı
- 🔄 Gelişmiş arama (Algolia)
- 🔄 Kullanıcı yönetimi (admin panel)

## 👨‍💻 Geliştirici

**Ahmet Akgün**  
Öğrenci No: 22290602  
GitHub: [@aakgunnn](https://github.com/aakgunnn)  
Ders: BLM4537 - Mobil Uygulama Geliştirme  
Danışman: Enver Bağcı

## 📄 Lisans

Bu proje Ankara Üniversitesi Bilgisayar Mühendisliği Bölümü dönem projesi olarak geliştirilmiştir.

---

**Son Güncelleme:** Kasım 2025
