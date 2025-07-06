import 'package:flutter/material.dart';
import 'package:traderview/core/constants/colors.dart';
import 'package:traderview/core/widgets/custom_card.dart';

class PaginatedTable<T> extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<T> items;
  final Widget Function(T item) rowBuilder;
  final VoidCallback? onNextPage;
  final VoidCallback? onPrevPage;
  final bool isLastPage;

  const PaginatedTable({
    super.key,
    required this.title,
    required this.headers,
    required this.items,
    required this.rowBuilder,
    this.onNextPage,
    this.onPrevPage,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderWithControls(),
          const SizedBox(height: 24),
          _buildTableHeader(),
          const Divider(),
          ...items.map(rowBuilder),
        ],
      ),
    );
  }

  Widget _buildHeaderWithControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: CustomColor.bgButtonTableSecond,
              radius: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.grey,
                  size: 16,
                ),
                onPressed: onPrevPage,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: CustomColor.bgButtonTablePrimary,
              radius: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 16,
                ),
                onPressed: isLastPage ? null : onNextPage,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        for (int i = 0; i < headers.length; i++)
          Expanded(
            flex: i == headers.length - 1 ? 1 : 2,
            child: Row(
              mainAxisAlignment: i == headers.length - 1
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  headers[i],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
