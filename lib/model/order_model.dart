import 'order_item_model.dart';

class OrderModel {
  final String? id;
  final String userId;
  final String customerName;
  final String phone;
  final String address;

  final List<OrderItemModel> items;
  final int totalAmount;
  final String status;
  final String paymentMethod;
  final String shippingMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.items,
    required this.totalAmount,
    this.status = "pending",
    this.paymentMethod = "COD",
    this.shippingMethod = "Kurir Toko",
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "customerName": customerName,
      "phone": phone,
      "address": address,
      "items": items.map((e) => e.toMap()).toList(),
      "totalAmount": totalAmount,
      "status": status,
      "paymentMethod": paymentMethod,
      "shippingMethod": shippingMethod,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map["id"],
      userId: map["userId"],
      customerName: map["customerName"],
      phone: map["phone"],
      address: map["address"],
      items: (map["items"] as List)
          .map((item) => OrderItemModel.fromMap(item))
          .toList(),
      totalAmount: map["totalAmount"],
      status: map["status"] ?? "pending",
      paymentMethod: map["paymentMethod"] ?? "COD",
      shippingMethod: map["shippingMethod"] ?? "Kurir Toko",
      createdAt: DateTime.parse(map["createdAt"]),
      updatedAt: DateTime.parse(map["updatedAt"]),
    );
  }
}
