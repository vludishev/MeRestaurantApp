import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/side_menu_widget.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

/// Состояние (данные) вкладки с базовой информацией
class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Feedback page'),
      ),
      drawer: SideMenuWidget(),
    );
  }
}
