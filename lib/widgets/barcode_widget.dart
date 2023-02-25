import 'package:flutter/material.dart';
import '../models/product_management_view_model.dart';

class BarcodeWidget extends StatelessWidget {
  final ProductManagementViewModel product;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const BarcodeWidget(
      {Key? key,
      required this.product,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Продукт: ${product.productBarcode}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Text(
                        'Упаковка: ${product.boxBarcode}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      product.productName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Пачек: ${product.quantityPack}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Text(
                        'Единиц: ${product.quantityUnit}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
