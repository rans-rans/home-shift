import "package:flutter/material.dart";

import "package:home_shift/presentation/screens/home_screen.dart";
import "package:home_shift/presentation/screens/settings_screen.dart";
import "package:home_shift/presentation/widgets/provider_injector.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final app = ProviderInjector(
    sharedPrefs: sharedPrefs,
    child: const MyApp(),
  );

  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: "Home Shift",
      home: const HomeScreen(),
      theme: ThemeData(useMaterial3: true),
      routes: {
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}
