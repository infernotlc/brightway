import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'core/blocs/auth_bloc.dart';
import 'core/services/firebase_auth_service.dart';
import 'presentation/widgets/app_wrapper.dart';
import 'core/constants/app_constants.dart';
import 'core/services/accessibility_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // You can show an error screen here if needed
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthService())
            ..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        // Enable localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'), // Turkish
          Locale('en', 'US'), // English
        ],
        locale: const Locale('tr', 'TR'), // Set Turkish as default
        // Enable accessibility features
        showSemanticsDebugger: false, // Set to true for debugging accessibility
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ).copyWith(
            // Ensure sufficient contrast
            surface: Colors.white,
            onSurface: Colors.black87,
            primary: Colors.blue.shade700,
            onPrimary: Colors.white,
            secondary: Colors.blue.shade500,
            onSecondary: Colors.white,
            error: Colors.red.shade700,
            onError: Colors.white,
          ),
          useMaterial3: true,
          // Enhanced accessibility theme
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Improved text contrast for accessibility
          textTheme: const TextTheme().apply(
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            // Enhanced accessibility for app bars
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // Enhanced button accessibility
              minimumSize: const Size(88, 48), // Minimum touch target size
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            // Enhanced input accessibility
            filled: true,
            fillColor: Colors.grey.shade50,
            // Better contrast for labels
            labelStyle: const TextStyle(color: Colors.black87),
            hintStyle: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        // Dark theme for accessibility
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ).copyWith(
            surface: Colors.grey.shade900,
            onSurface: Colors.white,
            primary: Colors.blue.shade300,
            onPrimary: Colors.black87,
            secondary: Colors.blue.shade400,
            onSecondary: Colors.black87,
            error: Colors.red.shade400,
            onError: Colors.black87,
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Enhanced dark theme accessibility
          textTheme: const TextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
            ),
              minimumSize: const Size(88, 48),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.grey.shade900,
            labelStyle: const TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        home: const AppWrapper(),
      ),
    );
  }
}
