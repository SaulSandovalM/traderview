import 'package:flutter/material.dart';
import 'package:traderview/screens/dashboard/widget/dashboard_card.dart';
import 'package:traderview/screens/dashboard/widget/graph_placeholder.dart';
import 'package:traderview/screens/dashboard/widget/recent_activity_card.dart';

class MainAdminDash extends StatelessWidget {
  const MainAdminDash({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isCompact = constraints.maxWidth < 900;

        final titles = [
          "Clientes",
          "Inversiones activas",
          "Rendimiento total",
        ];
        final values = ["152", "78", "12.4%"];
        final icons = [
          Icons.people,
          Icons.trending_up,
          Icons.bar_chart,
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Descripción General',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DashboardCard(
                            title: titles[index],
                            value: values[index],
                            icon: icons[index],
                          ),
                        );
                      }),
                    )
                  : Row(
                      children: List.generate(3, (index) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : 8,
                              right: index == 3 ? 0 : 8,
                            ),
                            child: DashboardCard(
                              title: titles[index],
                              value: values[index],
                              icon: icons[index],
                            ),
                          ),
                        );
                      }),
                    ),
              isMobile ? const SizedBox(height: 0) : const SizedBox(height: 16),
              isCompact
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RecentActivityCard(),
                        SizedBox(height: 16),
                        GraphPlaceholder(),
                      ],
                    )
                  : const IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: RecentActivityCard()),
                          SizedBox(width: 16),
                          Expanded(child: GraphPlaceholder()),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
