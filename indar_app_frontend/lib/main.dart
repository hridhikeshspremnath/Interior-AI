import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/image_provider.dart';
import 'providers/theme_provider.dart';
import 'pages/onboarding_page.dart';

void main() {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}