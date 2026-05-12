# 🌟 Koza

**Koza**, kullanıcıların psikolojik destek bulabileceği, stresle başa çıkabileceği ve güvenli bir toplulukta içini dökebileceği yapay zeka destekli yenilikçi bir mobil uygulamadır.

Yapay zeka asistanı **Mia** ile dilediğiniz an konuşabilir, interaktif meditasyon seanslarıyla rahatlayabilir veya yakınınızdaki acil durum destek noktalarına (SOS) tek tıkla ulaşabilirsiniz.

---

## ✨ Temel Özellikler

🤖 **Yapay Zeka Asistanı (Mia)**  
Google Gemini 2.5 Flash entegrasyonuyla çalışan Mia, size sıradan bir robot gibi değil, şefkatli bir arkadaş gibi yaklaşır. Duygularınızı anlar, anlık sohbet eder ve kaygı anlarında size özel nefes/odaklanma tavsiyeleri verir. Ana sayfada sürüklenebilir **Chat** balonundan sohbete girebilirsiniz.

🧘‍♀️ **İnteraktif Meditasyon Çemberi**  
Kullanıcıların süreyi kendi belirleyebildiği (1–60 dakika) dinamik meditasyon ekranı. Dokunmatik nefes çemberi ve rahatlatıcı doğa sesleri eşliğinde kendi huzur merkezinizi yaratın. Süre dolduğunda zarif bir uyarı sesi (ding) ile seans tamamlanır.

📔 **Kişisel günlük (Private Diary)**  
Sadece size ait, Firestore’da kullanıcı hesabınıza bağlı tutulan günlük alanı. Her gün için tek kayıt mantığıyla (`YYYY-MM-DD` belge kimliği) duygu emojisi, ruh hali puanı (kaydırıcı) ve metin notu kaydedilir; yeni kayıt aynı günün üzerine yazılabilir. Geçmiş kayıtlar listelenir, tek tek silinebilir. Uygulama içi geçişte alt menü yerine üst çubuktaki geri oku ile ana akışa dönebilirsiniz.

🌍 **Topluluk günlüğü (Community Diary)**  
İnsanların tamamen anonim veya profilleriyle içlerini dökebilecekleri, güvenli bir sosyal paylaşım alanı. Başkalarının deneyimlerini okuyun ve yalnız olmadığınızı hissedin. *(Kişisel günlükten farkı: topluluk paylaşımları herkese açık akış ve yorum mantığıyla çalışır.)*

📍 **Acil durum (SOS) ve konum**  
Acil psikolojik veya fiziksel destek ihtiyaçları için Google Maps / harita tabanlı ekranlarla yakındaki yardım noktalarını görüntüleyin; uygulama çubuğundan hızlı SOS erişimi vardır.

🏠 **Ana sayfa**  
Günün sözü (SharedPreferences ile günlük rotasyon), duygu takip kartı (kişisel günlüğe yönlendirme), nefes egzersizi kartı, topluluktan son içerik özeti ve tema (açık/koyu) desteği.

🔐 **Kimlik doğrulama**  
Firebase Authentication ile giriş ve kayıt; oturum açıkken doğrudan ana sayfaya yönlendirilirsiniz (`AuthWrapper`).

---

## 🗂️ Proje yapısı (özet)

| Dizin | İçerik |
|--------|--------|
| `lib/features/auth/` | Giriş ve kayıt ekranları |
| `lib/features/home/` | Ana sayfa, alt gezinme, sürüklenebilir chat FAB |
| `lib/features/diary/` | **Kişisel günlük** (servis, form, geçmiş listesi) |
| `lib/features/community/` | Topluluk akışı, gönderi ve yorumlar |
| `lib/features/meditation/` | Meditasyon oturumu |
| `lib/features/emergency/` | Mia sohbeti, Gemini servisi, mesaj depolama |
| `lib/features/sos/` | SOS ve harita noktaları |
| `lib/features/profile/` | Profil (ör. profil fotoğrafı için `image_picker` vb.) |
| `lib/core/` | Tema, sabitler, provider’lar, ortak servisler |

---

## 🛠️ Kullanılan teknolojiler

Koza, modern ve kararlı bir mobil uygulama mimarisi ile geliştirilmiştir:

- **Framework:** Flutter (Dart), SDK `^3.10.1`
- **State management:** Provider
- **Backend:** Firebase (Authentication, Cloud Firestore, Storage)
- **Yapay zeka:** Google Generative AI (`google_generative_ai`), model: `gemini-2.5-flash`
- **Harita ve konum:** `google_maps_flutter`, `geocoding`; ayrıca `flutter_map` / `latlong2` (ilgili ekranlarda)
- **Ses:** Just Audio (meditasyon ve bildirim tonu)
- **Diğer:** `shared_preferences` (tema ve günlük söz), `url_launcher`, `http`, `flutter_dotenv` (`.env` varlığına bağlı), `timeago`
- **Gezinme:** `MaterialApp` + `Navigator` (sayfa geçişleri); `go_router` bağımlılıkta tanımlıdır, mevcut giriş noktasında kullanılmamaktadır.

---

## 🚀 Kurulum ve çalıştırma

Projeyi kendi bilgisayarınızda derleyip çalıştırmak için aşağıdaki adımları izin.

### Gereksinimler

- Flutter SDK (3.10.1 veya uyumlu)
- Dart SDK
- Android Studio / VS Code (emülatör veya fiziksel cihaz)

### Kurulum adımları

1. **Projeyi klonlayın**

   ```bash
   git clone https://github.com/kullaniciadi/empath_connect.git
   cd empath_connect
   ```

   *(Depo URL’sini kendi GitHub adresinizle değiştirin.)*

2. **Paketleri indirin**

   ```bash
   flutter pub get
   ```

3. **Firebase**

   Kendi Firebase projenizi oluşturduktan sonra `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ilgili platform dizinlerine ekleyin. Firestore ve Authentication kurallarınızı üretim öncesi mutlaka gözden geçirin.

4. **Gemini API anahtarı (Mia)**

   Uygulama, anahtarı Firestore üzerinden okur: koleksiyon `config`, belge `api_keys`, alan adı `gemini_key`. Bu belgeyi kendi projenizde oluşturup geçerli bir Gemini API anahtarı koyduğunuzda Mia sohbeti çalışır. Ayrı bir `.env` zorunlu değildir; `pubspec.yaml` içinde `.env` asset olarak listelenmiştir, kullanıyorsanız dosyanın var olduğundan emin olun.

5. **Çalıştırma**

   ```bash
   flutter run
   ```

---

## 📱 Ekran görüntüleri

*(Geliştirici notu: Projeyi GitHub’a yüklerken `assets/screenshots/` altına görselleri ekleyip burada referans verebilirsiniz.)*

| Chatbot (Mia) | Meditasyon ekranı | Günlük | SOS haritası |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/b99dd032-92af-4582-a478-761974ee9511" width="200"/> | <img src="https://github.com/user-attachments/assets/c14013d3-3588-418d-8d7b-0c5989c76b13" width="200"/> | <img src="https://github.com/user-attachments/assets/cf612d8c-8e4e-4dec-bd0e-f4440f691f4b" width="200"/> | <img src="https://github.com/user-attachments/assets/5c33a6da-59d9-4d68-99f0-1180b46f8626" width="200"/> |

---

## 🤝 Katkıda bulunma

Bu proje geliştirilmeye açıktır. Hata bildirimi (Issue) açabilir veya yeni özellikler için Pull Request gönderebilirsiniz.

**Koza** ile kimse yalnız değildir. 💙
