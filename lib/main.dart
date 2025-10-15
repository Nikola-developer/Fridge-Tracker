import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hylastix_fridge/pages/items_list_page.dart' show ItemsPage;
import 'package:hylastix_fridge/pages/splash_screen.dart';
import 'package:hylastix_fridge/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Using dummy FirebaseOptions for Emulator-only
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "fake-api-key",
      appId: "1:1234567890:ios:abc123def456",
      messagingSenderId: "1234567890",
      projectId: "demo-project-id",
    ),
  );

  // Point Firestore to Emulator
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  runApp(const FridgeApp());
}

class FridgeApp extends StatelessWidget {
  const FridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hylastix Fridge',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: colorAccent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorAccent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: colorCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Example radius
          ),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: colorBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: colorBackground,
          surfaceTintColor: colorBackground,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(),
        dialogTheme: DialogThemeData(
          backgroundColor: colorBackground,
        )
      ),
      home: const SplashScreen(),
    );
  }
}
