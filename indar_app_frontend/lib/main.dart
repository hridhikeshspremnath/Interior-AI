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
  bool? _isLoggedIn;

  @override
void initState() {
  super.initState();
  
  // 1. Check initial session immediately
  final initialSession = supabase.auth.currentSession;
  _isLoggedIn = initialSession != null;

  // 2. Listen for any subsequent changes
  supabase.auth.onAuthStateChange.listen((data) {
    if (!mounted) return;
    
    final Session? session = data.session;
    
    setState(() {
      // If session is NOT null, user is logged in.
      _isLoggedIn = session != null;
    });

    if (data.event == AuthChangeEvent.signedIn) {
      AuthService.syncWithBackend();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    // Still waiting for initial session check
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
