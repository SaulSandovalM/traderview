import 'package:flutter/material.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Últimas acciones",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(4, (index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Cliente #$index actualizó inversión"),
                subtitle: Text("Hace ${index + 1} horas"),
                leading: const Icon(Icons.update),
              );
            }),
          ],
        ),
      ),
    );
  }
}
