import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/models/stock_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/product_model.dart';
import '../services/database_helper.dart';
import 'side_menu_widget.dart';

class ScannerWidget extends StatefulWidget {
  @override
  _ScannerWidgetState createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) async {
      final intBarcode = int.parse(barcode as String);
      if (intBarcode > 0) {
        Product model =
            Product(id: intBarcode, name: "test", createdTime: DateTime.now());
        await DatabaseHelper.createProduct(model);

        // StockRecount stModel = StockRecount(productId: intBarcode, quantity: 4);
        // await DatabaseHelper.create(model);
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    final intBarcode = int.parse(barcodeScanRes);
    if (intBarcode > 0) {
      Product model =
          Product(id: intBarcode, name: "test", createdTime: DateTime.now());
      await DatabaseHelper.createProduct(model);

      var quantity = await DatabaseHelper.getCountProduct() ?? 0;
      if (quantity > 0) {
        startStockRecount(quantity);
        return;
      }
      // ignore: use_build_context_synchronously
      _dialogBuilder(context, quantity);
    }
  }

  Future<void> _dialogBuilder(BuildContext context, int quantity) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Запуск пересчёта'),
        content: const Text('''
        Нет активного пересчёта.\n
        Хотите начать новый?
        '''),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async =>
                Navigator.pop(context, startStockRecount(quantity)),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  Future<void> startStockRecount(int quantity) async {
    final barcodeInt = int.parse(_scanBarcode);
    StockRecount model =
        StockRecount(productId: barcodeInt, quantity: ++quantity);
    await DatabaseHelper.createProductInStock(model);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: SideMenuWidget(),
        appBar: AppBar(title: const Text('Barcode scan')),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
                alignment: Alignment.center,
                child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () => scanBarcodeNormal(),
                          child: Text('Start barcode scan')),
                      ElevatedButton(
                          onPressed: () => scanQR(),
                          child: Text('Start QR scan')),
                      ElevatedButton(
                          onPressed: () => startBarcodeScanStream(),
                          child: Text('Start barcode scan stream')),
                      Text('Scan result : $_scanBarcode\n',
                          style: TextStyle(fontSize: 20))
                    ]));
          },
        ),
      ),
    );
  }
}
