class ProductModel {
  int? id;
  String name;
  int price;           // disimpan sebagai INTEGER di SQLite
  String description;  // baru
  String image;
  String location;
  double rating;
  int? ownerId;        // baru: pemilik / user id yang upload produk

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.location,
    required this.rating,
    this.ownerId,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      price: map['price'] is int
          ? map['price'] as int
          : int.tryParse(map['price']?.toString() ?? '0') ?? 0,
      description: map['description'] as String? ?? '',
      image: map['image'] as String? ?? '',
      location: map['location'] as String? ?? '',
      rating: map['rating'] == null
          ? 0.0
          : double.tryParse(map['rating'].toString()) ?? 0.0,
      ownerId: map['ownerId'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
      'location': location,
      'rating': rating,
      'ownerId': ownerId,
    };
  }
}
