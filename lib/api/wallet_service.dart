import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  final CollectionReference<Map<String, dynamic>> _firestore =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveNewWallet({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.doc(userId).collection('wallet').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> hasWallet(String userId) async {
    final snapshot =
        await _firestore.doc(userId).collection('wallet').limit(1).get();

    return snapshot.docs.isNotEmpty;
  }

  Future<Map<String, dynamic>> getWalletById(
      String customerId, String walletId) async {
    final doc = await _firestore
        .doc(customerId)
        .collection('wallet')
        .doc(walletId)
        .get();
    return doc.data() ?? {};
  }

  Future<void> updateWallet({
    required String customerId,
    required String walletId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .doc(customerId)
        .collection('wallet')
        .doc(walletId)
        .update(data);
  }
}
