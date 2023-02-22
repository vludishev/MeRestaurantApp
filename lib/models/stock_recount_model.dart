const String tableStockRecount = 'stock';

class StockRecountFields {
  static final List<String> values = [
    /// Добавить все поля
    id, productId, quantity
  ];

  static const String id = '_id';
  static const String productId = 'productId';
  static const String quantity = 'quantity';
}

class StockRecount {
  final int? id;
  final int? productId;
  final int quantity;

  const StockRecount({
    this.id,
    this.productId,
    required this.quantity,
  });

  Map<String, Object?> toJson() => {
        StockRecountFields.id: id,
        StockRecountFields.productId: productId,
        StockRecountFields.quantity: StockRecountFields.quantity,
      };

  static StockRecount fromJson(Map<String, Object?> json) => StockRecount(
        id: json[StockRecountFields.id] as int?,
        productId: json[StockRecountFields.productId] as int?,
        quantity: json[StockRecountFields.quantity] as int,
      );

  StockRecount copy({int? id, int? productId, int? quantity}) => StockRecount(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );
}
