import 'package:firebase_core/firebase_core.dart';                                               
import 'package:empath_connect/core/providers/sos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'features/home/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EmpathConnectApp());
}

class EmpathConnectApp extends StatelessWidget {
  const EmpathConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ADIM: Tekli Provider yerine MultiProvider kullanıyoruz
    return MultiProvider(
      providers: [
        // Tema yöneticisi (Önceden var olan)
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        
        // SOS veri yöneticisi (Yeni eklediğimiz)
        ChangeNotifierProvider(create: (context) => SosProvider()), 
      ],
      // 2. ADIM: Consumer sadece temayı dinlemeye devam ediyor
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'EmpathConnect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode, // Tema buradan yönetiliyor
            home: const HomeView(),
          );
        },
      ),
    );
  }
}