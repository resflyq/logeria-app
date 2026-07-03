class Property {
  final String id;
  final String name;
  final String address;
  final String tenant;

  const Property({
    required this.id,
    required this.name,
    required this.address,
    required this.tenant,
  });

  Property copyWith({
    String? id,
    String? name,
    String? address,
    String? tenant,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      tenant: tenant ?? this.tenant,
    );
  }
}