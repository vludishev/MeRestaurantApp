import 'dart:ffi';

const String tableBoxes = 'boxes';

class BoxFields {
  static final List<String> values = [
    /// Добавить все поля
    id, productId, quantity
  ];

  static const String id = '_id';
  static const String productId = 'productId';
  static const String quantity = 'quantity';
}

class Box {
  final int? id;
  final int productId;
  final int quantity;

  const Box({
    this.id,
    required this.productId,
    required this.quantity,
  });

  Map<String, Object?> toJson() => {
        BoxFields.id: id,
        BoxFields.productId: productId,
        BoxFields.quantity: quantity,
      };

  static Box fromJson(Map<String, Object?> json) => Box(
        id: json[BoxFields.id] as int?,
        productId: json[BoxFields.productId] as int,
        quantity: json[BoxFields.quantity] as int,
      );

  Box copy({int? id, int? productId, int? quantity}) => Box(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );
}
