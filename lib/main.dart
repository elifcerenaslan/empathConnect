import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const EmpathConnectApp());
}

class EmpathConnectApp extends StatelessWidget {
  const EmpathConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmpathConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme, 
      themeMode: ThemeMode.system, 
      // Ekip arkadaşların için tarafsız bir giriş ekranı bırakıyoruz
      home: const Scaffold(
        body: Center(
          child: Text('Empath Connect Uygulaması (Yapım Aşamasında)'),
        ),
      ),
    );
  }
}