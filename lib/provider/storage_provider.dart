import 'package:equipo5/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class StorageProvider with ChangeNotifier {
  String? _name;
  String? _photoUrl;
  String? _email;
  final UserService _userService = UserService();

  String? get name => _name;
  String? get photoUrl => _photoUrl;
  String? get email => _email;

  Future<void> saveUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String name = user.displayName ?? 'No Name';
      String photoUrl = user.photoURL ?? 'No Photo';
      String email = user.email ?? 'No Email';

      UserModel userModel = UserModel(
        id: userId,
        name: name,
        email: email,
        photoUrl: photoUrl,
      );

      // Intenta obtener el usuario por correo electrónico
      UserModel? existingUser = await _userService.getUser();
      if (existingUser != null) {
        // Si el usuario existe, no hacemos nada
      } else {
        // Si el usuario no existe, agrégalo
        await _userService.upsertUser(userModel);
      }

      _name = name;
      _photoUrl = photoUrl;
      _email = email;
      notifyListeners();
    }
  }

  Future<void> clearData() async {
    _name = null;
    _photoUrl = null;
    _email = null;
    notifyListeners();
  }
}
