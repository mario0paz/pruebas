import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class SimpleRegisterScreen extends StatefulWidget {
  const SimpleRegisterScreen({super.key});

  @override
  State<SimpleRegisterScreen> createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  late String email, password;
  String? emailError, passwordError;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();
    bool isValid = true;

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(email)) {
      setState(() {
        emailError = 'Invalid email address';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> register() async {
    if (validate()) {
      try {
        setState(() => isLoading = true);
        await AuthService().signInWithEmail(email, password);
        // ignore: use_build_context_synchronously
        context.go('/maintenance');
      } catch (e) {
        setState(() {
          emailError = 'Registration failed. Please try again.';
        });
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.1),
            const Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Register to get started!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.1),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailError,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => setState(() => email = value),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: screenHeight * 0.02),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordError,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) => setState(() => password = value),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => register(),
            ),
            SizedBox(height: screenHeight * 0.05),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: register,
                    child: const Text('Register'),
                  ),
            SizedBox(height: screenHeight * 0.1),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
