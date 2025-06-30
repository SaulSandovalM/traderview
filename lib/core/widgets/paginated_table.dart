import 'package:flutter/material.dart';

class PaginatedTable<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final List<DataColumn> columns;
  final DataRow Function(T data, int index) buildRow;
  final int rowsPerPage;

  const PaginatedTable({
    super.key,
    required this.stream,
    required this.columns,
    required this.buildRow,
    this.rowsPerPage = 10,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay información'));
        }

        final data = snapshot.data!;
        return PaginatedDataTable(
          columns: columns,
          source: _GenericDataSource(data, buildRow),
          rowsPerPage: rowsPerPage,
        );
      },
    );
  }
}

class _GenericDataSource<T> extends DataTableSource {
  final List<T> data;
  final DataRow Function(T, int) buildRow;

  _GenericDataSource(this.data, this.buildRow);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    return buildRow(data[index], index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
