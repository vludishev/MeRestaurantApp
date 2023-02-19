import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/barcodeWidget.dart';

import '../models/product_model.dart';
import '../services/database_helper.dart';
import '../widgets/sideMenu.dart';

/// Вкладка с базовой информацией по штрих-кодам
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Состояние (данные) вкладки с базовой информацией
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<ProductModel>?>(
        future: DatabaseHelper.getAllProducts(),
        builder: (context, AsyncSnapshot<List<ProductModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => BarcodeWidget(
                  productModel: snapshot.data![index],
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
                                      snapshot.data![index]);
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
                        });
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
      drawer: SideMenuWidget(),
    );
  }
}
