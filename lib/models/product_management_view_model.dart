import 'package:flutter_application/entities/box_entity.dart';
import 'package:flutter_application/entities/product_entity.dart';

class ProductManagementViewModel {
  final int? boxBarcode;

  final int? productBarcode;

  final String productName;

  final int? quantityPack;

  final int? quantityUnit;

  const ProductManagementViewModel(
      {required this.boxBarcode,
      required this.productBarcode,
      required this.productName,
      this.quantityPack,
      required this.quantityUnit});

  static ProductManagementViewModel fromJson(Map<String, Object?> json) =>
      ProductManagementViewModel(
        boxBarcode: json[BoxFields.id] as int?,
        productBarcode: json[ProductFields.id] as int?,
        productName: json[ProductFields.name] as String,
        quantityPack: json[BoxFields.quantity] as int?,
        quantityUnit: json[ProductFields.quantity] as int?,
      );
}
