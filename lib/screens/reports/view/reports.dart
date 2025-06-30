import 'package:flutter/material.dart';
import 'package:traderview/screens/reports/widget/main_reports.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Reportes',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          MainReports(),
        ],
      ),
    );
  }
}
