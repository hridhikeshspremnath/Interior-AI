import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/image_provider.dart';
import 'providers/theme_provider.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ivvpwwzlseboyumapyai.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2dnB3d3psc2Vib3l1bWFweWFpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM1NTgxMDQsImV4cCI6MjA4OTEzNDEwNH0.JBoZB6LWfnUiSfZwByuFUn_ahSArmq7kuqiRxKnTeeY',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageProviderModel()),
        ChangeNotifierProvider(create: (_) => ThemeProviderModel()),
      ],
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  // null = still loading, true = logged in, false = logged out
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkSession();

    // Listen for auth changes after initial check
    supabase.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        AuthService.syncWithBackend();
        setState(() => _isLoggedIn = true);
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() => _isLoggedIn = false);
      }
    });
  }

  Future<void> _checkSession() async {
    // Small delay to let Supabase restore session from storage
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;
    
    final session = supabase.auth.currentSession;
    setState(() => _isLoggedIn = session != null);
  }

  @override
  Widget build(BuildContext context) {
    // Still checking session — show splash
    if (_isLoggedIn == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_isLoggedIn == true) {
      return const HomePage();
    }

    return const OnboardingPage();
  }
}
