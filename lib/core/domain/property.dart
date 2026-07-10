class Property {
  final String id;
  final String name;
  final String address;
  final String tenant;
  final String price;
  final String? color;
  final String? startDate;
  final String? endDate;
  final String? imagePath;

  const Property({
    required this.id,
    required this.name,
    required this.address,
    required this.tenant,
    required this.price,
    required this.color,
    required this.startDate,
    required this.endDate,
    this.imagePath,
  });

  Property copyWith({
    String? id,
    String? name,
    String? address,
    String? tenant,
    String? price,
    String? color,
    String? startDate,
    String? endDate,
    String? imagePath,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      tenant: tenant ?? this.tenant,
      price: price ?? this.price,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imagePath: imagePath ?? this.imagePath
    );
  }

// DATABASE SYSTEM
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'tenant': tenant,
      'price': price,
      'color': color,
      'startDate': startDate,
      'endDate': endDate,
      'imagePath': imagePath
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      tenant: map['tenant'] ?? '',
      price: map['price'] ?? '',
      color: map['color'] ?? '',
      startDate: map['startDate'] ?? '', 
      endDate: map['endDate'] ?? '', 
      imagePath: map['imagePath'] ?? '',
    );
  }
}