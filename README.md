# 🛡️ QuakeCare - Deprem Hazırlık ve Koordinasyon Mobil Uygulaması

<p align="center">
  <img src="assets/images/logo.png" alt="QuakeCare Logo" width="150" />
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-v3.5+-02569B?logo=flutter&logoColor=white" alt="Flutter Badge"/></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-v3.5+-0175C2?logo=dart&logoColor=white" alt="Dart Badge"/></a>
  <a href="#"><img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform Badge"/></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-blue" alt="License"/></a>
</p>

---

## 📌 QuakeCare Nedir?

**QuakeCare**, deprem öncesinde hazırlık yapmanızı, deprem anında panik yapmadan doğru adımları uygulamanızı ve deprem sonrasında koordinasyon sağlayarak güvende kalmanızı hedefleyen modern ve kapsamlı bir mobil uygulamadır. 

Flutter ile geliştirilen bu uygulama, kullanıcı dostu arayüzü, yerel bildirim desteği, sesli tatbikat rehberi, etkileşimli harita modülleri ve acil durum planlama araçları ile afet anında en büyük yardımcınız olmayı hedefler.

---

## 🚀 Temel Özellikler

Uygulama, deprem hazırlık ve acil durum yönetimi sürecini kolaylaştırmak için **6 temel modül** sunar:

### 1. 🏫 Tatbikat Rehberi (Sesli ve Yönetilebilir)
* **Adım Adım Kılavuz:** Deprem anında yapılması gerekenler (Çök-Kapan-Tutun vb.) sırasıyla gösterilir.
* **Sesli Yönlendirme (TTS):** Türkçe Text-to-Speech (Ses sentezleme) teknolojisi ile tatbikat adımları sesli olarak telaffuz edilir, böylece ekrana bakmadan tatbikat yapabilirsiniz.
* **Özelleştirilebilir Adımlar:** Tatbikat adımlarını ekleyebilir, silebilir veya sırasını sürükle-bırak yöntemiyle değiştirebilirsiniz.
* **Zamanlanmış Bildirimler:** Gelecekteki bir tarihe tatbikat hatırlatıcısı kurarak hazırlık seviyenizi güncel tutabilirsiniz.

### 2. 🗺️ Güvenli Alan Önerisi
* **Etkileşimli Harita:** OpenStreetMap altyapısı (`flutter_map`) kullanılarak canlı konumunuz ve çevrenizdeki toplanma alanları gösterilir.
* **Akıllı Mesafe Analizi:** Mevcut GPS koordinatlarınıza göre en yakın güvenli alanı (toplanma alanını) otomatik olarak hesaplar ve haritada yeşil renkli olarak vurgular.

### 3. 🚨 Kullanıcı Durum Paylaşımı
* **Durum Bildirimi:** Deprem sonrasında "Güvendeyim", "Yardıma İhtiyacım Var" veya "Acil Yardım Gerek!" durumunuzu seçebilirsiniz.
* **Sosyal Harita Paneli:** Diğer kullanıcıların durumlarını ve konumlarını haritada farklı renklerdeki işaretçilerle (Kırmızı: Acil, Turuncu: Yardım Lazım, Yeşil: Güvende) anlık olarak görebilirsiniz.

### 4. 🎒 Deprem Çantası (Checklist)
* **Temel Gereksinimler:** Su, konserve gıda, ilk yardım kiti, fener gibi kritik maddeleri barındıran yerleşik kontrol listesi.
* **Kişiselleştirme:** Çantaya yeni maddeler ekleyebilir, mevcut maddeleri güncelleyebilir veya silebilirsiniz.
* **Kalıcılık:** Seçimleriniz cihaz hafızasında (`SharedPreferences`) güvenli bir şekilde saklanır.

### 5. 📞 Acil Durum Rehberi (Hızlı Arama)
* **Rehber Yönetimi:** Acil durumlarda aranacak kişilerin adını ve telefon numarasını kaydedebilirsiniz.
* **Hızlı Arama & Kopyalama:** Tek dokunuşla kişiyi arayabilir (`url_launcher`) veya numarasını panoya kopyalayabilirsiniz.

### 6. ⚠️ Son Depremler
* **Anlık Veri:** USGS (United States Geological Survey) API'si üzerinden Türkiye ve çevresinde meydana gelen güncel depremler filtrelenerek listelenir.
* **Deprem Detayları:** Depremin büyüklüğü, gerçekleştiği konum, tarih ve derinlik bilgileri kartlar halinde sunulur.

---

## 📲 APK İndir

Uygulamanın Android cihazlara doğrudan kurulabilmesi için derlenen son kararlı APK sürümünü aşağıdaki bağlantıdan indirebilirsiniz:

> [!IMPORTANT]
> **[📥 QuakeCare APK Dosyasını İndir (v1.0.0)](#)** *(Dosyayı indirdikten sonra cihazınızda bilinmeyen kaynaklardan yüklemeye izin vermeniz gerekebilir.)*

*(Not: Buraya kendi APK indirme linkinizi veya GitHub Release bağlantınızı yerleştirebilirsiniz.)*

---

## 📸 Ekran Görüntüleri (Screenshots)

| Ana Sayfa | Tatbikat Rehberi | Güvenli Alan Önerisi |
| :---: | :---: | :---: |
| <img src="screenshots/home_screen.png" alt="Ana Sayfa" width="220"/> | <img src="screenshots/drill_screen.png" alt="Tatbikat Rehberi" width="220"/> | <img src="screenshots/safe_zone_screen.png" alt="Güvenli Alan Haritası" width="220"/> |

| Kullanıcı Durumu | Acil Durum Rehberi | Deprem Çantası |
| :---: | :---: | :---: |
| <img src="screenshots/user_status_screen.png" alt="Kullanıcı Durumu" width="220"/> | <img src="screenshots/contact_screen.png" alt="Acil Durum Rehberi" width="220"/> | <img src="screenshots/emergency_kit_screen.png" alt="Deprem Çantası" width="220"/> |

*(Görsellerin yüklenmesi için projenin kök dizininde `screenshots/` klasörü oluşturup ilgili isimlerdeki ekran görüntülerini eklemeniz yeterlidir.)*

---

## 🛠️ Kullanılan Teknolojiler ve Paketler

* **Flutter & Dart SDK** - Çapraz platform mobil uygulama çatısı.
* **Provider** - State Management (Durum yönetimi).
* **Flutter Map (OpenStreetMap) & Latlong2** - İnternet bağlantılı interaktif harita gösterimi ve rota/koordinat hesaplamaları.
* **Flutter TTS (Text-to-Speech)** - Adımları sesli okuma entegrasyonu.
* **Flutter Local Notifications** - Tatbikat hatırlatıcıları için yerel cihaz bildirimleri.
* **Shared Preferences** - Çanta listesi, rehber bilgileri gibi verilerin cihazda kalıcı olarak tutulması.
* **Geolocator & Geocoding** - Cihazın canlı konumunu alma ve koordinat işlemleri.
* **HTTP** - USGS API'sinden son depremleri çekmek için ağ istekleri.
* **URL Launcher** - Acil durum numaralarını doğrudan arama entegrasyonu.

---

## 📂 Proje Dizin Yapısı

```text
lib/
├── main.dart                  # Uygulama başlangıç noktası ve servislerin kurulması
├── providers/
│   └── drill_provider.dart    # Tatbikat yönetimi, TTS, bildirim ve SharedPreferences state
├── screens/
│   ├── contact_screen.dart    # Acil Durum Rehberi (Ekleme, Silme, Arama, Kopyalama)
│   ├── drill_screen.dart      # Tatbikat oluşturma ve yönetme ekranı
│   ├── emergency_kit_screen.dart # Deprem Çantası kontrol listesi
│   ├── guide_screen.dart      # Adım adım tatbikat uygulama ekranı
│   ├── home_screen.dart       # Ana menü ve yönlendirme ekranı
│   ├── recent_earthquakes_screen.dart # USGS API ile son depremler listesi
│   ├── safe_zone_screen.dart  # Güvenli alanları gösteren harita ekranı
│   └── user_status_screen.dart # Kullanıcı güvenli/yardım durumu bildirme haritası
├── services/
│   ├── location_service.dart  # GPS konum okuma ve mesafe hesaplama servisleri
│   └── notification_service.dart # Bildirim servis ayarları ve tetikleyiciler
└── widgets/
    ├── drill_timer_widget.dart # Tatbikat zamanlayıcı görsel bileşeni
    └── safe_zone_widget.dart  # Haritadaki güvenli alan bilgi kartı
```

---

## ⚙️ Kurulum ve Çalıştırma

Bu projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

### Gereksinimler
* Bilgisayarınızda **Flutter SDK** yüklü olmalıdır (Önerilen: v3.5.0 veya üzeri).
* Çalıştırmak için bir Android/iOS emülatörü veya fiziksel bir test cihazı bağlı olmalıdır.

### Adımlar

1. **Projeyi Klonlayın:**
   ```bash
   git clone https://github.com/UGURGULAYDIN/QuakeCare-Earthquake-Mobile-App.git
   cd QuakeCare-Earthquake-Mobile-App
   ```

2. **Bağımlılıkları Yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

4. **APK Çıktısı Almak İçin (Android):**
   ```bash
   flutter build apk --release
   ```
   *Üretilen APK dosyası `build/app/outputs/flutter-apk/app-release.apk` dizininde yer alacaktır.*

---

## 📄 Lisans

Bu proje **MIT Lisansı** ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına göz atabilirsiniz.
