# Firebase Kurulum Rehberi

Bu dosya Firebase yapılandırması için adım adım rehberdir.

## 1. Firebase Console'da Proje Oluşturma

1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. "Add project" butonuna tıklayın
3. Proje adı: `library-app-ankara` (veya istediğiniz bir isim)
4. Google Analytics'i aktifleştirin (isteğe bağlı)
5. Projeyi oluşturun

## 2. iOS Uygulaması Ekleme

1. Firebase Console → Project Overview → iOS simgesine tıklayın
2. Bundle ID: `com.ankara.university.libraryApp`
3. App nickname: `Library App`
4. `GoogleService-Info.plist` dosyasını indirin
5. İndirdiğiniz dosyayı `ios/Runner/` klasörüne taşıyın

## 3. Firebase CLI ve FlutterFire Kurulumu

```bash
# Node.js yüklü değilse önce yükleyin
# https://nodejs.org/

# Firebase CLI
npm install -g firebase-tools

# Firebase'e giriş yapın
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli

# PATH'e ekleyin (eğer yoksa)
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

## 4. FlutterFire Configuration

Proje ana dizininde çalıştırın:

```bash
flutterfire configure
```

Bu komut:
- Firebase projelerinizi listeler
- Proje seçmenizi ister
- Platformları seçmenizi ister (iOS ve Android)
- Otomatik olarak `firebase_options.dart` dosyası oluşturur
- iOS için gerekli yapılandırmaları yapar

## 5. Firebase Servislerini Aktifleştirme

### Authentication

1. Firebase Console → Build → Authentication
2. "Get started" butonuna tıklayın
3. Sign-in method → Email/Password → Enable
4. Save

### Firestore Database

1. Firebase Console → Build → Firestore Database
2. "Create database" butonuna tıklayın
3. **Start in test mode** seçin (şimdilik)
4. Location: `europe-west1` (veya size yakın)
5. Enable

### Firestore Rules Güncelleme

1. Firestore Database → Rules sekmesi
2. Proje kökündeki `firestore.rules` dosyasının içeriğini kopyalayın
3. Firebase Console'daki rules kısmına yapıştırın
4. "Publish" butonuna tıklayın

## 6. main.dart Güncellemesi

`lib/main.dart` dosyasını açın ve şu satırları güncelleyin:

```dart
import 'firebase_options.dart'; // Bu satırı ekleyin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Bu satırların yorumunu kaldırın:
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

## 7. İlk Admin Kullanıcısı Oluşturma

### Yöntem 1: Firebase Console'dan

1. Authentication → Users → Add user
2. Email: `admin@ankara.edu.tr`
3. Password: `admin123456`
4. User oluşturulduktan sonra UID'yi kopyalayın

5. Firestore Database → users koleksiyonu → Add document
6. Document ID: (kopyaladığınız UID)
7. Fields:
```
fullName: "Admin User"
email: "admin@ankara.edu.tr"
role: "admin"
createdAt: [timestamp]
isActive: true
```

### Yöntem 2: Uygulamadan

1. Uygulamayı çalıştırın
2. "Kayıt Ol" ile normal kullanıcı oluşturun
3. Firebase Console → Firestore → users
4. İlgili kullanıcının `role` alanını `admin` olarak değiştirin

## 8. Test Verileri Ekleme

### Kategoriler

Firestore → categories koleksiyonu → Add document:

```
{
  "name": "Roman",
  "isActive": true,
  "description": "Roman kitapları"
}

{
  "name": "Bilim Kurgu",
  "isActive": true,
  "description": "Bilim kurgu kitapları"
}

{
  "name": "Tarih",
  "isActive": true,
  "description": "Tarih kitapları"
}
```

### Kitaplar

Firestore → books koleksiyonu → Add document:

```
{
  "title": "1984",
  "author": "George Orwell",
  "categoryId": "[Roman kategorisinin ID'si]",
  "available": true,
  "publishYear": 1949,
  "totalCopies": 3,
  "availableCopies": 3,
  "description": "Distopik bir roman",
  "imageUrl": "https://i.dr.com.tr/cache/500x400-0/originals/0000000064031-1.jpg"
}
```

## 9. Uygulamayı Çalıştırma

```bash
# iOS Simulator'de
flutter run -d ios

# Veya belirli bir cihazda
flutter devices
flutter run -d [DEVICE_ID]
```

## 10. Crashlytics (Opsiyonel - Final için)

```bash
# iOS için
cd ios
pod install
cd ..
```

Firebase Console → Build → Crashlytics → Enable

## Sorun Giderme

### Hata: "Firebase not initialized"
- `flutterfire configure` komutunu çalıştırdığınızdan emin olun
- `firebase_options.dart` dosyasının oluştuğunu kontrol edin
- `main.dart`'ta Firebase.initializeApp() çağrısının yorumda olmadığından emin olun

### Hata: "GoogleService-Info.plist not found"
- Dosyanın `ios/Runner/` klasöründe olduğundan emin olun
- Xcode'da projeyi açıp, dosyanın Runner target'ına eklendiğini kontrol edin

### Hata: "Permission denied" (Firestore)
- `firestore.rules` dosyasını Firebase Console'a yüklediğinizden emin olun
- Test mode'dan production mode'a geçtiyseniz kuralları kontrol edin

### Hata: CocoaPods
```bash
cd ios
rm Podfile.lock
rm -rf Pods
pod install --repo-update
cd ..
```

## Yararlı Komutlar

```bash
# Paketleri güncelleme
flutter pub get
flutter pub upgrade

# Clean build
flutter clean
flutter pub get

# iOS build
flutter build ios --release

# Kod generate etme (freezed, json_serializable için)
dart run build_runner build --delete-conflicting-outputs

# Firebase projects listesi
firebase projects:list

# FlutterFire yeniden yapılandırma
flutterfire configure
```

## Güvenlik Önerileri

1. ✅ Firestore Rules'ı mutlaka production'a uygun şekilde yapılandırın
2. ✅ Test mode'u sadece development için kullanın
3. ✅ API keys'leri environment variables'a taşıyın
4. ✅ Admin rolünü sadece güvenilir kullanıcılara verin
5. ✅ Düzenli backup alın (Firestore)

---

**Yardıma mı ihtiyacınız var?**
- Firebase Docs: https://firebase.google.com/docs/flutter/setup
- FlutterFire: https://firebase.flutter.dev/

