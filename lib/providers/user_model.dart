import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? _userId;
  String? _role;
  bool _isLoading = false;

  String? get userId => _userId;
  String? get role => _role;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('Usuario no autenticado');
        _userId = null;
        _role = null;
        return;
      }

      final uid = currentUser.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        _userId = uid;
        _role = doc.data()?['role'] ?? 'unknown';
        debugPrint('User ID: $_userId | Role: $_role');
      } else {
        debugPrint('No se encontró el documento del usuario');
      }
    } catch (e) {
      debugPrint('Error al obtener datos del usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUserData({String? id, String? role}) {
    _userId = id;
    _role = role;
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _userId = null;
    _role = null;
    _isLoading = false;
    notifyListeners();
  }
}

// class UserModel with ChangeNotifier {
//   String? _userId;
//   String? _role;
//   bool _isLoading = false;
//   bool _isDataLoaded = false;

//   String? get userId => _userId;
//   String? get role => _role;
//   bool get isLoading => _isLoading;

//   UserModel() {
//     FirebaseAuth.instance.authStateChanges().listen((user) {
//       if (user != null) {
//         fetchUserData(user.uid);
//       } else {
//         clear();
//       }
//     });
//   }

//   Future<void> fetchUserData(String uid) async {
//     if (_isDataLoaded) return;
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final doc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       if (doc.exists) {
//         _userId = uid;
//         _role = doc.data()?['role'] ?? 'unknown';
//         _isDataLoaded = true;
//       } else {
//         clear();
//       }
//     } catch (e) {
//       clear();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void clear() {
//     _userId = null;
//     _role = null;
//     _isDataLoaded = false;
//     _isLoading = false;
//     notifyListeners();
//   }
// }
