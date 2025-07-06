import 'package:flutter/material.dart';
import 'package:traderview/core/widgets/custom_button.dart';
import 'package:traderview/core/widgets/paginated_table.dart';
import 'package:traderview/core/widgets/search.dart';
import 'package:traderview/core/widgets/section_title.dart';
import 'package:go_router/go_router.dart';

class Customers extends StatelessWidget {
  const Customers({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> clientes = [
      {
        "nombre": "Saúl Sandoval Mondragón",
        "correo": "sauldevelop@gmail.com",
        "telefono": "7711895701",
      },
      {
        "nombre": "Jorge David López Lucas",
        "correo": "j.salinas@empresa.com",
        "telefono": "55 8765 4321",
      },
      {
        "nombre": "Jesus Salvador Leon Avila",
        "correo": "lucia.r@dominio.com",
        "telefono": "55 3333 2222",
      },
      {
        "nombre": "Jesus Salvador Leon Avila",
        "correo": "lucia.r@dominio.com",
        "telefono": "55 3333 2222",
      },
    ];

    Future<void> test() {
      context.go('/create-customer');
      return Future.value();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(text: 'Gestión de clientes'),
            CustomButton(
              text: 'Crear nuevo cliente',
              onPressed: test,
              icon: Icons.add_circle,
            )
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Text(
            'En esta sección podrás dar de alta nuevos usuarios. Registra clientes con su información básica para facilitar el siguimiento de sus inversiones.',
          ),
        ),
        const Divider(),
        const SizedBox(height: 25),
        const Search(),
        PaginatedTable<Map<String, dynamic>>(
          title: 'Clientes',
          headers: const ['Nombre', 'Correo', 'Teléfono', 'Acciones'],
          items: clientes,
          // onNextPage: () => cargarSiguientePagina(),
          // onPrevPage: () => cargarPaginaAnterior(),
          isLastPage: false,
          rowBuilder: (cliente) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(flex: 2, child: Text(cliente['nombre'] ?? '')),
                    Expanded(flex: 2, child: Text(cliente['correo'] ?? '')),
                    Expanded(flex: 2, child: Text(cliente['telefono'] ?? '')),
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
