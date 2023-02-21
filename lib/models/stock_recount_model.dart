class StockRecountModel {
  final int? id;
  final int productId;
  final int quantity;

  const StockRecountModel({
    this.id,
    required this.productId,
    required this.quantity,
  });

  factory StockRecountModel.fromJson(Map<String, dynamic> json) =>
      StockRecountModel(
        id: json['id'],
        productId: json['productId'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'productId': productId, 'quantity': quantity};
}
