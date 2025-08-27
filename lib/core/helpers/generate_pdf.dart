import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePdf({
  required String filename,
  required String name,
  required String accountNumber,
  required String currencyController,
  required String accountType,
  required String company,
  required List<Map<String, dynamic>> movements,
  required String netProfit,
  required String grossProfit,
  required String grossLoss,
  required String gainFactor,
  required String expectedPayment,
  required String time,
  required String deal,
  required String symbol,
  required String type,
  required String direction,
  required String volume,
  required String price,
  required String order,
  required String commission,
  required String fee,
  required String swap,
  required String profit,
  required String balance,
  required String comment,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Text('Inversiones', style: const pw.TextStyle(fontSize: 30)),
          pw.Text('Nombre: $name'),
          pw.Text('Numero de cuenta: $accountNumber'),
        ],
      ),
    ),
  );

  await Printing.sharePdf(bytes: await pdf.save(), filename: filename);
}
