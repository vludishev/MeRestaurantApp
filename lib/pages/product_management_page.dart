import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/entities/box_entity.dart';
import 'package:flutter_application/widgets/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../entities/product_entity.dart';
import '../entities/stock_entity.dart';
import '../custom_icons_icons.dart';
import '../services/database_helper.dart';
import '../widgets/side_menu_widget.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

enum PackagingType { box, pack, unit }

const List<Widget> icons = <Widget>[
  Icon(CustomIcons.box),
  Icon(CustomIcons.product_hunt),
  Icon(CustomIcons.unity),
];

/// Вкладка с базовой информацией по штрих-кодам
class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

/// Состояние (данные) вкладки с базовой информацией
class _ProductManagementPageState extends State<ProductManagementPage> {
  int _scanBarcode = 0;

  final productNameController = TextEditingController();
  final numberPackagesController = TextEditingController();
  final numberItemsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    productNameController.dispose();
    super.dispose();
  }

  SampleItem? selectedMenu;

  Future<bool> scan() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      _scanBarcode = int.parse(barcodeScanRes);
    });

    return true;
  }

  Future<void> showMessageBox(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    if (!mounted) return;
    int boxBarcode = 0;
    int itemBarcode = 0;

    await showMessageBox('Сканируйте коробку').then((value) async {
      await scan();
      boxBarcode = _scanBarcode;
    });

    await showMessageBox('Теперь сканируйте один элемент содержимого в коробке')
        .then((value) async {
      await scan();
      itemBarcode = _scanBarcode;
    });

    // if (boxBarcode == itemBarcode) {
    //   await showMessageBox('Некорректные значения штрих-кодов');
    //   return;
    // }

    createProduct(boxBarcode, itemBarcode);
  }

  Future<void> createProduct(int boxBarcode, int itemBarcode) async {
    final List<bool> selectedPackagingTypes = <bool>[true, true, false];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Box barcode: $boxBarcode'),
                  const SizedBox(height: 10),
                  Text(
                      '${selectedPackagingTypes[2] ? 'Package' : 'Product'} barcode: $itemBarcode'),
                  const SizedBox(height: 10),
                  TextField(
                      controller: productNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter the product name')),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: selectedPackagingTypes[2],
                    child: TextField(
                      controller: numberPackagesController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter the number of packages'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: numberItemsController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText:
                            'Enter the number items ${selectedPackagingTypes[2] ? 'of package' : ''}'),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      // All buttons are selectable.
                      setState(() {
                        selectedPackagingTypes[index] =
                            !selectedPackagingTypes[index];
                        // print(_selectedPackagingTypes[index]);
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.green[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.green[200],
                    color: Colors.green[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: selectedPackagingTypes,
                    children: icons,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    var packagesNumber = numberPackagesController.value as int;
    var itemsNumber = numberItemsController.value as int;
    if (selectedPackagingTypes[2]) {
      itemsNumber *= packagesNumber;
    }

    Product product = Product(
        id: itemBarcode,
        name: productNameController.text,
        quantity: itemsNumber,
        createdTime: DateTime.now());
    await DatabaseHelper.createProduct(product);

    Box box =
        Box(id: boxBarcode, productId: itemBarcode, quantity: packagesNumber);
    await DatabaseHelper.createBox(box);

    var quantity = await DatabaseHelper.getCountProduct() ?? 0;
    if (quantity > 0) {
      startStockRecount(quantity);
      return;
    }
    // // ignore: use_build_context_synchronously
    // stackRecountDialog(context, quantity);
  }

  // Future<void> packagingTypeDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text('Выберите вид упаковки'),
  //       actions: [
  //         const TextField(
  //           decoration: InputDecoration(
  //               border: OutlineInputBorder(),
  //               hintText: 'Введите кол-во ед. товара'),
  //         ),
  //         Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: IconButton(
  //                 iconSize: 100,
  //                 onPressed: () => scanBarcodeNormal(PackagingType.pack),
  //                 icon: const Icon(Icons.abc),
  //               ),
  //             ),
  //             Expanded(
  //               child: IconButton(
  //                 iconSize: 100,
  //                 onPressed: () => scanBarcodeNormal(PackagingType.box),
  //                 icon: const Icon(Icons.add_box),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  Future<void> startStockRecount(int quantity) async {
    StockRecount model =
        StockRecount(productId: _scanBarcode, quantity: quantity);
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
        onPressed: () => scanBarcodeNormal(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
