import 'package:equipo5/provider/storage_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final storageProvider =
          // ignore: use_build_context_synchronously
          Provider.of<StorageProvider>(context, listen: false);

      storageProvider.saveUserData();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    final storageProvider =
        // ignore: use_build_context_synchronously
        Provider.of<StorageProvider>(context, listen: false);
    await _auth.signOut();
    storageProvider.clearData;
    await GoogleSignIn().signOut();
  }

  User? get currentUser => _auth.currentUser;
}
