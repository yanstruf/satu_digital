class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final int price; // harga satuan
  final String image;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "image": image,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map["productId"],
      productName: map["productName"],
      quantity: map["quantity"],
      price: map["price"],
      image: map["image"],
    );
  }
}
