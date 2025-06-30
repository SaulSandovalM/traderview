import 'package:flutter/material.dart';
import 'package:traderview/screens/customers/widget/main_customers.dart';

class Customers extends StatelessWidget {
  const Customers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Clientes'),
          MainCustomers(),
        ],
      ),
    );
  }
}
