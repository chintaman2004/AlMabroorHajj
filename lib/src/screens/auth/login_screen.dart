// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();

  String verificationId = "";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ---------------------------
            /// EMAIL LOGIN
            /// ---------------------------
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: pass,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                try {
                  await auth.loginWithEmail(email.text, pass.text);
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  _show(e.toString(), context);
                }
              },
              child: const Text("Login with Email"),
            ),

            const Divider(height: 40),

            /// ---------------------------
            /// GOOGLE LOGIN
            /// ---------------------------
            ElevatedButton(
              onPressed: () async {
                try {
                  await auth.googleLogin();
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  _show(e.toString(), context);
                }
              },
              child: const Text("Login with Google"),
            ),

            const Divider(height: 40),

            /// ---------------------------
            /// PHONE LOGIN
            /// ---------------------------
            TextField(
              controller: phone,
              decoration: const InputDecoration(
                labelText: "Phone Number (e.g +92xxxx)",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await auth.phoneSignIn(phone.text);
                  _otpDialog(context); // ask OTP
                } catch (e) {
                  _show(e.toString(), context);
                }
              },
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------------------
  /// OTP DIALOG
  /// ---------------------------
  void _otpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Enter OTP"),
          content: TextField(
            controller: otp,
            decoration: const InputDecoration(labelText: "6-digit OTP"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final auth = Provider.of<AuthProvider>(context, listen: false);

                try {
                  await auth.verifyOTP(otp.text);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  _show(e.toString(), context);
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  /// ---------------------------
  /// SHOW MESSAGE
  /// ---------------------------
  void _show(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
