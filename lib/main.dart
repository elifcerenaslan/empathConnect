import 'package:firebase_core/firebase_core.dart';                                               
import 'package:empath_connect/core/providers/sos_provider.dart';
//CommunityController'ı da provider listesine ekledik.
import 'package:empath_connect/features/community/controller/diary_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'features/home/view/home_view.dart';
import 'features/auth/view/login_view.dart';
import 'core/services/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const EmpathConnectApp());
}

class EmpathConnectApp extends StatelessWidget {
  const EmpathConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SosProvider()), 
        // Topluluk controller'ı eklendi
        ChangeNotifierProvider(create: (context) => CommunityController()),
        // AuthService'i de provider'a ekleyebiliriz veya stream'i direkt kullanabiliriz.
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'EmpathConnect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode, 
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Kullanıcı giriş yapmış
          return const HomeView();
        }

        // Kullanıcı giriş yapmamış
        return const LoginView();
      },
    );
  }
}