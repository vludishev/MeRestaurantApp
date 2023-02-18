import 'dart:ffi';

class ProductModel {
  final String barcode;
  final String name;

  const ProductModel({required this.barcode, required this.name});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        barcode: json['barcode'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
      };
}
