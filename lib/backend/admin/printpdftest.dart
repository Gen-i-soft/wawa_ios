import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
class PrintPdfTest extends StatefulWidget {
  const PrintPdfTest({Key? key}) : super(key: key);

  @override
  State<PrintPdfTest> createState() => _PrintPdfTestState();
}

class _PrintPdfTestState extends State<PrintPdfTest> {

 Future<void> getPrintPdf() async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
          format: format,
          html: '<html><body><p>Hello!</p></body></html>',
          //htmlString!,
        ));
  }


  @override
  void initState() {
    // TODO: implement initState
    getPrintPdf();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
