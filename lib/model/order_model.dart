class OrderModel {
  final int? id;
  final int userId;
  final String customerName;
  final String address;
  final String phone;
  final int total;
  final String createdAt; // iso string

  OrderModel({
    this.id,
    required this.userId,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'customerName': customerName,
      'address': address,
      'phone': phone,
      'total': total,
      'createdAt': createdAt,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      customerName: map['customerName'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      total: map['total'] as int,
      createdAt: map['createdAt'] as String,
    );
  }
}
