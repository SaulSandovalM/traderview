import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:traderview/core/widgets/paginated_table.dart';

class MainCustomers extends StatelessWidget {
  const MainCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PaginatedTable<Map<String, dynamic>>(
        stream: Stream.value([
          {
            'id': '1',
            'name': 'Juan',
            'lastName': 'Pérez',
            'secondLastName': 'García',
            'phoneNumber': '5551234567',
            'email': 'juan.perez@email.com',
            'createdAt': DateTime.now(),
            'status': 'Activo',
          },
        ]),
        // customersService.getCustomersStreamByBusiness(businessId)
        columns: const [
          DataColumn(
            label: Text(
              'Nombre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Telefono',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Correo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Creado en',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Estatus',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Acciones',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        buildRow: (data, index) {
          String formatDate(dynamic date) {
            if (date is Timestamp) date = date.toDate();
            return DateFormat('dd/MM/yyyy', 'es').format(date);
          }

          return DataRow(cells: [
            DataCell(
              Text(
                '${data['name'] ?? ''} ${data['lastName'] ?? ''} ${data['secondLastName'] ?? ''}'
                        .trim()
                        .isNotEmpty
                    ? '${data['name'] ?? ''} ${data['lastName'] ?? ''} ${data['secondLastName'] ?? ''}'
                    : 'Sin nombre',
              ),
              onTap: () => context.go('/detail-customer/${data['id']}'),
            ),
            DataCell(Text(data['phoneNumber']?.toString() ?? 'Sin número')),
            DataCell(Text(data['email'] ?? 'Sin correo')),
            DataCell(
              Text(data['createdAt'] != null
                  ? formatDate(data['createdAt'])
                  : 'Sin fecha'),
            ),
            DataCell(
              Row(
                children: [
                  Icon(
                    data['status'] == 'Activo'
                        ? Icons.check_circle
                        : data['status'] == 'Bloqueado'
                            ? Icons.hourglass_empty
                            : Icons.cancel,
                    color: data['status'] == 'Activo'
                        ? Colors.green
                        : data['status'] == 'Bloqueado'
                            ? Colors.orange
                            : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(data['status'] ?? 'Sin estado'),
                ],
              ),
            ),
            DataCell(
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    context.go('/edit-customer/${data['id']}');
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar cliente'),
                        content: const Text(
                            '¿Está seguro de que desea eliminar este cliente?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              // await CustomersService().deleteCustomer(
                              //   businessId: businessId,
                              //   customerId: data['id'],
                              // );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cliente eliminado'),
                                ),
                              );
                            },
                            child: const Text('Eliminar',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}
