import 'package:breakfast_buddy/Shared/login_screen.dart';
import 'package:breakfast_buddy/Shared/splash_screen.dart';
import 'package:breakfast_buddy/User_pages/customer_main_screen.dart';
import 'package:breakfast_buddy/core/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.orange,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primaryBrown,
          elevation: 0,
        ),
      ),

      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, delaySnapshot) {
          if (delaySnapshot.connectionState != ConnectionState.done) {
            return const SplashScreen();
          }

          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              if (authSnapshot.hasData) {
                return const CustomerMainScreen();
              }

              return const LoginScreen();
            },
          );
        },
      ),
    );
  }
}
