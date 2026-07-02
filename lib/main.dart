import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:auto_mobile_assist/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/owner/owner_dashboard.dart';
import 'screens/mechanic/mechanic_dashboard.dart';
import 'screens/shop/shop_dashboard.dart';
import 'screens/distributor/distributor_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Auto-Mobile Assist',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!authProvider.isAuthenticated) {
      return LoginScreen(
        onLanguageChanged: (locale) {
          // Access the parent state to change locale
          final mainApp = context.findAncestorStateOfType<_MyAppState>();
          if (mainApp != null) {
            mainApp.setLocale(locale);
          }
        },
      );
    }

    final user = authProvider.user;
    switch (user?.role) {
      case 'owner':
        return const OwnerDashboard();
      case 'mechanic':
        return const MechanicDashboard();
      case 'shop':
        return const ShopDashboard();
      case 'distributor':
        return const DistributorDashboard();
      case 'admin':
        return const AdminDashboard();
      default:
        return LoginScreen(
          onLanguageChanged: (locale) {
            final mainApp = context.findAncestorStateOfType<_MyAppState>();
            if (mainApp != null) {
              mainApp.setLocale(locale);
            }
          },
        );
    }
  }
}