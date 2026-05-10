# 🌟 Koza

**Koza**, kullanıcıların psikolojik destek bulabileceği, stresle başa çıkabileceği ve güvenli bir toplulukta içini dökebileceği yapay zeka destekli yenilikçi bir mobil uygulamadır. 

Yapay zeka asistanı **Mia** ile dilediğiniz an konuşabilir, interaktif meditasyon seanslarıyla rahatlayabilir veya yakınınızdaki acil durum destek noktalarına (SOS) tek tıkla ulaşabilirsiniz.

---

## ✨ Temel Özellikler

🤖 **Yapay Zeka Asistanı (Mia)**  
Google Gemini 2.5 Flash entegrasyonuyla çalışan Mia, size sıradan bir robot gibi değil, şefkatli bir arkadaş gibi yaklaşır. Duygularınızı anlar, anlık sohbet eder ve kaygı anlarında size özel nefes/odaklanma tavsiyeleri verir.

🧘‍♀️ **İnteraktif Meditasyon Çemberi**  
Kullanıcıların süreyi kendi belirleyebildiği (1-60 dakika) dinamik meditasyon ekranı. Dokunmatik nefes çemberi ve rahatlatıcı doğa sesleri eşliğinde kendi huzur merkezinizi yaratın. Süre dolduğunda zarif bir uyarı sesi (ding) ile seans tamamlanır.

🌍 **Topluluk Günlüğü (Community Diary)**  
İnsanların tamamen anonim veya profilleriyle içlerini dökebilecekleri, güvenli bir sosyal paylaşım alanı. Başkalarının deneyimlerini okuyun ve yalnız olmadığınızı hissedin.

📍 **Acil Durum (SOS) ve Konum Desteği**  
Acil psikolojik veya fiziksel destek ihtiyaçları için, Google Maps entegrasyonu ile yakındaki yardım noktalarını anında harita üzerinde görün.

---

## 🛠️ Kullanılan Teknolojiler

Koza, modern ve kararlı bir mobil uygulama mimarisi ile geliştirilmiştir:

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Backend & Database:** Firebase (Authentication, Cloud Firestore, Firebase Storage)
- **Yapay Zeka (AI):** Google Generative AI (`gemini-2.5-flash`)
- **Harita & Konum:** Google Maps Flutter, Geocoding
- **Medya & Ses:** Just Audio (Arka plan sesleri ve meditasyon zili için)
- **Bağımlılıklar:** Go Router (Navigasyon), SharedPreferences (Tema ayarları)

---

## 🚀 Kurulum ve Çalıştırma

Projeyi kendi bilgisayarınızda derleyip çalıştırmak için aşağıdaki adımları izleyin:

### Gereksinimler
- Flutter SDK (v3.10.1 veya üzeri)
- Dart SDK
- Android Studio / VS Code (Emülatör veya fiziksel cihaz)

### Kurulum Adımları
1. **Projeyi Klonlayın:**
   ```bash
   git clone https://github.com/kullaniciadi/empath_connect.git
   cd empath_connect
   ```

2. **Paketleri İndirin:**
   ```bash
   flutter pub get
   ```

3. **Firebase Bağlantısı:**
   Proje Firebase'e bağlıdır. Kendi Firebase projenizi oluşturduktan sonra `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ilgili dizinlere eklemeyi unutmayın.

4. **Yapay Zeka (Gemini API) Ayarı:**
   Bizim yapılandırmamızda Gemini API anahtarı güvenli bir şekilde **Firebase Cloud Firestore** üzerinden (`config/api_keys` dizininden) otomatik olarak çekilmektedir. Kodu indirdiğinizde sizin ayrıca bir `.env` dosyası oluşturmanıza gerek yoktur (kendi Firebase'inize gerekli anahtarı eklerseniz Mia anında çalışmaya başlar).

5. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

---

## 📱 Ekran Görüntüleri 
*(Geliştirici Notu: Projeyi GitHub'a yüklerken, `assets/screenshots/` klasörü altına uygulamanızın ekran görüntülerini ekleyip buraya linkleyebilirsiniz.)*

| Chatbot (Mia) | Meditasyon Ekranı | Topluluk | SOS Haritası |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/81428b49-a982-48f5-adaa-a15b03bd625c" width="200"/> | <img src="https://github.com/user-attachments/assets/20d85a20-414e-444f-bff4-70a729c85ac4" width="200"/> | <img src="https://github.com/user-attachments/assets/29fff744-d12e-4b54-8919-fa5acde6bb50" width="200"/> | <img src="https://github.com/user-attachments/assets/9524276d-6563-4ec3-acb7-fd45da39bd59" width="200"/> | <img src="https://github.com/user-attachments/assets/a5a7e02b-1a3c-4b65-838d-43fab804ecc0" width="200"/> | <img src="https://github.com/user-attachments/assets/12cc069e-4215-4714-abf4-c8c20a99d457" width="200"/> | 

---

## 🤝 Katkıda Bulunma
Bu proje geliştirilmeye açıktır! Hata bildirimleri (Issue) açabilir veya yeni özellikler eklemek için Pull Request (PR) gönderebilirsiniz. 

**Koza** ile kimse yalnız değildir. 💙
