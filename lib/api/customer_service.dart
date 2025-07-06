import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _firestore =
      FirebaseFirestore.instance.collection('users');

  static const int limitPerPage = 4;

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

      await _firestore.doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
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

  Future<List<Map<String, dynamic>>> getClientsOnce() async {
    final query = await _firestore.where('role', isEqualTo: 'client').get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
        'phone': data['phone'] ?? '',
      };
    }).toList();
  }

  /// Obtener la primera página
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getFirstPage() async {
    final querySnapshot = await _firestore
        .where('role', isEqualTo: 'client')
        .limit(limitPerPage)
        .get();

    return querySnapshot.docs;
  }

  /// Obtener la siguiente página
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getNextPage(
    QueryDocumentSnapshot lastDoc,
  ) async {
    final querySnapshot = await _firestore
        .where('role', isEqualTo: 'client')
        .startAfterDocument(lastDoc)
        .limit(limitPerPage)
        .get();

    return querySnapshot.docs;
  }
}
