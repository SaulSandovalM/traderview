import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCustomer({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception('No se pudo obtener el UID del usuario');

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'nombre': name.trim(),
        'correo': email.trim(),
        'telefono': phone.trim(),
        'role': 'client',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'El correo ya está en uso.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
