// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:wawa/backend/admin/printer.dart';
// import 'package:wawa/backend/options.dart';
// import 'package:wawa/utility/debouncer.dart';
// import 'package:wawa/utility/my_style.dart';

// class ManageUserPage extends StatefulWidget {
//   @override
//   _ManageUserPageState createState() => _ManageUserPageState();
// }

// class _ManageUserPageState extends State<ManageUserPage> {
//   //final debouncer = Debouncer(milliseconds: 1000);
//   final dbRef = FirebaseFirestore.instance;
//   double screen;
//   String searchtxt;
//    final _formKey = GlobalKey<FormState>();
//   TextEditingController searchCtrl = TextEditingController();

//   Future<Null> _makePhoneCall(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     searchtxt = '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     screen = MediaQuery.of(context).size.width;
//     return Scaffold(appBar: AppBar(title: Text('ค้นหาเลขที่เอกสาร'),),
//       body: Form(key: _formKey,
//               child: SingleChildScrollView(
//           child: Column(
//             children: [
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
                
//                   Container(
                    
//                     width: screen * 0.8,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: TextField(
//                         controller: searchCtrl,
//                          decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.search,size: 36,),
//                     labelText: 'ระบุเลขที่เอกสาร docNo',
//                     // helperText: '',
//                     fillColor: Colors.grey[200],
//                     filled: true,),
//                         style: TextStyle(
                          
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//              // backgroundColor: Colors.orange[200]
//               ),
//                         onChanged: (text) {
//             // print('value==>>$text');
//             setState(() {
//               searchtxt = text;
//             });
                         
//                         },
//                       ),
//                     ),
//                   ),
              
              
//                   IconButton(
//                     icon: Icon(
//                       Icons.clear,
//                       size: 36,
//                       color: Colors.red[600],
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         searchCtrl.clear();
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                 ],
//               ),

          
    
//               SizedBox(height: 40,),
//               StreamBuilder<QuerySnapshot>(
//                   stream: dbRef
//                       .collection('wawastore')
//                       .doc('wawastore')
//                       .collection('Report')
//                       // .where('docNo', isGreaterThanOrEqualTo: searchtxt)
//                       .where('docNo',isGreaterThanOrEqualTo: searchtxt)
//                       .orderBy('docNo',descending: false)
                     
//                        //.where('docNo',isLessThanOrEqualTo: searchtxt+'\uf8ff')
                      
                      
//                       // WAWA2021-03-31-0062
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     //loading = false;
//                     if (snapshot.data == null) //.data ถ้ามากกว่านี้ไม่ทำงานจ้า
//                       return MyStyle().showProgress();

//                     if (snapshot.data.docs.length == 0)
//                       return Center(child: Text('ไม่พบรายการในสถานะนี้ครับ'));

//                     //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }

//                     if (snapshot.hasError) {
//                       return Center(child: Text(snapshot.error.toString()));
//                     }

//                     QuerySnapshot querySnapshot = snapshot.data;

//                     return ListView.builder(
//                         // scrollDirection: Axis.vertical,
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: querySnapshot.docs.length,
//                         itemBuilder: (context, index) {
//                           // Helper helper = new Helper();

//                           // DateTime dateRecieve =
//                           //     new DateTime.fromMillisecondsSinceEpoch();

//                           String _total = MyStyle()
//                               .myFormat
//                               .format(querySnapshot.docs[index]['totalValue']);
//                           String _distance = MyStyle()
//                               .myFormat
//                               .format(querySnapshot.docs[index]['distance']);

//                           return Padding(
//                             padding: const EdgeInsets.only(left: 10, right: 10),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${index + 1}. เลขที่เอกสาร:${querySnapshot.docs[index]['docNo']}',
//                                   style: TextStyle(
//                                       fontSize: 24, fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   'วันที่ออกใบเสนอราคา:${querySnapshot.docs[index]['docDate']}',
//                                   style: TextStyle(
//                                       fontSize: 24, fontWeight: FontWeight.bold),
//                                 ),
//                                 Container(
//                                    width: screen * 0.8,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0x29000000),
//                             offset: Offset(0, 3),
//                             blurRadius: 6,
//                           ),
//                         ],),
//                                   child: Text(
//                                     'สถานะออร์เดอร์:${querySnapshot.docs[index]['status']}',
//                                     style: TextStyle(
//                                         fontSize: 24,
//                                        color:
//                                           querySnapshot.docs[index]['status'] =='ยืนยันคำสั่งซื้อ'?Colors.red :
//                                           querySnapshot.docs[index]['status'] =='กำลังเตรียมสินค้า'? Colors.orange[600]:
//                                           querySnapshot.docs[index]['status'] =='กำลังดำเนินการส่งสินค้า'? Colors.yellow[700]:
//                                            Colors.green[700],
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 Text(
//                                   'มูลค่าทั้งหมด:$_total',
//                                   style: TextStyle(
//                                       fontSize: 24, fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   'วันที่ต้องการรับสินค้า:${querySnapshot.docs[index]['dateRecieve']}',
//                                   style:
//                                       TextStyle(fontSize: 24, color: Colors.red),
//                                 ),
//                                 Text(
//                                   'ระยะทาง:$_distance' 'กิโลเมตร',
//                                   style:
//                                       TextStyle(fontSize: 24, color: Colors.red),
//                                 ),
//                                 Text(
//                                   'ละติจูด:${querySnapshot.docs[index]['lat']}',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 Text(
//                                   'ลองติจูด:${querySnapshot.docs[index]['lng']}',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 Text(
//                                   'เบอร์โทร:${querySnapshot.docs[index]['telephone']}',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 Text(
//                                   'สถานะการติดต่อลูกค้า:${querySnapshot.docs[index]['statusCustomer']}',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: screen * 0.4,
//                                       height: 40,
//                                       child: RaisedButton.icon(
//                                           onPressed: () {
//                                             openMap(
//                                                 querySnapshot.docs[index]['lat'],
//                                                 querySnapshot.docs[index]['lng']);
//                                             // Navigator.push(
//                                             //     context,
//                                             //     MaterialPageRoute(
//                                             //       builder: (context) =>
//                                             //           AdminMap(
//                                             //               message: querySnapshot
//                                             //                       .documents[
//                                             //                   index]),
//                                             //     ));
//                                           },
//                                           icon: Icon(
//                                             Icons.place,
//                                             size: 20,
//                                           ),
//                                           label: Text(
//                                             'แสดงในแผนที่',
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Container(
//                                       width: screen * 0.4,
//                                       height: 40,
//                                       child: RaisedButton.icon(
//                                           onPressed: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         PrintPage(
//                                                           document: querySnapshot
//                                                               .docs[index],
//                                                         )));
//                                           },
//                                           icon: Icon(
//                                             Icons.print,
//                                             size: 20,
//                                           ),
//                                           label: Text(
//                                             'พิมพ์ใบเสนอราคา',
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: screen * 0.4,
//                                       height: 40,
//                                       child: RaisedButton.icon(
//                                           onPressed: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       OptionsPage(
//                                                           document: querySnapshot
//                                                               .docs[index]),
//                                                 ));
//                                             //  querySnapshot.documents[index]['status']
//                                             // changeStatus(
//                                             //     querySnapshot.documents[index]);
//                                           },
//                                           icon: Icon(
//                                             Icons.local_shipping,
//                                             size: 20,
//                                           ),
//                                           label: Text(
//                                             'สถานะOrder',
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Container(
//                                       width: screen * 0.4,
//                                       height: 40,
//                                       child: RaisedButton.icon(
//                                           onPressed: () {
//                                             _makePhoneCall(
//                                                 'tel:${querySnapshot.docs[index]['telephone']}');
//                                           },
//                                           icon: Icon(
//                                             Icons.call,
//                                             size: 20,
//                                           ),
//                                           label: Text(
//                                             'โทรหาลูกค้า',
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(),
//                               ],
//                             ),
//                           );
//                         });
//                   }),
//                   ],
//         ),
//       ),
//     ),);
//   }

//   Future<void> openMap(double lat, double lng) async {
//     String googleUrl =
//         'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
//     if (await canLaunch(googleUrl)) {
//       await launch(googleUrl);
//     } else {
//       throw 'ไม่สามารถเปิดแผนที่ได้';
//     }
//   }
//   //เหลืองปิดทั้งหมด/  ชมพู่ ปิดแท้ก
// }
