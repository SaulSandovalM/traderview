import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/api/customer_service.dart';
import 'package:traderview/core/widgets/custom_button.dart';
import 'package:traderview/core/widgets/paginated_table.dart';
import 'package:traderview/core/widgets/search.dart';
import 'package:traderview/core/widgets/section_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final CustomerService customerRepo = CustomerService();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> currentDocs = [];
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> previousDocs = [];

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    final docs = await customerRepo.getFirstPage();
    setState(() {
      currentDocs = docs;
      previousDocs.clear();
      isLastPage = docs.length < CustomerService.limitPerPage;
    });
  }

  Future<void> loadNextPage() async {
    if (currentDocs.isEmpty) return;

    final lastDoc = currentDocs.last;
    final nextDocs = await customerRepo.getNextPage(lastDoc);

    if (nextDocs.isNotEmpty) {
      setState(() {
        previousDocs.add(currentDocs.first);
        currentDocs = nextDocs;
        isLastPage = nextDocs.length < CustomerService.limitPerPage;
      });
    } else {
      setState(() => isLastPage = true);
    }
  }

  Future<void> loadPreviousPage() async {
    if (previousDocs.isEmpty) return;

    final previousLast = previousDocs.removeLast();
    final result = await customerRepo.getNextPage(previousLast);

    setState(() {
      currentDocs = result;
      isLastPage = false;
    });
  }

  void _goToCreateCustomer() => context.go('/create-customer');

  @override
  Widget build(BuildContext context) {
    final clientes = currentDocs.map((doc) {
      final data = doc.data();
      return {
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
        'phone': data['phone'] ?? '',
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(text: 'Gestión de clientes'),
            CustomButton(
              text: 'Crear nuevo cliente',
              onPressed: _goToCreateCustomer,
              icon: Icons.add_circle,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Text(
            'En esta sección podrás dar de alta nuevos usuarios. '
            'Registra clientes con su información básica para facilitar el seguimiento de sus inversiones.',
          ),
        ),
        const Divider(),
        const SizedBox(height: 25),
        const Search(),
        PaginatedTable<Map<String, dynamic>>(
          title: 'Clientes',
          headers: const ['Nombre', 'Correo', 'Teléfono', 'Acciones'],
          items: clientes,
          onPrevPage: loadPreviousPage,
          onNextPage: loadNextPage,
          isLastPage: isLastPage,
          rowBuilder: (cliente) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(flex: 2, child: Text(cliente['name'])),
                    Expanded(flex: 2, child: Text(cliente['email'])),
                    Expanded(flex: 2, child: Text(cliente['phone'])),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                          ),
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
