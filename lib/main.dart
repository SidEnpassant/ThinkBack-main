import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkback4/providers/future_jar_provider.dart';
import 'package:thinkback4/providers/home_provider.dart';
import 'package:thinkback4/providers/profile_provider.dart';
import 'package:thinkback4/providers/recall_provider.dart';
import 'package:thinkback4/providers/memory_entry_provider.dart';
import 'package:thinkback4/screens/navigation_container.dart';
import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => RecallProvider()),
        ChangeNotifierProvider(create: (_) => FutureJarProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MemoryEntryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application  .
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const NavigationContainer(),
      },
    );
  }
}
