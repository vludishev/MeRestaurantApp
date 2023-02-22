const String tableProducts = 'products';

class ProductFields {
  static final List<String> values = [
    /// Добавить все поля
    id, name, time
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String time = 'time';
}

class Product {
  final int? id;
  final String name;
  final DateTime createdTime;

  const Product({
    this.id,
    required this.name,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
        ProductFields.id: id,
        ProductFields.name: name,
        ProductFields.time: createdTime.toIso8601String(),
      };

  static Product fromJson(Map<String, Object?> json) => Product(
        id: json[ProductFields.id] as int?,
        name: json[ProductFields.name] as String,
        createdTime: DateTime.parse(json[ProductFields.time] as String),
      );

  Product copy({int? id, String? name, DateTime? createdTime}) => Product(
        id: id ?? this.id,
        name: name ?? this.name,
        createdTime: createdTime ?? this.createdTime,
      );
}
