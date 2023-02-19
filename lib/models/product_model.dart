import 'dart:ffi';

class ProductModel {
  final int id;
  final String barcode;
  final String name;

  const ProductModel({
    required this.id,
    required this.barcode,
    required this.name,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        barcode: json['barcode'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'barcode': barcode, 'name': name};
}
