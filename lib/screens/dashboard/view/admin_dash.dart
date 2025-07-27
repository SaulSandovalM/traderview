import 'package:flutter/material.dart';
import 'package:traderview/core/widgets/custom_card.dart';
import 'package:traderview/core/widgets/section_title.dart';
import 'package:traderview/api/customer_service.dart';

class AdminDash extends StatelessWidget {
  const AdminDash({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;

    final customerService = CustomerService();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(text: 'Resumen'),
            const SizedBox(height: 20),
            isSmallScreen
                ? Column(
                    children: [
                      FutureBuilder<int>(
                        future: customerService.getClientUserCount(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return CustomCard(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Row(
                              children: [
                                const Icon(Icons.people, size: 40),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            '$count',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const CustomCard(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up, size: 40),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Inversiones',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '45',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const CustomCard(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 40),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Descargas',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '9',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      FutureBuilder<int>(
                        future: customerService.getClientUserCount(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Expanded(
                            child: CustomCard(
                              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Row(
                                children: [
                                  const Icon(Icons.people, size: 40),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Usuarios',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      snapshot.connectionState ==
                                              ConnectionState.waiting
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              '$count',
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Expanded(
                        flex: 1,
                        child: CustomCard(
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            children: [
                              Icon(Icons.trending_up, size: 40),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Inversiones',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '9',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: CustomCard(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            children: [
                              Icon(Icons.download, size: 40),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descargas',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '9',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            isSmallScreen
                ? const Column(
                    children: [
                      CustomCard(
                        margin: EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('Gráfico de inversiones'),
                          ),
                        ),
                      ),
                      CustomCard(
                        margin: EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('Otro gráfico'),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomCard(
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('Gráfico de inversiones'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomCard(
                          margin: EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('Otro gráfico'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
