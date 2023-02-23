import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/widgets/barcode_widget.dart';
import 'package:flutter_application/widgets/scanner_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/product_model.dart';
import '../models/stock_model.dart';
import '../services/database_helper.dart';
import '../widgets/side_menu_widget.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

/// Вкладка с базовой информацией по штрих-кодам
class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

/// Состояние (данные) вкладки с базовой информацией
class _ProductManagementPageState extends State<ProductManagementPage> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  SampleItem? selectedMenu;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal(String packagingType) async {
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
      stackRecountDialog(context, quantity);
    }
  }

  Future<void> stackRecountDialog(BuildContext context, int quantity) {
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

  Future<void> stackPackagingTypeDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Выберите вид упаковки'),
        actions: [
          IconButton(
            iconSize: 100,
            onPressed: () => scanBarcodeNormal('pack'),
            icon: const Icon(Icons.abc),
          ),
          IconButton(
            iconSize: 100,
            onPressed: () => scanBarcodeNormal('box'),
            icon: const Icon(Icons.add_box),
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
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<SampleItem>(
            icon: const Icon(Icons.more_horiz),
            initialValue: selectedMenu,
            // Callback that sets the selected popup menu item.
            onSelected: (SampleItem item) {
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                child: Text('Item 1'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemTwo,
                child: Text('Item 2'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemThree,
                child: Text('Item 3'),
              ),
            ],
          ),
          // onPressed: () => {
          // showDialog<void>(
          //   context: context,
          //   builder: (BuildContext context) => AlertDialog(
          //     title: const Text('Подтверждение'),
          //     content:
          //         const Text('Вы уверены, что закончили пересчёт?'),
          //     actions: <Widget>[
          //       TextButton(
          //         onPressed: () => Navigator.pop(context, 'Cancel'),
          //         child: const Text('Отмена'),
          //       ),
          //       TextButton(
          //         onPressed: () async => Navigator.pop(
          //             context, DatabaseHelper.recreateStockTable()),
          //         child: const Text('ОК'),
          //       ),
          //     ],
          //   ),
          // )
          // },
          // icon: const Icon(Icons.more_horiz_sharp)),
        ],
      ),
      body: FutureBuilder<List<Product>?>(
        future: DatabaseHelper.getAllProducts(),
        builder: (context, AsyncSnapshot<List<Product>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => BarcodeWidget(
                  product: snapshot.data![index],
                  onTap: () => {},
                  // onTap: () async {
                  //   await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => NoteScreen(
                  //             note: snapshot.data![index],
                  //           )));
                  //   setState(() {});
                  // },
                  onLongPress: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete this barcode?'),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () async {
                                await DatabaseHelper.deleteProduct(
                                    snapshot.data![index].id!);
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: const Text('Yes'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                itemCount: snapshot.data!.length,
              );
            }
            return const Center(
              child: Text('No notes yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      drawer: const SideMenuWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => stackPackagingTypeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
