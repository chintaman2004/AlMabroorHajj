import 'package:almabroorhajj/src/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'src/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Almabroor Hajj',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // create HomeScreen
      },
    );
  }
}
