import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traderview/core/widgets/breadcrumbs.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/core/widgets/custom_card.dart';

class InvestmentsList extends StatefulWidget {
  final String customerId;

  const InvestmentsList({super.key, required this.customerId});

  @override
  State<InvestmentsList> createState() => _InvestmentsListState();
}

class _InvestmentsListState extends State<InvestmentsList> {
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Breadcrumbs(
          backText: 'Clientes',
          onPressed: () => context.go('/customers'),
          text: 'Agregar inversiones',
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.customerId)
                  .collection('investments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No hay inversiones registradas"));
                }

                final docs = snapshot.data!.docs;

                // Obtener todos los años disponibles
                final years = docs
                    .map((doc) => doc.id.split('-')[0])
                    .toSet()
                    .toList()
                  ..sort((a, b) => b.compareTo(a)); // Descendente

                // Filtrar documentos por año seleccionado
                final filteredDocs = selectedYear != null
                    ? docs
                        .where((doc) => doc.id.startsWith(selectedYear!))
                        .toList()
                    : docs;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dropdown para seleccionar año
                    DropdownButton<String>(
                      hint: const Text("Seleccione un año"),
                      value: selectedYear,
                      isExpanded: true,
                      items: years
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Lista de meses
                    ...filteredDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final monthId = doc.id;
                      return Column(
                        children: [
                          ListTile(
                            title: Text("Mes $monthId"),
                            subtitle: Text(
                              "Cuenta: ${data['accountNumber'] ?? ''} | "
                              "Compañía: ${data['company'] ?? ''}",
                            ),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              // Navegar a la edición del mes
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
