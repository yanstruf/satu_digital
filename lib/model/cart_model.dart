class CartModel {
  final int? id;
  final int productId;
  final int qty;
  final int userId;

  CartModel({
    this.id,
    required this.productId,
    required this.qty,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'productId': productId,
      'quantity': qty,
      'userId': userId,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      qty: map['quantity'] as int,
      userId: map['userId'] as int,
    );
  }
}
