import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/side_menu_widget.dart';

class FacilityPage extends StatefulWidget {
  const FacilityPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FacilityPage> createState() => _FacilityPageState();
}

/// Состояние (данные) вкладки с базовой информацией
class _FacilityPageState extends State<FacilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Facility data'),
      ),
      drawer: SideMenuWidget(),
    );
  }
}
