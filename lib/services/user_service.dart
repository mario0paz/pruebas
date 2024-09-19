import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Crear un nuevo usuario o actualizar uno existente
  Future<void> upsertUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (error) {
      throw Exception("Error creating/updating user: $error");
    }
  }

  Future<UserModel?> getUser() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return null; // Usuario no encontrado
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error fetching user data: $error");
    }
  }

  // Actualizar datos del usuario
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (error) {
      throw Exception("Error updating user data: $error");
    }
  }

  // Eliminar usuario
  Future<void> deleteUser() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).delete();
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error deleting user data: $error");
    }
  }
}
