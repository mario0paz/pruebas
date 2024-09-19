import 'package:equipo5/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';

class PageLoginScreen extends StatefulWidget {
  const PageLoginScreen({super.key});

  @override
  State<PageLoginScreen> createState() => _PageLoginScreenState();
}

class _PageLoginScreenState extends State<PageLoginScreen> {
  bool isLoading = false;

  Future<void> loginWithGoogle() async {
    try {
      setState(() => isLoading = true);
      await AuthService().signInWithGoogle(context);
      // ignore: use_build_context_synchronously
      context.go('/maintenance');
    } catch (e) {
      // Handle error appropriately
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to AutoCare',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SignInButton(
                    Buttons.Google,
                    onPressed: loginWithGoogle,
                    text: "Login with Google",
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
