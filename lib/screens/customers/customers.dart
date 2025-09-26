import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traderview/api/customer_service.dart';
import 'package:traderview/api/wallet_service.dart';
import 'package:traderview/api/investments_service.dart';
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
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> previousDocs = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> currentDocs = [];
  List<Map<String, dynamic>> allClientes = [];
  List<Map<String, dynamic>> filteredClientes = [];

  bool isLastPage = false;
  bool isLoading = true;
  bool isSearching = false;

  String searchTerm = '';

  final CustomerService customerRepo = CustomerService();
  final WalletService walletService = WalletService();
  final InvestmentService investmentService = InvestmentService();

  @override
  void initState() {
    super.initState();
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    setState(() => isLoading = true);
    final docs = await customerRepo.getFirstPage();
    setState(() {
      currentDocs = docs;
      previousDocs.clear();
      isLastPage = docs.length < CustomerService.limitPerPage;
      isLoading = false;
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

  Future<void> _openInvestmentFlow(String customerId) async {
    try {
      final walletId = await walletService.getWalletId(customerId);
      if (walletId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este cliente no tiene cartera. Creémosla primero.'),
          ),
        );
        context.go('/create-wallet/$customerId');
        return;
      }
      if (!mounted) return;
      context.go('/investments/$customerId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir inversiones: $e')),
      );
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
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: Colors.deepPurpleAccent,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
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
          Search(
            onChanged: (value) async {
              searchTerm = value.trim().toLowerCase();

              if (searchTerm.isEmpty) {
                setState(() {
                  isSearching = false;
                });
              } else {
                isSearching = true;
                final results = await customerRepo.getAllClients();

                setState(() {
                  allClientes = results;
                  filteredClientes = allClientes.where((cliente) {
                    final name = (cliente['name'] ?? '').toLowerCase();
                    final email = (cliente['email'] ?? '').toLowerCase();
                    final phone = (cliente['phone'] ?? '').toLowerCase();

                    return name.contains(searchTerm) ||
                        email.contains(searchTerm) ||
                        phone.contains(searchTerm);
                  }).toList();
                });
              }
            },
          ),
          ...(isSearching
              ? [
                  PaginatedTable<Map<String, dynamic>>(
                    title: 'Resultados de búsqueda',
                    headers: const ['Nombre', 'Correo', 'Teléfono', 'Acciones'],
                    items: filteredClientes,
                    isLastPage: true,
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
                                    FutureBuilder<String?>(
                                      future: walletService.getWalletId(
                                        currentDocs
                                            .firstWhere((doc) =>
                                                doc.data()['email'] ==
                                                cliente['email'])
                                            .id,
                                      ),
                                      builder: (context, walletSnap) {
                                        final walletId = walletSnap.data;
                                        final customerId = currentDocs
                                            .firstWhere((doc) =>
                                                doc.data()['email'] ==
                                                cliente['email'])
                                            .id;

                                        return FutureBuilder<bool>(
                                          future: investmentService
                                              .hasCurrentMonthInvestment(
                                                  customerId),
                                          builder: (context, investSnap) {
                                            final hasInvestment =
                                                investSnap.data ?? false;

                                            return PopupMenuButton<String>(
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  context.go(
                                                      '/edit-customer/$customerId');
                                                }
                                                if (value == 'edit-wallet' &&
                                                    walletId != null) {
                                                  context.go(
                                                      '/wallet/$customerId/$walletId');
                                                }
                                                if (value == 'investment') {
                                                  _openInvestmentFlow(
                                                      customerId);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'edit',
                                                  child: ListTile(
                                                    leading: Icon(Icons.edit),
                                                    title: Text('Editar'),
                                                  ),
                                                ),
                                                if (walletId == null)
                                                  const PopupMenuItem(
                                                    value: 'wallet',
                                                    child: ListTile(
                                                      leading: Icon(Icons
                                                          .account_balance_wallet),
                                                      title:
                                                          Text('Crear cartera'),
                                                    ),
                                                  ),
                                                if (walletId != null)
                                                  const PopupMenuItem(
                                                    value: 'edit-wallet',
                                                    child: ListTile(
                                                      leading: Icon(Icons
                                                          .account_balance_wallet),
                                                      title: Text(
                                                          'Editar cartera'),
                                                    ),
                                                  ),
                                                if (walletId != null)
                                                  PopupMenuItem(
                                                    value: 'investment',
                                                    child: ListTile(
                                                      leading: const Icon(Icons
                                                          .waterfall_chart),
                                                      title: Text(
                                                        hasInvestment
                                                            ? 'Editar inversiones'
                                                            : 'Agregar inversiones',
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    )
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
                ]
              : [
                  PaginatedTable<Map<String, dynamic>>(
                    title: 'Clientes',
                    headers: const ['Nombre', 'Correo', 'Teléfono', 'Acciones'],
                    items: currentDocs.map((doc) {
                      final data = doc.data();
                      return {
                        'id': doc.id,
                        'name': data['name'] ?? '',
                        'email': data['email'] ?? '',
                        'phone': data['phone'] ?? '',
                      };
                    }).toList(),
                    onNextPage: loadNextPage,
                    onPrevPage: loadPreviousPage,
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
                                    FutureBuilder<String?>(
                                      future: walletService.getWalletId(
                                        currentDocs
                                            .firstWhere((doc) =>
                                                doc.data()['email'] ==
                                                cliente['email'])
                                            .id,
                                      ),
                                      builder: (context, walletSnap) {
                                        final walletId = walletSnap.data;
                                        final customerId = currentDocs
                                            .firstWhere((doc) =>
                                                doc.data()['email'] ==
                                                cliente['email'])
                                            .id;

                                        return FutureBuilder<bool>(
                                          future: investmentService
                                              .hasCurrentMonthInvestment(
                                                  customerId),
                                          builder: (context, investSnap) {
                                            final hasInvestment =
                                                investSnap.data ?? false;

                                            return PopupMenuButton<String>(
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  context.go(
                                                      '/edit-customer/$customerId');
                                                }
                                                if (value == 'edit-wallet' &&
                                                    walletId != null) {
                                                  context.go(
                                                      '/wallet/$customerId/$walletId');
                                                }
                                                if (value == 'investment') {
                                                  _openInvestmentFlow(
                                                      customerId);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'edit',
                                                  child: ListTile(
                                                    leading: Icon(Icons.edit),
                                                    title: Text('Editar'),
                                                  ),
                                                ),
                                                if (walletId == null)
                                                  const PopupMenuItem(
                                                    value: 'wallet',
                                                    child: ListTile(
                                                      leading: Icon(Icons
                                                          .account_balance_wallet),
                                                      title:
                                                          Text('Crear cartera'),
                                                    ),
                                                  ),
                                                if (walletId != null)
                                                  const PopupMenuItem(
                                                    value: 'edit-wallet',
                                                    child: ListTile(
                                                      leading: Icon(Icons
                                                          .account_balance_wallet),
                                                      title: Text(
                                                          'Editar cartera'),
                                                    ),
                                                  ),
                                                if (walletId != null)
                                                  PopupMenuItem(
                                                    value: 'investment',
                                                    child: ListTile(
                                                      leading: const Icon(Icons
                                                          .waterfall_chart),
                                                      title: Text(
                                                        hasInvestment
                                                            ? 'Editar inversiones'
                                                            : 'Agregar inversiones',
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    )
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
                ]),
        ],
      ),
    );
  }
}
