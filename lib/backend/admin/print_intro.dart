import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wawa/models/purchase_models.dart';
import 'package:wawa/utility/helper.dart';

class PrintIntoPage extends StatefulWidget {
  final DocumentSnapshot document;
  PrintIntoPage({required this.document});

  @override
  _PrintIntoPageState createState() => _PrintIntoPageState();
}

class _PrintIntoPageState extends State<PrintIntoPage> {
  List<String> productNames = [];
  List<String> productPicts = [];
  List<num> prices = [];
  List<num> qtys = [];
  List<num> subTotals = [];
  List<String> htmltwo = [];

  List<PurchaseModels> purchaseModels = [];
  int i = 0;
  int x =0;
  String? _uid;
  String displayName = '';
  double total = 0;
  String? htmlString;
  final dbRef = FirebaseFirestore.instance;
  Helper helper = new Helper();
  bool chkCodeSale = false;
  String? _logo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // genPrint();
    setState(() {
      _uid = widget.document['uid'];
    });

    if(widget.document.data().toString().contains('codeSale')){ //?????
      setState(() {
        chkCodeSale = true;
      });
    }
     
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();
    // final font1 = await rootBundle.load('assets/roboto1.ttf');
    // String no1 = 'บริษัท วาวา2559 จำกัด[สำนักงานใหญ่]';
    final font1 = await rootBundle.load('fonts/ANGSA.ttf');


    //String uid = widget.document['uid'];
    QuerySnapshot snapshot = await dbRef
        // .collection('larn8mobile')
        // .document('y64sRawQi5skalZniDYh')
        .collection('wawastore')
        .doc('wawastore')
        .collection('backend')
        .where('uid', isEqualTo: widget.document['uid'])
        .get();
    print('#uid>>>${widget.document['uid']}');

    if (snapshot.docs.length > 0) {
      for (var item in snapshot.docs) {
        String _addr = item['addr'];
        print('###_adr>>>$_addr');
      }
    }
    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(
                  child: pw.Column(
                children: [
                  pw.Container(
                    height: 40,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'บริษัท วาวา2559 จำกัด[สำนักงานใหญ่]',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 30,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'ที่อยู่: 244 หมู่ 15 ต.พันดอน อ.กุมภวาปี จ.อุดรธานี 41370',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 30,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'เบอร์โทร.042-331152',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 80,
                    width: 400,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: '${widget.document['docNo']}',
                      drawText: true,
                    ),
                  ),
                  pw.Container(
                    height: 40,
                   // padding: const pw.EdgeInsets.only(left: 40),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'ที่อยู่ในการจัดส่ง:',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                   pw.Container(
                    height: 40,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${snapshot.docs[0]['displayName']}',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                   pw.Container(
                    height: 30,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${snapshot.docs[0]['addr']}',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                   pw.Container(
                    height: 30,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'เบอร์โทร: ${snapshot.docs[0]['tel']}',
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                   pw.Container(
                    height: 80,
                    width: 300,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.code128(),
                      data: '${widget.document['docNo']}',
                      drawText: true,
                    ),
                  ),

    
                         
                   if (chkCodeSale == true)
                     
                     pw.Container(
                    height: 30,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'รหัสผู้ขาย:${widget.document['codeSale']} (${widget.document['nameSale']})',
                      
                      style: pw.TextStyle(
                        font: pw.Font.ttf(font1),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ) else pw.Container(),
                
                ],
              ))
            ]),
          ]);
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('พิมพ์ใบนำส่ง/ใบปะหน้า')),
      body: PdfPreview(
        build: (format) {
          return _generatePdf(format, '');
        },
      ),
    );
  }
}
