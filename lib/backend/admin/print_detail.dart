import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
 import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wawa/models/purchase_models.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class PrintDetailPage extends StatefulWidget {
  final DocumentSnapshot document;
  PrintDetailPage({required this.document});

  @override
  _PrintDetailPageState createState() => _PrintDetailPageState();
}

class _PrintDetailPageState extends State<PrintDetailPage> {
  List<String> productNames = [];
  List<String> productPicts = [];
  List<num> prices = [];
  List<num> qtys = [];
  List<num> subTotals = [];
  List<String> htmltwo = [];

  List<PurchaseModels> purchaseModels = [];
  int i = 0;
  int x = 0;
  String? _uid;
  String displayName = 'ไม่ระบุ';
  String addr = 'ไม่ระบุ';
  String employeeCode = 'ไม่ระบุ';
  String employeeTel = 'ไม่ระบุ';
  double total = 0;
  String totalTxt = '0.0';
  String? htmlString;
  String? htmlString2;
  //String? _logo;

  final dbRef = FirebaseFirestore.instance;
  Helper helper = new Helper();
  String nameSale = '';
  var myFormat = NumberFormat('#,##0.00', 'en_US');
  // BarCodeImage image01;
  //BarCodeImage image;

  //Future<Null> cmdPrint() async {}
  @override
  void initState() {
    // TODO: implement initState


    //genPrint();
    super.initState();
    //genPrint();
    //

    // genInfo();

   // if (widget.document.data().toString().contains('codeSale')) {
    //  setState(() {
    //     nameSale =
    //         '${widget.document['codeSale']} (${widget.document['nameSale']})';
    //  });
    //}
  }

  // Future<void> genInfo() async {
  //   setState(() {
  //     _uid = widget.document['uid'];
  //   });
  //   print('####_uid>>>$_uid');
  //   await dbRef
  //       // .collection('larn8mobile')
  //       // .document('y64sRawQi5skalZniDYh')
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('backend')
  //       // .document(widget.document['orderId'])
  //       // .collection('messages')
  //       .where('uid', isEqualTo: _uid)
  //       .get().then((value) {
  //     if (value.docs.isNotEmpty) {
  //       setState(() {
  //         displayName = value.docs[0]['displayName'];
  //         addr = value.docs[0]['addr'];
  //         employeeCode = value.docs[0]['employeeCode'];
  //         employeeTel = value.docs[0]['tel'];
  //
  //         //        String addr = 'ไม่ระบุ';
  //         // String employeeCode = 'ไม่ระบุ';
  //         // String employeeTel = 'ไม่ระบุ';
  //       });
  //       print('####displayName>>>>$displayName');
  //
  //     }
  //
  //   });
  //
  //
  // }

  Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
   // final bgShape = await rootBundle.loadString('assets/resume.svg');

    format = format.applyMargin(
        left: 0.5 * PdfPageFormat.cm,
        top: 0.5 * PdfPageFormat.cm,
        right: 0.5 * PdfPageFormat.cm,
        bottom: 0.5 * PdfPageFormat.cm);
    return pw.PageTheme(
     // pageFormat: format,
       //pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      orientation: pw.PageOrientation.portrait,

      // theme: pw.ThemeData.withFont(
      //   base: await PdfGoogleFonts.openSansRegular(),
      //   bold: await PdfGoogleFonts.openSansBold(),
      //   icons: await PdfGoogleFonts.materialIcons(),
      // ),
      // buildBackground: (pw.Context context) {
      //   return pw.FullPage(
      //     ignoreMargins: true,
      //     child: pw.Stack(
      //       children: [
      //         pw.Positioned(
      //           child: pw.SvgImage(svg: bgShape),
      //           left: 0,
      //           top: 0,
      //         ),
      //         pw.Positioned(
      //           child: pw.Transform.rotate(
      //               angle: pi, child: pw.SvgImage(svg: bgShape)),
      //           right: 0,
      //           bottom: 0,
      //         ),
      //       ],
      //     ),
      //   );
      // },
    );
  }

  Future<Uint8List> genPrint(PdfPageFormat format) async {
    final pdf = pw.Document();
    final font1 = await rootBundle.load('fonts/ANGSA.ttf');
   // _logo = await rootBundle.loadString('images/logo2.png');
    final _logo = pw.MemoryImage(
        (await rootBundle.load('images/logo2.png')).buffer.asUint8List()
    );

    setState(() {
      nameSale =
      '${widget.document['codeSale']} (${widget.document['nameSale']})';

      _uid = widget.document['uid'];
    });
    // print('####_uid>>>$_uid, nameSale = $nameSale');
    await dbRef
    // .collection('larn8mobile')
    // .document('y64sRawQi5skalZniDYh')
        .collection('wawastore')
        .doc('wawastore')
        .collection('backend')
    // .document(widget.document['orderId'])
    // .collection('messages')
        .where('uid', isEqualTo: _uid)
        .get().then((value) {
      if (value.docs.isNotEmpty) {

        if (value.docs[0]['displayName'] != null) {
          setState(() {
            displayName = value.docs[0]['displayName'];
          });

        }

        if (value.docs[0]['addr'] != null) {
          setState(() {
            addr = value.docs[0]['addr'];
          });

        }

        if (value.docs[0]['employeeCode'] != null) {
          setState(() {
            employeeCode = value.docs[0]['employeeCode'];
          });

        }

        if (value.docs[0]['tel'] != null) {
          setState(() {
            employeeTel = value.docs[0]['tel'];
          });

        }

        // print('####displayName>>>>$displayName, addr>>>$addr, employeeCode>>> $employeeCode, employeeTel>>> $employeeTel');

      }

    });
    //genInfo();
    setState(() {
      total = 0;
      productNames.clear();
      productPicts.clear();
      prices.clear();
      qtys.clear();
      subTotals.clear();
      purchaseModels.clear();
      // htmltwo.clear();
    });

    await dbRef
        // .collection('larn8mobile')
        // .document('y64sRawQi5skalZniDYh')
        .collection('wawastore')
        .doc('wawastore')
        .collection('purchase')
        // .document(widget.document['orderId'])
        // .collection('messages')
        .where('docNo', isEqualTo: widget.document['docNo'])
        .where('uid', isEqualTo: widget.document['uid'])
        .orderBy('time')
       // .snapshots()
      //  .listen((event) {
    .get().then((event) {
      int _index = 1;
      if (event.docs.isNotEmpty) {
        for (var item in event.docs) {
          PurchaseModels models = PurchaseModels.fromMap(item.data());
          setState(() {
            purchaseModels.add(models);
          });
          // print('####purchaseModels.length>>>${purchaseModels.length}');

          double _total = double.parse(item['subtotal']);
          total = total + _total;
          // print('####total>>>$total');

      //     String _two = """
      //
      // <tr>
      //   <td>$_index </td>
      //   <td> ${item['name']} <br><img src=${item['picturl']}  width=\"120\" height=\"80\"> </td>
      //   <td> ${item['amounts']}</td>
      //   <td>${item['unit']}</td>
      //    <td>${item['price']}</td>
      //     <td>${MyStyle().myFormat.format(double.parse(item['subtotal']))}</td>
      //
      // </tr>
      //
      //
      //
      //
      //           """;
      //     htmltwo.add(_two);

          // _index++;
        }
      }


      setState(() {
        totalTxt = MyStyle().myFormat.format(total);
      });

//       String _one = """
//
// <!DOCTYPE html>
// <html>
// <head>
// <meta charset="utf-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
//   <style>
//   table, th, td {
//     border: 1px solid black;
//     border-collapse: collapse;
//   }
//           table {
//             -fs-table-paginate: paginate;
//         }
//   th{
//     padding: 5px;
//     text-align: center;
//   }
//      td{
//     padding: 5px;
//     text-align: center;
//     vertical-align:middle;
//   }
//
//
// .right {
//   position: absolute;
//   right: 0px;
//
//
//   padding: 10px;
// }
//
//
//
//
//   </style>
//
//
//
// </head>
//   <body>
//
//
//
//     <h2>บริษัท วาวา2559 จำกัด[สำนักงานใหญ่]</h2>
//     244 หมู่ 15 ต.พันดอน อ.กุมภวาปี จ.อุดรธานี 41370 <br>
//     โทร.042-331152<br>
//     หมายเลขประจำตัวผู้เสียภาษี 0415562000535
//     <br>
//
//
//     เลขที่เอกสาร:<b>${widget.document['docNo']}</b> วันที่: <b>${widget.document['docDate']}</b>
//     ลูกค้า: $displayName รหัสสมาชิก SML : <b>$employeeCode</b>
//     ที่อยู่ในการจัดส่ง: <b>$addr</b> เบอร์โทร: <b>$employeeTel</b>
//
//     รหัสผู้ขาย: $nameSale
//
//
//
//     <table style="width:100%">
//
//
//
//
//
//
//        <thead>
//       <tr>
//         <th style="width:10% ">ลำดับ</th>
//         <th style="width:40% ">รูปสินค้า</th>
//         <th style="width:10% ">จำนวน</th>
//         <th style="width:10% ">หน่วยนับ</th>
//         <th style="width:10% ">หน่วยละ</th>
//         <th style="width:20% ">จำนวนเงิน</th>
//       </tr>
//        </thead>
//
//
// """;

      // String _three = """
      //
      //              </table>
      //
      //
      //
      //             """;




   //   htmlString = """
      
               // $_one
               //   $htmltwo
               //  $_three
               //  <p class="right">รวมทั้งหมด: <b>$totalTxt</b> บาท</p>
               //
               //
               //
               //
               //
               //
               //
               //      </body></html>
               //
               //
               // """;

    });

    final pageTheme = await _myPageTheme(format);

    pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
        //pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        orientation: pw.PageOrientation.portrait,
      // pageTheme: pageTheme,

        //0
       //crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }
          return
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              // decoration: const pw.BoxDecoration(
              //     border: pw.Border(
              //         bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child:pw.SizedBox()
        //
        //         // pw.Column(children: [
        //         //   pw.Row(children: [
        //         //     pw.Container(width: 36, height: 36,child: pw.Image(_logo)),
        //         //
        //         //
        //         //     pw.Text(' บริษัท วาวา2559 จำกัด[สำนักงานใหญ่]', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 20,fontWeight: pw.FontWeight.bold), )
        //         //
        //         //   ],),
        //         //
        //         //   pw.Row(children: [
        //         //     pw.Text('244 หมู่ 15 ต.พันดอน อ.กุมภวาปี จ.อุดรธานี 41370', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), )
        //         //
        //         //   ],),
        //         //
        //         //   pw.Row(children: [
        //         //     pw.Text('โทร.042-331152', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), )
        //         //
        //         //   ],),
        //         //
        //         //   pw.SizedBox(height: 6),
        //         //
        //         //   pw.Row(children: [
        //         //     pw.SizedBox(width: 10),
        //         //
        //         //     pw.Text('เลขที่เอกสาร: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,height: 1.2), ),
        //         //
        //         //
        //         //     pw.Text(' ${widget.document['docNo']}   ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),
        //         //
        //         //     pw.Text('  วันที่: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,height: 2), ),
        //         //
        //         //     pw.Text(' ${widget.document['docDate']}   ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),
        //         //
        //         //
        //         //   ],),
        //         //
        //         //   // pw.SizedBox(height: 12),
        //         //
        //         //   pw.Row(children: [
        //         //     pw.SizedBox(width: 10),
        //         //     pw.Text('ลูกค้า: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),
        //         //
        //         //
        //         //     pw.Text(displayName, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),
        //         //
        //         //     pw.Text('  รหัสสมาชิก SML : ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),
        //         //
        //         //     pw.Text(employeeCode, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),
        //         //
        //         //   ],),
        //         //
        //         //   // pw.SizedBox(height: 12),
        //         //
        //         //   pw.Row(children: [
        //         //     pw.SizedBox(width: 10),
        //         //     pw.Text('ที่อยู่ในการจัดส่ง: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),
        //         //
        //         //
        //         //     pw.Text(addr, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),
        //         //
        //         //     pw.Text('  เบอร์โทร: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),
        //         //
        //         //     pw.Text(employeeTel, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),
        //         //
        //         //   ],),
        //         //
        //         //   pw.SizedBox(height: 8),
        //         //
        //         // ])
        //
        //
        //       pw.Text('Portable Document Format',
        //           style: pw.Theme.of(context)
        //               .defaultTextStyle
        //               .copyWith(color: PdfColors.grey))
            );
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} / ${context.pagesCount}',
                  // style: pw.Theme.of(context)
                  //     .defaultTextStyle
                  //     .copyWith(color: PdfColors.grey)
              )
          );
        },

        //0
        build: (context) =>
    [
      buildHeader(font1,_logo),
      //pw.Header(),
      buildInvoice(font1,purchaseModels ),
      pw.SizedBox(height: 12),
      buildFooter(font1),
      // pw.BarcodeWidget(
      //   data:  'Test QRcode',
      //   //purchaseModels[index].getIndex(2),
      //   width: 60,
      //   height: 60,
      //   barcode: pw.Barcode.qrCode(),
      //   drawText: false,
      // ),

    ]



    ));







    // try {
    //   await Printing.layoutPdf(
    //       onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
    //             format: format,
    //             html: '<html><body><p>Hello!</p></body></html>',
    //             //htmlString!,
    //           ));
    // } on Exception catch (e) {
    //   print('####error e >>>>${e.toString()}');
    //   // TODO
    // }
    return pdf.save();

  }

  // Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(

  //     pw.Page(

  //       orientation: pw.PageOrientation.landscape,

  //       pageFormat: format,
  //       build: (context) {
  //         return pw.Column(children: [

  //           pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //             pw.Expanded(
  //                 child: pw.Column(
  //               children: [
  //                 pw.Container(
  //                   height: 50,
  //                   padding: const pw.EdgeInsets.only(left: 20),
  //                   alignment: pw.Alignment.centerLeft,
  //                   child: pw.Text(
  //                     'INVOICE',
  //                     style: pw.TextStyle(
  //                       fontWeight: pw.FontWeight.bold,
  //                       fontSize: 40,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Container(
  //                   height: 80,
  //                   width: 400,
  //                   child: pw.BarcodeWidget(
  //                     barcode: pw.Barcode.qrCode(),
  //                     data: 'ANUSORN',
  //                     drawText: false,
  //                   ),
  //                 ),
  //               ],
  //             ))
  //           ])
  //         ]);
  //       },
  //     ),
  //   );
  //   // pdf.addPage(pw.Page(build: (context) => ,));
  //   //       return pw.Column(children: [
  //   //         pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //   //           pw.Expanded(
  //   //               child: pw.Column(
  //   //             children: [

  //   //               pw.Container(
  //   //                 height: 50,
  //   //                 padding: const pw.EdgeInsets.only(left: 20),
  //   //                 alignment: pw.Alignment.centerLeft,
  //   //                 child: pw.Text(
  //   //                   'INVOICE',
  //   //                   style: pw.TextStyle(

  //   //                     fontWeight: pw.FontWeight.bold,
  //   //                     fontSize: 40,
  //   //                   ),
  //   //                 ),
  //   //               ),

  //   //                 pw.Container(
  //   //       height: 80,
  //   //       width: 400,
  //   //       child: pw.BarcodeWidget(
  //   //         barcode: pw.Barcode.code128(),
  //   //         data: 'ANUSORN',
  //   //         drawText: false,
  //   //       ),
  //   //     ),

  //   //             ],
  //   //           ))
  //   //         ])
  //   //       ]);
  //   //     },
  //   //   ),
  //   // );

  //   return pdf.save();
  // }

  @override
  Widget build(BuildContext context) {
    // throw UnimplementedError();
     return Scaffold(
      appBar: AppBar(title: Text('พิมพ์ใบสั่งซื้อสินค้า'),
        backgroundColor: Colors.grey,
      ),

      body: PdfPreview(build: ((format) {
        return genPrint(format);
      }))
      // Padding(
      //   padding: const EdgeInsets.all(12.0),
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: GestureDetector(
      //       onTap: (){
      //         //genPrint();
      //       },
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: Colors.grey,
      //             borderRadius: BorderRadius.all(Radius.circular(10)),
      //
      //
      //
      //         ),
      //         width: 300,
      //         height: 60,
      //         child: Center(child: Text('แสดงรายการ',style: TextStyle(
      //           fontSize: 24
      //         ),)),),
      //     ),
      //   ),
      // ),

      // PdfPreview(
      //   build: (format) {
      //     return _generatePdf(format, 'Test');
      //     // genPrint();
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.print),
      //   tooltip: 'Print Document',
      //   onPressed: () {
      //     setState(() {
      //       genPrint();
      //     });
      //   },
      // ),
    );
  }

 pw.Widget buildHeader(ByteData font1, pw.MemoryImage logo) =>
     pw.Column(children: [


   pw.Row(children: [
     pw.Container(width: 36, height: 36,child: pw.Image(logo)),


     pw.Text(' บริษัท วาวา2559 จำกัด[สำนักงานใหญ่]', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 20,fontWeight: pw.FontWeight.bold), )

   ],),

   pw.Row(children: [
     pw.Text('244 หมู่ 15 ต.พันดอน อ.กุมภวาปี จ.อุดรธานี 41370', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), )

   ],),

   pw.Row(children: [
     pw.Text('โทร.042-331152', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), )

   ],),

   pw.SizedBox(height: 6),

   pw.Row(
     crossAxisAlignment: pw.CrossAxisAlignment.start,
     mainAxisAlignment: pw.MainAxisAlignment.end,
     children: [
      pw.SizedBox(width: 10),

     pw.Text('เลขที่เอกสาร: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,height: 1.2), ),


       pw.Text(' ${widget.document['docNo']}   ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),

     pw.Text('  วันที่: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,height: 2), ),

     pw.Text(' ${widget.document['docDate']}   ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),

   //
   //
   //
   //
   ],),

  // pw.SizedBox(height: 12),

   pw.Row(
     crossAxisAlignment: pw.CrossAxisAlignment.start,
     mainAxisAlignment: pw.MainAxisAlignment.end,
     children: [
      pw.SizedBox(width: 10),
     pw.Text('ลูกค้า: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),


     pw.Text(displayName, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),

     pw.Text('  รหัสสมาชิก SML : ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),

     pw.Text(employeeCode, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),

   ],),

   // pw.SizedBox(height: 12),

   pw.Row(
     crossAxisAlignment: pw.CrossAxisAlignment.start,
     mainAxisAlignment: pw.MainAxisAlignment.end,
     children: [
      pw.SizedBox(width: 10),
     pw.Text('ที่อยู่ในการจัดส่ง: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),


     pw.Text(addr, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),

     pw.Text('  เบอร์โทร: ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,), ),

     pw.Text(employeeTel, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 16,fontWeight: pw.FontWeight.bold), ),

   ],),

        pw.SizedBox(height: 8),

  ]);

 pw.Widget buildInvoice(ByteData font1, List<PurchaseModels> purchaseModels) {
   const tableHeaders = [
     'ลำดับ',
     'รายการสินค้า',
     //'รูปสินค้า',

     'จำนวน',
     'หน่วยนับ',

     'หน่วยละ',

     'จำนวนเงิน'

   ];

   //0
   return pw.Table.fromTextArray(
    // border: TableBorder(left: pw.BorderSide(width: 0.5), right:  pw.BorderSide(width: 0.5),top: pw.BorderSide(width: 0.5), bottom:  pw.BorderSide(width: 0.5)),
    //  border: null,
     cellAlignment: pw.Alignment.centerLeft,
     headerDecoration: const pw.BoxDecoration(
       // borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
       color: PdfColors.grey300,

         // border: pw.Border(
         //   top: pw.BorderSide(
         //     // color: accentColor,
         //     width: .5,
         //   ),
         //   bottom: pw.BorderSide(
         //     // color: accentColor,
         //     width: .5,
         //   ),
         //   right:   pw.BorderSide(
         //     // color: accentColor,
         //     width: .5,
         //   ),
         //   left:  pw.BorderSide(
         //     // color: accentColor,
         //     width: .5,
         //   ),
         // ),

     ),
     headerHeight: 40,
     cellHeight: 40,
     cellAlignments: {
       0: pw.Alignment.center,
       1: pw.Alignment.centerLeft,
       2: pw.Alignment.center,

       3: pw.Alignment.center,
       4: pw.Alignment.centerRight,
       5: pw.Alignment.centerRight,

     },
     headerStyle: pw.TextStyle(
       // color: _baseTextColor,
       font: pw.Font.ttf(font1),
       fontSize: 14,
       fontWeight: pw.FontWeight.bold,
     ),
     cellStyle:  pw.TextStyle(
       // color: _darkColor,
       font: pw.Font.ttf(font1),
       fontSize: 14,
     ),
     // cellDecoration: ,
     rowDecoration: const pw.BoxDecoration(
       // border: pw.Border(
       //   bottom: pw.BorderSide(
       //     // color: accentColor,
       //     width: .5,
       //   ),
       //   right:   pw.BorderSide(
       //   // color: accentColor,
       //   width: .5,
       // ),
       //   left:  pw.BorderSide(
       //   // color: accentColor,
       //   width: .5,
       // ),
       // ),
     ),
     headers: List<String>.generate(
       tableHeaders.length,
           (col) => tableHeaders[col],
     ),
     data:  List<List<dynamic>>.generate(
        purchaseModels.length,
         (index) => <dynamic> [
                 index+1,
         //  purchaseModels[index].getIndex(1),
           getImage(purchaseModels[index].getIndex(1),purchaseModels[index].getIndex(2)),

           // pw.BarcodeWidget(
           //   data:  'Test QRcode',
           //   //purchaseModels[index].getIndex(2),
           //   width: 60,
           //   height: 60,
           //   barcode: pw.Barcode.qrCode(),
           //   drawText: false,
           // ),

            purchaseModels[index].getIndex(3),
            purchaseModels[index].getIndex(4),
            //purchaseModels[index].getIndex(5),
           // purchaseModels[index].getIndex(6),
           myFormat.format(double.parse(purchaseModels[index].getIndex(5))),
           myFormat.format(double.parse(purchaseModels[index].getIndex(6))),

         ]

     ),
     //[


   //  ]
   //   List<List<String>>.generate(
   //     purchaseModels.length,
   //         (row) => List<String>.generate(
   //       tableHeaders.length,
   //           (col) => purchaseModels[row].getIndex(col),
   //     ),
   //   ),
   );
   //0

 }



  buildFooter(ByteData font1) {
   return pw.Container(
     alignment: pw.Alignment.centerRight,
     child: pw.Row(children: [

       pw.Text('จำนวนสินค้าทั้งหมด ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 14), ),
       pw.Text('${purchaseModels.length}', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 18,fontWeight: pw.FontWeight.bold), ),
       pw.Text(' รายการ ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 14), ),
       pw.Text(' รวมทั้งหมด ', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 14), ),
       pw.Text(totalTxt, style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 18,fontWeight: pw.FontWeight.bold), ),
       pw.Text(' บาท', style: pw.TextStyle(font: pw.Font.ttf(font1),fontSize: 14), ),

     ])

   );

  }

  getImage(String text1, String text2) async {
   final netImage = await networkImage(text2);

   return pw.Column(children: [
     pw.Text(text1),
   pw.Center(child:pw.Image(netImage,width: 60,height: 60) )
   ]);






  }






}
