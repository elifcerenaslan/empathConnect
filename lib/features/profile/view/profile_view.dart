import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/theme_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // --- HAFIZA DEĞİŞKENLERİ ---
  File? _image; 
  final ImagePicker _picker = ImagePicker();

  String _username = "İrem"; 
  String _email = "irem@istun.edu.tr"; 

  bool _notifyMood = true;       
  bool _notifyBreathing = false; // EKSİKLİK GİDERİLDİ
  bool _notifyCommunity = true;  

  // --- FOTOĞRAF SEÇME ---
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kameradan Çek'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  // --- DİALOG PENCERELERİ ---
  void _showUsernameChangeDialog() {
    final TextEditingController controller = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kullanıcı Adını Değiştir"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Yeni Kullanıcı Adı"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              setState(() { _username = controller.text; });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kullanıcı adı güncellendi!")));
            }, 
            child: const Text("Kaydet")
          ),
        ],
      ),
    );
  }

  void _showEmailChangeDialog() {
    final TextEditingController controller = TextEditingController(text: _email);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("E-Posta Değiştir"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Yeni E-Posta Adresi"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              setState(() { _email = controller.text; });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-Posta güncellendi!")));
            }, 
            child: const Text("Kaydet")
          ),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Şifre Değiştir"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(obscureText: true, decoration: const InputDecoration(labelText: "Mevcut Şifre")),
            const SizedBox(height: 8),
            TextField(obscureText: true, decoration: const InputDecoration(labelText: "Yeni Şifre")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifreniz güncellendi!")));
            }, 
            child: const Text("Kaydet")
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Bildirim Tercihleri"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text("Günlük Duygu Takibi"),
                    subtitle: const Text("Her akşam nasıl hissettiğini sorarız.", style: TextStyle(fontSize: 12)),
                    value: _notifyMood,
                    onChanged: (val) {
                      setStateDialog(() => _notifyMood = val);
                      setState(() => _notifyMood = val);
                    },
                  ),
                  // EKSİKLİK GİDERİLDİ: Nefes egzersizi eklendi
                  SwitchListTile(
                    title: const Text("Nefes Egzersizi"),
                    subtitle: const Text("Stres anlarında hatırlatıcı gönderir.", style: TextStyle(fontSize: 12)),
                    value: _notifyBreathing,
                    onChanged: (val) {
                      setStateDialog(() => _notifyBreathing = val);
                      setState(() => _notifyBreathing = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text("Topluluk Mesajları"),
                    subtitle: const Text("Yeni destek mesajlarında uyarır.", style: TextStyle(fontSize: 12)),
                    value: _notifyCommunity,
                    onChanged: (val) {
                      setStateDialog(() => _notifyCommunity = val);
                      setState(() => _notifyCommunity = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat")),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil ve Ayarlar'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // --- PROFİL FOTOĞRAFI ALANI ---
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null 
                            ? const Icon(Icons.person, size: 75, color: Colors.white) 
                            : null,
                      ),
                      GestureDetector(
                        onTap: _showPhotoOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(_username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(_email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- AYARLAR ---
            _buildSection(context, "Hesap Ayarları", [
              _buildSettingTile(context, Icons.person_outline, "Kullanıcı Adını Değiştir", onTap: _showUsernameChangeDialog),
              _buildSettingTile(context, Icons.email_outlined, "E-Posta Değiştir", onTap: _showEmailChangeDialog),
              // EKSİKLİK GİDERİLDİ: Şifre değiştirme butonu aktifleştirildi
              _buildSettingTile(context, Icons.lock_outline, "Şifre Değiştir", onTap: _showPasswordChangeDialog),
            ]),

            _buildSection(context, "Uygulama Tercihleri", [
              _buildSettingTile(
                context,
                Icons.dark_mode_outlined, 
                "Karanlık Mod", 
                trailing: Switch(
                  value: themeProvider.isDarkMode, 
                  onChanged: (v) => themeProvider.toggleTheme(),
                ),
              ),
              _buildSettingTile(context, Icons.notifications_outlined, "Bildirimler", onTap: _showNotificationsDialog),
            ]),

            _buildSection(context, "Destek", [
              _buildSettingTile(context, Icons.logout, "Çıkış Yap", color: Colors.red, onTap: () => Navigator.pop(context)),
            ]),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, {Widget? trailing, Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.onSurface),
      title: Text(title, style: TextStyle(color: color)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}