// import 'dart:typed_data';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// Future<Uint8List> buildInvestmentPdfBytes({
//   required String name,
//   required String accountNumber,
//   required String currency,
//   required String accountType,
//   required String company,
//   required List<Map<String, dynamic>> movements,
//   required String netProfit,
//   required String grossProfit,
//   required String grossLoss,
//   required String gainFactor,
//   required String expectedPayment,
// }) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       margin: const pw.EdgeInsets.all(24),
//       build: (context) => [
//         pw.Header(
//           level: 0,
//           child: pw.Text(
//             'Reporte de Inversiones',
//             style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
//           ),
//         ),
//         pw.SizedBox(height: 8),
//         pw.Text(
//           'Datos de la cuenta',
//           style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//         ),
//         pw.SizedBox(height: 6),
//         pw.Table(
//           columnWidths: {
//             0: const pw.FlexColumnWidth(2),
//             1: const pw.FlexColumnWidth(4),
//           },
//           children: [
//             pw.TableRow(children: [pw.Text('Nombre'), pw.Text(name)]),
//             pw.TableRow(children: [
//               pw.Text('Número de cuenta'),
//               pw.Text(accountNumber)
//             ]),
//             pw.TableRow(children: [pw.Text('Moneda'), pw.Text(currency)]),
//             pw.TableRow(
//               children: [pw.Text('Tipo de cuenta'), pw.Text(accountType)],
//             ),
//             pw.TableRow(children: [pw.Text('Compañía'), pw.Text(company)]),
//           ],
//         ),
//         pw.SizedBox(height: 16),
//         pw.Text(
//           'Movimientos',
//           style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//         ),
//         pw.SizedBox(height: 6),
//         pw.TableHelper.fromTextArray(
//           headers: const [
//             'Hora',
//             'Trato',
//             'Símbolo',
//             'Beneficio',
//             'Balance',
//             'Comentario'
//           ],
//           data: movements
//               .map((m) => [
//                     m['time'] ?? '',
//                     m['deal'] ?? '',
//                     m['symbol'] ?? '',
//                     m['profit'] ?? '',
//                     m['balance'] ?? '',
//                     m['comment'] ?? '',
//                   ])
//               .toList(),
//           headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//           cellAlignment: pw.Alignment.centerLeft,
//           headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
//           cellPadding:
//               const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 3),
//         ),
//         pw.SizedBox(height: 16),
//         pw.Text(
//           'Resumen',
//           style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//         ),
//         pw.SizedBox(height: 6),
//         pw.Table(
//           columnWidths: {
//             0: const pw.FlexColumnWidth(3),
//             1: const pw.FlexColumnWidth(2),
//           },
//           children: [
//             pw.TableRow(children: [
//               pw.Text('Beneficio Neto Total'),
//               pw.Text(netProfit)
//             ]),
//             pw.TableRow(
//               children: [pw.Text('Beneficio Bruto'), pw.Text(grossProfit)],
//             ),
//             pw.TableRow(
//               children: [pw.Text('Pérdida Bruta'), pw.Text(grossLoss)],
//             ),
//             pw.TableRow(
//               children: [pw.Text('Factor de Ganancia'), pw.Text(gainFactor)],
//             ),
//             pw.TableRow(
//               children: [pw.Text('Pago Esperado'), pw.Text(expectedPayment)],
//             ),
//           ],
//         ),
//       ],
//     ),
//   );

//   return pdf.save();
// }

import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

Future<void> pdfHelper() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Hello World!'),
      ),
    ),
  );

  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
}
