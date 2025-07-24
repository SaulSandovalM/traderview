import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traderview/core/widgets/paginated_table.dart';
import 'package:traderview/core/widgets/section_title.dart';

class AccountStatements extends StatelessWidget {
  const AccountStatements({super.key});

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> currentDocs = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          children: [
            SectionTitle(text: 'Estados de cuenta'),
          ],
        ),
        const SizedBox(height: 25),
        const Divider(),
        const SizedBox(height: 25),
        PaginatedTable<Map<String, dynamic>>(
          title: '',
          headers: const ['Fecha', 'PDF'],
          items: currentDocs.map((doc) {
            final data = doc.data();
            return {
              'date': data['date'] ?? '',
              'pdf': data['pdf'] ?? '',
            };
          }).toList(),
          rowBuilder: (cliente) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: Text(cliente['date'])),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text(cliente['Descargar']),
                          const Icon(Icons.ac_unit_sharp),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}
