import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil ve Ayarlar'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. KULLANICI BİLGİLERİ KARTI
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: colorScheme.secondary, // Nane Yeşili
                      child: Icon(Icons.person, size: 40, color: colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kullanıcı Adı',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ornek@email.com',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. ŞİFRE DEĞİŞTİRME ALANI (Genişleyebilir Menü)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                leading: Icon(Icons.lock_outline, color: colorScheme.primary),
                title: const Text('Şifre Değiştir', style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Mevcut Şifre',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Yeni Şifre',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            minimumSize: const Size(double.infinity, 45), // Butonu tam genişlik yapar
                          ),
                          onPressed: () {
                            debugPrint("Şifre güncelleme tıklandı");
                          },
                          child: const Text('Şifreyi Güncelle', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. ACİL DURUM KİŞİLERİ (SOS KISMI İÇİN)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Acil Durum Kişileri',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.person_add, color: colorScheme.primary),
                          onPressed: () {
                            debugPrint("Yeni kişi ekleme penceresi açılacak");
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    // Örnek Kayıtlı Kişi 1
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.secondary.withValues(alpha: 0.5),
                        child: Icon(Icons.phone, color: colorScheme.primary),
                      ),
                      title: const Text('Ablam'),
                      subtitle: const Text('05XX XXX XX XX'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          debugPrint("Kişi silindi");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 4. ÇIKIŞ YAP BUTONU
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1), // Hafif kırmızı arka plan
                foregroundColor: Colors.redAccent, // Kırmızı yazı ve ikon
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Çıkış Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                debugPrint("Çıkış yapıldı");
              },
            ),
            
          ], // <-- Senin kodunda eksik olan yer burası ve aşağısıydı
        ),
      ),
    );
  }
}