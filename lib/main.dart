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
// Kimsenin kafası karışmasın diye tarafsız bir ana sayfa bırakıyoruz
home: const Scaffold(
body: Center(
child: Text('Ana Sayfa (Yapım Aşamasında)'),
),
),
);
}
}