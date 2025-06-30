import 'package:flutter/material.dart';
import 'package:traderview/screens/investments/widget/main_investments.dart';

class Investments extends StatelessWidget {
  const Investments({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Gestión de Inversiones',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          MainInvestments(),
        ],
      ),
    );
  }
}
