import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satu_digital/model/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// CREATE ORDER
  Future<void> createOrder(OrderModel order) async {
    final ref = _db.collection("orders").doc();

    await ref.set(order.toMap()..['id'] = ref.id);
  }

  /// GET ORDER BY USER (future)
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    final snapshot = await _db
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs.map((d) => OrderModel.fromMap(d.data())).toList();
  }

  /// STREAM REALTIME USER ORDER
  Stream<List<OrderModel>> streamOrders(String userId) {
    return _db
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((d) => OrderModel.fromMap(d.data())).toList(),
        );
  }

  /// UPDATE STATUS (admin)
  Future<void> updateStatus(String orderId, String status) async {
    await _db.collection("orders").doc(orderId).update({
      "status": status,
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }
}
