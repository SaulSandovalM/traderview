import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentService {
  final CollectionReference<Map<String, dynamic>> _firestore =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveMonthlyInvestment({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final now = DateTime.now();
    final monthId = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    await _firestore.doc(userId).collection('investments').doc(monthId).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> hasCurrentMonthInvestment(String customerId) async {
    final now = DateTime.now();
    final currentMonthId =
        "${now.year}-${now.month.toString().padLeft(2, '0')}";

    final investmentRef = _firestore
        .doc(customerId)
        .collection("investments")
        .doc(currentMonthId);

    final snapshot = await investmentRef.get();
    return snapshot.exists;
  }
}
