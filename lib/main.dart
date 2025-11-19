import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';

class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth;

  MyAuthProvider([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Optional: listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(create: (_) => MyAuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
