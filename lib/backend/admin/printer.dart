import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawa/api/page/pdf_page.dart';
import 'package:wawa/backend/admin/print_detail.dart';
import 'package:wawa/backend/admin/print_intro.dart';
import 'package:wawa/backend/admin/printpdftest.dart';
import 'package:wawa/models/purchase_models.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:http/http.dart' as http;


class PrintPage extends StatefulWidget {
  final DocumentSnapshot document;
  PrintPage({required this.document});
  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  double screen = 0;
  double screenH = 0;

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
  num total = 0;
  String totalTxt = '0.0';
  String? htmlString;
  final dbRef = FirebaseFirestore.instance;
  Helper helper = new Helper();
  String nameSale = '';
  var myFormat = NumberFormat('#,##0.0', 'en_US');
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery
        .of(context)
        .size
        .width;
    screenH = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('พิมพ์ใบเสนอราคา'),
      ),
      body: loading ? const Center(child: CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.green,))  : Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screen * 0.4,
                height: screenH * 0.08,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PrintIntoPage(document: widget.document)
                          ));
                      //  querySnapshot.documents[index]['status']
                      // changeStatus(
                      //     querySnapshot.documents[index]);
                    },
                    icon: const Icon(
                      Icons.print,
                      size: 20,
                    ),
                    label: const FittedBox(
                      // fit: BoxFit.fitWidth,
                      child: Text(
                        'ใบปะหน้า / ใบนำส่งสินค้า',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
              // _telephoneBool ?
              //              Container(
              //                  width: screen * 0.4,
              //                  height: 40,
              //                  child: ElevatedButton.icon(
              //                    onPressed: () {
              //                      _makePhoneCall(
              //                          'tel:${querySnapshot.docs[index]['telephone']}');
              //                    },
              //                    icon: Icon(
              //                      Icons.call,
              //                      size: 20,
              //                    ),
              //                    label: Text(
              //                      'โทรหาลูกค้า',
              //                      style: TextStyle(
              //                          fontSize: 20,
              //                          fontWeight: FontWeight.bold),
              //                    ),
              //                  ))
              // :
              //    Container()
              //  ,
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: screen*0.3,
          //       height: 60.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Colors.grey[400],
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Color(0x29000000),
          //             offset: Offset(0, 3),
          //             blurRadius: 6,
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: GestureDetector(
          //           onTap: () {
          //             Navigator.of(context)
          //                 .push(MaterialPageRoute(builder: (context) => PrintIntoPage(document: widget.document), ));
          //           },
          //           child: const Text(
          //             'ใบปะหน้า / ใบนำส่งสินค้า',
          //             style: TextStyle(
          //               // fontFamily: 'Sukhumvit Set',
          //               fontSize: 20,
          //               // color: const Color(0xffc41f70),
          //               fontWeight: FontWeight.w700,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 30,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: screen*0.3,
          //       height: 60.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Colors.grey[400],
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Color(0x29000000),
          //             offset: Offset(0, 3),
          //             blurRadius: 6,
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: GestureDetector(
          //           onTap: () {
          //              Navigator.of(context)
          //                 .push(MaterialPageRoute(builder: (context) =>
          //                 PrintDetailPage(document: widget.document),
          //              //  PdfPage()
          //              ));
          //
          //           },
          //           child: const Text(
          //             'ใบสั่งซื้อสินค้า',
          //             style: TextStyle(
          //               // fontFamily: 'Sukhumvit Set',
          //               fontSize: 20,
          //               // color: const Color(0xffc41f70),
          //               fontWeight: FontWeight.w700,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SizedBox(
          //       width: screen * 0.4,
          //       height: screenH * 0.08,
          //       child: ElevatedButton.icon(
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) =>
          //                       PrintDetailPage(document: widget.document),
          //                 ));
          //             //  querySnapshot.documents[index]['status']
          //             // changeStatus(
          //             //     querySnapshot.documents[index]);
          //           },
          //           icon: const Icon(
          //             Icons.print,
          //             size: 20,
          //           ),
          //           label: const FittedBox(
          //             // fit: BoxFit.fitWidth,
          //             child: Text(
          //               'ใบสั่งซื้อสินค้า',
          //               style: TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           )),
          //     ),
          //     const SizedBox(
          //       width: 5,
          //     ),
          //     // _telephoneBool ?
          //     //              Container(
          //     //                  width: screen * 0.4,
          //     //                  height: 40,
          //     //                  child: ElevatedButton.icon(
          //     //                    onPressed: () {
          //     //                      _makePhoneCall(
          //     //                          'tel:${querySnapshot.docs[index]['telephone']}');
          //     //                    },
          //     //                    icon: Icon(
          //     //                      Icons.call,
          //     //                      size: 20,
          //     //                    ),
          //     //                    label: Text(
          //     //                      'โทรหาลูกค้า',
          //     //                      style: TextStyle(
          //     //                          fontSize: 20,
          //     //                          fontWeight: FontWeight.bold),
          //     //                    ),
          //     //                  ))
          //     // :
          //     //    Container()
          //     //  ,
          //   ],
          // ),
          //
          // const SizedBox(
          //   height: 30,
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screen * 0.4,
                height: screenH * 0.08,
                child: ElevatedButton.icon(
                    onPressed: () {
                      // saveApi(htmlString);
                      // String _id = widget.document['docNo'];
                      // String _true = 'true';
                      final Uri _url = Uri.parse(
                          'http://119.59.114.170:8081/pdf/${widget.document['docNo']}');//http://164.115.23.107
                      try {
                        launchUrl(_url);
                      } on Exception catch (e) {
                        // TODO
                      }
                    },
                    icon: const Icon(
                      Icons.print,
                      size: 20,
                    ),
                    label: const FittedBox(
                      // fit: BoxFit.fitWidth,
                      child: Text(
                        'ใบสั่งซื้อสินค้า',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
              // _telephoneBool ?
              //              Container(
              //                  width: screen * 0.4,
              //                  height: 40,
              //                  child: ElevatedButton.icon(
              //                    onPressed: () {
              //                      _makePhoneCall(
              //                          'tel:${querySnapshot.docs[index]['telephone']}');
              //                    },
              //                    icon: Icon(
              //                      Icons.call,
              //                      size: 20,
              //                    ),
              //                    label: Text(
              //                      'โทรหาลูกค้า',
              //                      style: TextStyle(
              //                          fontSize: 20,
              //                          fontWeight: FontWeight.bold),
              //                    ),
              //                  ))
              // :
              //    Container()
              //  ,
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: 200.0,
          //       height: 50.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Colors.grey[400],
          //         boxShadow: [
          //           BoxShadow(
          //             color: const Color(0x29000000),
          //             offset: Offset(0, 3),
          //             blurRadius: 6,
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: GestureDetector(
          //           onTap: () {
          //             // Navigator.of(context)
          //             //     .push(MaterialPageRoute(builder: (context) => PrintPdfTest(), ));
          //
          //           },
          //           child: Text(
          //             'ทดสอบระบบ Pdf',
          //             style: TextStyle(
          //               // fontFamily: 'Sukhumvit Set',
          //               fontSize: 20,
          //               // color: const Color(0xffc41f70),
          //               fontWeight: FontWeight.w700,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    setState(() {
      nameSale =
      '${widget.document['codeSale']} (${widget.document['nameSale']})';

      _uid = widget.document['uid'];
    });

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



          // String _result = item['subtotal'].substring(0, item['subtotal'].indexOf(','));

          print('####item[\'subtotal\'] === ${item['subtotal']}');
          List<String> xdata = item['subtotal'].split(',') ;
          String _result =  item['subtotal'].replaceAll(RegExp(","), '');
          // if (xdata.isNotEmpty) {
          //
          //   // String _searchTxt =  searchText.replaceAll(RegExp(r"\s+"), ' ');
          //
          // }
          print('####_result === $_result');


          double _total = double.parse(_result);

          total = total + _total;
          // print('####total>>>$total');

          String _two = """

          <tr>
            <td>$_index </td>
            <td> ${item['name']} <br><img src=${item['picturl']}  width=\"120\" height=\"80\"> </td>
            <td> ${item['amounts']}</td>
            <td>${item['unit']}</td>
             <td>${item['price']}</td>
               <td>${MyStyle().myFormat.format(double.parse(_result))}</td>

          </tr>




                    """;
          htmltwo.add(_two);

          _index++;
        }
      }


      setState(() {
        totalTxt = MyStyle().myFormat.format(total); //????
      });


      String _one = """
          
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
  }
          table {
            -fs-table-paginate: paginate;
        }
  th{
    padding: 5px;
    text-align: center;
  }
     td{
    padding: 5px;
    text-align: center;
    vertical-align:middle;
  }

 
.right {
  position: absolute;
  right: 0px;
  
  
  padding: 10px;
}




  </style>
  
 

</head>
  <body>
             

  

    <h2><img src="https://firebasestorage.googleapis.com/v0/b/wawastore-96761.appspot.com/o/images%2Fimage2.jpg?alt=media&token=79de5a01-a212-4aa4-83eb-92871eb113a1"  width=\"40\" height=\"40\"> บริษัท วาวา2559 จำกัด[สำนักงานใหญ่]</h2>
    <p>244 หมู่ 15 ต.พันดอน อ.กุมภวาปี จ.อุดรธานี 41370 <br>
    โทร.042-331152<br>
    หมายเลขประจำตัวผู้เสียภาษี 0415562000535</p>
   


   <p> เลขที่เอกสาร:<b>${widget.document['docNo']}</b> วันที่: <b>${widget
          .document['docDate']}</b>
    ลูกค้า: $displayName รหัสสมาชิก SML : <b>$employeeCode</b>
    ที่อยู่ในการจัดส่ง: <b>$addr</b> เบอร์โทร: <b>$employeeTel</b>

    รหัสผู้ขาย: $nameSale</p>



    <table style="width:100%">






       <thead>
      <tr>
        <th style="width:10% ">ลำดับ</th>
        <th style="width:40% ">รูปสินค้า</th>
        <th style="width:10% ">จำนวน</th>
        <th style="width:10% ">หน่วยนับ</th>
        <th style="width:10% ">หน่วยละ</th>
        <th style="width:20% ">จำนวนเงิน</th>
      </tr>
       </thead>


""";

      String _three = """

                   </table>



                  """;

   String?   _htmlString = """

      $_one
        $htmltwo
       $_three
       <p class="right">รวมทั้งหมด: <b>$totalTxt</b> บาท</p>


  </body></html>

  


        


      """;

     setState(() {
       htmlString = _htmlString;
       loading = false;
     });
      //saveApi( htmlString);
      saveData();
    });
  }

  Future<void> _launchUrl(String _url) async {

    await launchUrl(Uri.parse(_url));
        // ,mode: LaunchMode.externalApplication);
  }

  Future<void> saveApi(String? htmlStr) async {
    setState(() {
      loading = true;
    });

    try {
      var response = await Dio().get('http://164.115.23.107:8081/pdf/${widget.document['docNo']}');
      print('####Start>>>');
      print(response);
      print('####<<<End...');
    } catch (e) {
      print(e);
    }

    setState(() {
      loading = false;
    });
    //     Map<String, String> headers = Map();
    // headers['Content-Type'] =
    // 'application/json';
    // 'application/x-www-form-urlencoded';
    // headers['provider'] = 'DATA';
    // headers['databasename'] = 'wawa2';

    // String _model = jsonEncode(models);

    // var body = {
    //   "data" :
    //  htmlString
    //  //  "test jaa"
    //
    // };



    // Dio dio = Dio();
    // String pathAPI = 'http://164.115.23.107:8081/pdf';
    // var url = Uri.parse(pathAPI);
    // var response = await http.post(url,headers: headers, body: jsonEncode(body));
    // print('####Response status: ${response.statusCode}');
    // print('####Response body: ${response.}');
    // print('####Start');
    // print(jsonEncode(body));
    // print('####End');
    //
    //    setState(() {
    //      loading = false; // บนลงล่าง*
    //    });


   //   var dio = Dio();
   //   var response = await dio.post('http://164.115.23.107:8081/pdf',
   //      options: Options(headers: headers)
   // // //      //'http://103.129.13.114:8080/wawa_api/postinsertPdf.php',options: Options(headers: headers
   // // //
   // // //  // )
   // //
   //     , data: {
   //
   //       'data' : htmlString  //html
   //     }).then((value) {
   //       print('####value>>>${value.statusCode}');
   //        print('####value>>>${value.data}');
   //
   // //      , data: {
   // //   "docno" : widget.document['docNo'],
   // //       'dataStr' : htmlString
   // //     }).then((value) {
   // //    print('####response/statusCode>>>${value.statusCode}');
   // //    //goto url
   // //    String _id = widget.document['docNo'];
   // //    String _url = 'http://164.115.23.107:8080/mpdf/showPdf.php?docno=$_id&isAdd=true';
   //    // มันต้องแปลงเป็น pdf ไม่ได้แปลงตรงๆ กำจริงกู
   //    // final Uri _url = Uri.parse(
   //    //     'http://103.129.13.114:8080/wawa_api/showPdf.php?id=$_id');
   //    // try {
   //    //   _launchUrl(_url);
       //} on Exception catch (e) {
       //  // TODO
      // }

     // });
     //    setState(() {
     //      loading = false;
     //    });


    //**ตามลำดับ บนล่าง




  }

  Future<void> saveData() async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    // headers['provider'] = 'DATA';
    // headers['databasename'] = 'wawa2';
    Response response;
    var dio = Dio();
    response = await dio.post('http://119.59.114.170:8081/create',options: Options(headers: headers
//http://119.59.114.170:80/
    //http://164.115.23.107:8081/create
    ), data: {
      'docno' : widget.document['docNo'],
      'dataStr' : htmlString
    });

    print('####response>>>>$response');

    setState(() {
      loading = false;
    });
  }
}
