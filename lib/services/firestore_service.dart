import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/activity.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Habilitar persistencia offline
  void enableOfflinePersistence() async {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  Future<void> addUserActivity(Activity activity) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        CollectionReference activities = _firestore.collection('activities');
        await activities.doc(activity.id).set({
          ...activity.toJson(),
          'userId': userId, // Aseguramos que el userId esté presente
        });
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error adding user activity: $error");
    }
  }

  // Obtener actividades del usuario actual
  Future<List<Activity>> getUserActivities() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        CollectionReference activities = _firestore.collection('activities');
        QuerySnapshot snapshot =
            await activities.where('userId', isEqualTo: userId).get();

        return snapshot.docs
            .map((doc) => Activity.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error fetching user activities: $error");
    }
  }

  // Actualizar una actividad específica del usuario
  Future<void> updateUserActivity(Activity activity) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentReference docRef =
            _firestore.collection('activities').doc(activity.id);
        DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists && (docSnapshot['userId'] == userId)) {
          await docRef.update(activity.toJson());
        } else {
          throw Exception("No permission to update this activity");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error updating user activity: $error");
    }
  }

  // Borrar una actividad del usuario
  Future<void> deleteUserActivity(String activityId) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentReference docRef =
            _firestore.collection('activities').doc(activityId);
        DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists && (docSnapshot['userId'] == userId)) {
          await docRef.delete();
        } else {
          throw Exception("No permission to delete this activity");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error deleting user activity: $error");
    }
  }

  // Obtener una actividad específica por su ID (filtrada por userId)
  Future<Activity?> getUserActivityById(String activityId) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot doc =
            await _firestore.collection('activities').doc(activityId).get();

        if (doc.exists && doc['userId'] == userId) {
          return Activity.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          throw Exception("No permission to access this activity");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error fetching user activity: $error");
    }
  }

  Future<void> updateActivityPending(String activityId, bool isPending) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentReference docRef =
            _firestore.collection('activities').doc(activityId);
        DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists && (docSnapshot['userId'] == userId)) {
          await docRef.update({'isPending': isPending});
        } else {
          throw Exception("No permission to update this activity");
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error updating user activity: $error");
    }
  }
}
