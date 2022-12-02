import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:wawa/backend/admin/adminorder_search.dart';
//import 'package:wawa/backend/admin/adminmap.dart';
import 'package:wawa/backend/admin/printer.dart';
import 'package:wawa/backend/options.dart';
import 'package:wawa/backend/options_tel.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckFourPage extends StatefulWidget {
  @override
  _CheckFourPageState createState() => _CheckFourPageState();
}

class _CheckFourPageState extends State<CheckFourPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchtxt = TextEditingController();
  final dbRef = FirebaseFirestore.instance;
  double screen =0;
  List options = [];
  List<DocumentSnapshot> products = [];
  late Future<void> _launched;
  String _phone = '';
  String? status;
  bool chkone = true;
  bool chktwo = false;
  bool chkthree = false;
  bool chkfour = false;
  int dateNo = 2;
  num dateTimeNum =0;
  ScrollController scrollController = ScrollController();
  bool loading = true;

  Uint8List? bytes;
  String? _imageBase64;
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  // bool loading;
  void _onTop() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<Null> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  Future<void> openMap(double lat, double lng) async {
    String googleUrl = 'https://www.google.com/maps/search/?query=$lat,$lng';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'ไม่สามารถเปิดแผนที่ได้';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  Future getData() async{
    setState(() {
      products.clear();
    });
    final fifteenAgo = DateTime.now().subtract(Duration(days: dateNo));
    // "time": new DateTime.now().millisecondsSinceEpoch,
    num _dateTimeNum = fifteenAgo.microsecondsSinceEpoch;
    print('####dateNo>>>$dateNo, ###_dateTimeNum>>>$_dateTimeNum');
    //String _dateTime = fifteenAgo.toString().substring(0,10);
    setState(() {
      dateTimeNum = _dateTimeNum;
    });

     await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('Report')
            .where('status', isEqualTo: 'ลูกค้ารับสินค้าแล้ว')
           // .where('time', isGreaterThanOrEqualTo: dateTimeNum)
       // .orderBy('time', descending: true)
    .limit(100)
             .snapshots()
    .listen((event) {
       print('#####event.docs.length>>>${event.docs.length}');

     });



    // if(qsData.docs.length > 0){
    //   for (var item in qsData.docs){
    //     setState(() {
    //       products.add(item);
    //     });
    //   }
    //   print('####products>>>${products.length}');
    //
    // }



  }


  Widget getImageBase64(String img) {
    _imageBase64 = img;
    Base64Codec base64 = Base64Codec();
    if (_imageBase64 == null) return new Container();
    bytes = base64.decode(_imageBase64!);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ลายเซ็นผู้รับสินค้า',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
            ],),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(bytes!, width:300, fit: BoxFit.fitWidth)
            ],),
        )
      ],
    );
  }

  // void _onTop() {
  //   scrollController.animateTo(0,
  //       duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  // }


  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(title: Text(''),),
      body:  SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.pink,
                      size: 32,
                    ),
                    Text(
                      'รายการออร์เดอร์สินค้า',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Divider(),
              //      PaginateFirestore(
              //          itemBuilderType: PaginateBuilderType.listView, // listview and gridview
              //          itemBuilder: (index, context, documentSnapshot) => ListTile(
              //            leading: CircleAvatar(child: Icon(Icons.person)),
              //            title: Text(documentSnapshot.data()['docNo']),
              //            subtitle: Text(documentSnapshot.id),
              //          ),
              //          // orderBy is compulsary to enable pagination
              //         // query: Firestore.instance.collection('users').orderBy('name'),
              //              query: FirebaseFirestore.instance
              //                  .collection('wawastore')
              //                  .doc('wawastore')
              //                  .collection('Report')
              //                  .where('status', isEqualTo: 'ลูกค้ารับสินค้าแล้ว')
              //                  .orderBy('time', descending: true),
              //              isLive: true // to fetch real-time data
              //          ),
              //         isLive: true // to fetch real-time data
              //      )
              // chkfour == true ?
              //
              //  PaginateFirestore(
              //      itemBuilderType: PaginateBuilderType.listView, // listview and gridview
              //      itemBuilder: (index, context, documentSnapshot) {
              //        documentSnapshot.data()[index]['docNo'];


              // return ListView.builder(
              //   // scrollDirection: Axis.vertical,
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: documentSnapshot.data().length,
              //     itemBuilder: (context, index) {
              //       // Helper helper = new Helper();
              //
              //       // DateTime dateRecieve =
              //       //     new DateTime.fromMillisecondsSinceEpoch();
              //
              //       String _total = MyStyle()
              //           .myFormat
              //           .format(documentSnapshot.data()['totalValue']) ;
              //       // String _distance = querySnapshot.docs[index]['distance'].toString().length == 0  ? '0.0': MyStyle()
              //       //     .myFormat
              //       //     .format(querySnapshot.docs[index]['distance']);
              //
              //       return Padding(
              //         padding: const EdgeInsets.only(left: 10, right: 10),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             if (documentSnapshot.data()['displayName']
              //            )
              //               Wrap(
              //                 children: [
              //                   Text(
              //                     'ชื่อลูกค้า:${documentSnapshot.data()['displayName']}',
              //                     style: TextStyle(
              //                         fontSize: 24,
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.red[600]),
              //                   ),
              //                 ],
              //               )
              //             else
              //               Text(
              //                 'ชื่อลูกค้า: ...ไม่ระบุ......',
              //                 style: TextStyle(
              //                   fontSize: 24,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //
              //             Text(
              //               '${index + 1}. เลขที่เอกสาร:${documentSnapshot.data()['docNo']}',
              //               style: TextStyle(
              //                   fontSize: 24, fontWeight: FontWeight.bold),
              //             ),
              //             Text(
              //               'วันที่ออกใบเสนอราคา:${documentSnapshot.data()['docDate']}',
              //               style: TextStyle(
              //                   fontSize: 24, fontWeight: FontWeight.bold),
              //             ),
              //             Container(
              //               width: screen * 0.8,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 color: Colors.grey[200],
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: const Color(0x29000000),
              //                     offset: Offset(0, 3),
              //                     blurRadius: 6,
              //                   ),
              //                 ],
              //               ),
              //               child: Center(
              //                 child: Wrap(
              //                   children: [
              //                     Text(
              //                       'สถานะออร์เดอร์:',
              //                       style: TextStyle(
              //                         fontSize: 24,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                     Text(
              //                       '${documentSnapshot.data()['status']}',
              //                       style: TextStyle(
              //                           fontSize: 24,
              //                           color: documentSnapshot.data()
              //                           ['status'] ==
              //                               'ยืนยันคำสั่งซื้อ'
              //                               ? Colors.red
              //                               : documentSnapshot.data()
              //                           ['status'] ==
              //                               'กำลังเตรียมสินค้า'
              //                               ? Colors.orange[600]
              //                               : documentSnapshot.data()
              //                           ['status'] ==
              //                               'กำลังดำเนินการส่งสินค้า'
              //                               ? Colors.yellow[700]
              //                               : Colors.green[700],
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             if (documentSnapshot.data()
              //             ['signature'])
              //               getImageBase64(documentSnapshot.data()['signature'])
              //             else Container(),
              //             Row(
              //               children: [
              //                 Text(
              //                   'มูลค่าทั้งหมด:',
              //                   style: TextStyle(
              //                     fontSize: 24,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 Text(
              //                   '$_total',
              //                   style: TextStyle(
              //                       fontSize: 24,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.red[600]),
              //                 ),
              //               ],
              //             ),
              //             Row(
              //               children: [
              //                 Text(
              //                   'วันที่ต้องการรับสินค้า:',
              //                   style: TextStyle(
              //                     fontSize: 24,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 documentSnapshot.data()['dateRecieve']
              //                     .toString()
              //                     .isNotEmpty
              //                     ? Text(
              //                   '${documentSnapshot.data()['dateRecieve']}',
              //                   style: TextStyle(
              //                       fontSize: 24, color: Colors.red),
              //                 )
              //                     : Text(''),
              //               ],
              //             ),
              //             //         Row(
              //             //           children: [
              //             //             Text(
              //             //           'ระยะทาง:',
              //             //           style:
              //             //               TextStyle(fontSize: 24, ),
              //             //         ),
              //             //             Text(
              //             //               '$_distance กิโลเมตร',
              //             //               style:
              //             //                   TextStyle(fontSize: 24, color: Colors.red),
              //             //             ),
              //             //           ],
              //             //         ),
              //             documentSnapshot.data()['lat']
              //                 .toString()
              //                 .isNotEmpty
              //                 ? Text(
              //               'ละติจูด:${documentSnapshot.data()['lat']}',
              //               style: TextStyle(
              //                 fontSize: 24,
              //               ),
              //             )
              //                 : Text('ละติจูด:'),
              //
              //             documentSnapshot.data()['lng'] != null
              //                 ? Text(
              //               'ลองติจูด:${documentSnapshot.data()['lng']}',
              //               style: TextStyle(
              //                 fontSize: 24,
              //               ),
              //             )
              //                 : Text('ลองติจูด:'),
              //             //       //String === null
              //
              //             documentSnapshot.data()['telephone']
              //                 .toString()
              //                 .isNotEmpty
              //                 ? Text(
              //               'เบอร์โทร:${documentSnapshot.data()['telephone']}',
              //               style: TextStyle(
              //                 fontSize: 24,
              //               ),
              //             )
              //                 : Text('เบอร์โทร:'),
              //
              //             if (documentSnapshot.data()
              //             ['nodelivery'])
              //               ListTile(
              //                 leading: documentSnapshot.data()
              //                 ['nodelivery']
              //                     ? Icon(
              //                   Icons.check_box_outlined,
              //                   color: Colors.green[600],
              //                 )
              //                     : Icon(Icons.check_box_outline_blank),
              //                 title: Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน'),
              //               )
              //             else
              //               Container(),
              //
              //             if (documentSnapshot.data()
              //             ['delivery'])
              //               ListTile(
              //                 leading: documentSnapshot.data()['delivery']
              //                     ? Icon(
              //                   Icons.check_box_outlined,
              //                   color: Colors.green[600],
              //                 )
              //                     : Icon(Icons.check_box_outline_blank),
              //                 title: Text('ต้องการให้ทางร้านไปส่งสินค้า'),
              //               )
              //             else
              //               Container(),
              //
              //             if (documentSnapshot.data()
              //             ['note'])
              //               Wrap(
              //                 children: [
              //                   Text(
              //                     'ข้อความจากลูกค้า:${documentSnapshot.data()['note']}',
              //                     style: TextStyle(
              //                       fontSize: 24,
              //                     ),
              //                   ),
              //                 ],
              //               )
              //             else
              //               Text('ข้อความจากลูกค้า: ... ',
              //                   style: TextStyle(
              //                     fontSize: 24,
              //                   )),
              //
              //             Row(
              //               children: [
              //                 Text(
              //                   'สถานะการติดต่อลูกค้า:',
              //                   style: TextStyle(
              //                     fontSize: 24,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 Text(
              //                   '${documentSnapshot.data()['statusCustomer']}',
              //                   // statusCustomer
              //                   style: documentSnapshot.data()
              //                   ['statusCustomer'] ==
              //                       'รอโทรยืนยันคำสั่งซื้อ'
              //                       ? TextStyle(
              //                       fontSize: 24,
              //                       color: Colors.red[600],
              //                       fontWeight: FontWeight.bold)
              //                       : TextStyle(
              //                       fontSize: 24,
              //                       color: Colors.green[600],
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             ),
              //
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   width: screen * 0.4,
              //                   height: 40,
              //                   child: documentSnapshot.data()['lat']
              //                       .toString()
              //                       .isNotEmpty
              //                       ? RaisedButton.icon(
              //                       onPressed: () {
              //                         openMap(
              //                             documentSnapshot.data()
              //                             ['lat'],
              //                             documentSnapshot.data()
              //                             ['lng']);
              //                         // Navigator.push(
              //                         //     context,
              //                         //     MaterialPageRoute(
              //                         //       builder: (context) =>
              //                         //           AdminMap(
              //                         //               message: querySnapshot
              //                         //                       .documents[
              //                         //                   index]),
              //                         //     ));
              //                       },
              //                       icon: Icon(
              //                         Icons.place,
              //                         size: 20,
              //                       ),
              //                       label: Text(
              //                         'แสดงในแผนที่',
              //                         style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold),
              //                       ))
              //                       : RaisedButton.icon(
              //                       onPressed: () {
              //                         // openMap(
              //                         //     querySnapshot.docs[index]['lat'],
              //                         //     querySnapshot.docs[index]['lng']);
              //                         // Navigator.push(
              //                         //     context,
              //                         //     MaterialPageRoute(
              //                         //       builder: (context) =>
              //                         //           AdminMap(
              //                         //               message: querySnapshot
              //                         //                       .documents[
              //                         //                   index]),
              //                         //     ));
              //                       },
              //                       icon: Icon(
              //                         Icons.place,
              //                         size: 20,
              //                       ),
              //                       label: Text(
              //                         'แสดงในแผนที่',
              //                         style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold),
              //                       )),
              //                 ),
              //                 SizedBox(
              //                   width: 5,
              //                 ),
              //                 Container(
              //                   width: screen * 0.4,
              //                   height: 40,
              //                   child: RaisedButton.icon(
              //                       onPressed: () {
              //                         Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                                 builder: (context) =>
              //                                     PrintPage(
              //                                       document: documentSnapshot, //?????
              //                                     )));
              //                       },
              //                       icon: Icon(
              //                         Icons.print,
              //                         size: 20,
              //                       ),
              //                       label: Text(
              //                         'พิมพ์ใบเสนอราคา',
              //                         style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold),
              //                       )),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 15,
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   width: screen * 0.4,
              //                   height: 40,
              //                   child: RaisedButton.icon(
              //                       onPressed: () {
              //                         Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                               builder: (context) =>
              //                                   OptionsPage(
              //                                       document: documentSnapshot ///????
              //                                   )));
              //                         //  querySnapshot.documents[index]['status']
              //                         // changeStatus(
              //                         //     querySnapshot.documents[index]);
              //                       },
              //                       icon: Icon(
              //                         Icons.local_shipping,
              //                         size: 20,
              //                       ),
              //                       label: Text(
              //                         'สถานะOrder',
              //                         style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold),
              //                       )),
              //                 ),
              //                 SizedBox(
              //                   width: 5,
              //                 ),
              //                 if (documentSnapshot.data()
              //                 ['telephone'])
              //                   Container(
              //                       width: screen * 0.4,
              //                       height: 40,
              //                       child: RaisedButton.icon(
              //                         onPressed: () {
              //                           _makePhoneCall(
              //                               'tel:${documentSnapshot.data()['telephone']}');
              //                         },
              //                         icon: Icon(
              //                           Icons.call,
              //                           size: 20,
              //                         ),
              //                         label: Text(
              //                           'โทรหาลูกค้า',
              //                           style: TextStyle(
              //                               fontSize: 20,
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                       ))
              //                 else
              //                   Container(),
              //               ],
              //             ),
              //
              //             SizedBox(
              //               height: 15,
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   width: screen * 0.6,
              //                   height: 40,
              //                   child: RaisedButton.icon(
              //                       onPressed: () {
              //                         Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                               builder: (context) =>
              //                                   OptionsTelPage(
              //                                       document: documentSnapshot),///?????
              //                             ));
              //                       },
              //                       icon: Icon(
              //                         Icons.call_end,
              //                         size: 20,
              //                       ),
              //                       label: Text(
              //                         'สถานะการโทรหาลูกค้า',
              //                         style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold),
              //                       )),
              //                 ),
              //               ],
              //             ),
              //
              //             Divider(),
              //           ],
              //         ),
              //       );
              //     });


              //  },
              // =>
              //     ListTile(
              //   leading: CircleAvatar(child: Icon(Icons.person)),
              //   title: Text(documentSnapshot.data()['name']),
              //   subtitle: Text(documentSnapshot.documentID),
              // ),
              // orderBy is compulsary to enable pagination
              //     query: FirebaseFirestore.instance
              //         .collection('wawastore')
              //         .doc('wawastore')
              //         .collection('Report')
              //         .where('status', isEqualTo: status)
              //         .orderBy('time', descending: true),
              //     isLive: true // to fetch real-time data
              // )
              //     :


              // StreamBuilder<QuerySnapshot>(
              //     stream: dbRef
              //         .collection('wawastore')
              //         .doc('wawastore')
              //         .collection('Report')
              //         .where('status', isEqualTo: 'ลูกค้ารับสินค้าแล้ว')
              //         .where('time', isGreaterThanOrEqualTo: dateTimeNum)
              //     //.orderBy('time', descending: true)
              //         .snapshots(),
              //     builder: (context, snapshot) {
              //       print('####snapshot_length>>${snapshot.data.docs.length}');
              //       //loading = false;
              //       if (snapshot.data == null) //.data ถ้ามากกว่านี้ไม่ทำงานจ้า
              //         return MyStyle().showProgress();
              //
              //       if (snapshot.data.docs.length == 0)
              //         return Center(child: Text('ไม่พบรายการในสถานะนี้ครับ'));
              //
              //       //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       }
              //
              //       if (snapshot.hasError) {
              //         return Center(child: Text(snapshot.error.toString()));
              //       }
              //
              //       // QuerySnapshot<Object?>? querySnapshot = snapshot.data;
              //       QuerySnapshot querySnapshot = snapshot.data;
              //
              //       return ListView.builder(
              //         // scrollDirection: Axis.vertical,
              //           physics: NeverScrollableScrollPhysics(),
              //           shrinkWrap: true,
              //           itemCount: querySnapshot.docs.length,
              //           itemBuilder: (context, index) {
              //             // Helper helper = new Helper();
              //
              //             // DateTime dateRecieve =
              //             //     new DateTime.fromMillisecondsSinceEpoch();
              //
              //             String _total = MyStyle()
              //                 .myFormat
              //                 .format(querySnapshot.docs[index]['totalValue']);
              //             // String _distance = querySnapshot.docs[index]['distance'].toString().length == 0  ? '0.0': MyStyle()
              //             //     .myFormat
              //             //     .format(querySnapshot.docs[index]['distance']);
              //
              //             return Container();
              //             //   Padding(
              //             //   padding: const EdgeInsets.only(left: 10, right: 10),
              //             //   child: Column(
              //             //     mainAxisAlignment: MainAxisAlignment.start,
              //             //     crossAxisAlignment: CrossAxisAlignment.start,
              //             //     children: [
              //             //       if (querySnapshot.docs[index]
              //             //       ['displayName'] != null)
              //             //         Wrap(
              //             //           children: [
              //             //             Text(
              //             //               'ชื่อลูกค้า:${querySnapshot.docs[index]['displayName']}',
              //             //               style: TextStyle(
              //             //                   fontSize: 24,
              //             //                   fontWeight: FontWeight.bold,
              //             //                   color: Colors.red[600]),
              //             //             ),
              //             //           ],
              //             //         )
              //             //       else
              //             //         Text(
              //             //           'ชื่อลูกค้า: ...ไม่ระบุ......',
              //             //           style: TextStyle(
              //             //             fontSize: 24,
              //             //             fontWeight: FontWeight.bold,
              //             //           ),
              //             //         ),
              //             //
              //             //       Text(
              //             //         '${index + 1}. เลขที่เอกสาร:${querySnapshot.docs[index]['docNo']}',
              //             //         style: TextStyle(
              //             //             fontSize: 24, fontWeight: FontWeight.bold),
              //             //       ),
              //             //       Text(
              //             //         'วันที่ออกใบเสนอราคา:${querySnapshot.docs[index]['docDate']}',
              //             //         style: TextStyle(
              //             //             fontSize: 24, fontWeight: FontWeight.bold),
              //             //       ),
              //             //       Container(
              //             //         width: screen * 0.8,
              //             //         height: 40,
              //             //         decoration: BoxDecoration(
              //             //           color: Colors.grey[200],
              //             //           boxShadow: [
              //             //             BoxShadow(
              //             //               color: const Color(0x29000000),
              //             //               offset: Offset(0, 3),
              //             //               blurRadius: 6,
              //             //             ),
              //             //           ],
              //             //         ),
              //             //         child: Center(
              //             //           child: Wrap(
              //             //             children: [
              //             //               Text(
              //             //                 'สถานะออร์เดอร์:',
              //             //                 style: TextStyle(
              //             //                   fontSize: 24,
              //             //                   fontWeight: FontWeight.bold,
              //             //                 ),
              //             //               ),
              //             //               Text(
              //             //                 '${querySnapshot.docs[index]['status']}',
              //             //                 style: TextStyle(
              //             //                     fontSize: 24,
              //             //                     color: querySnapshot.docs[index]
              //             //                     ['status'] ==
              //             //                         'ยืนยันคำสั่งซื้อ'
              //             //                         ? Colors.red
              //             //                         : querySnapshot.docs[index]
              //             //                     ['status'] ==
              //             //                         'กำลังเตรียมสินค้า'
              //             //                         ? Colors.orange[600]
              //             //                         : querySnapshot.docs[index]
              //             //                     ['status'] ==
              //             //                         'กำลังดำเนินการส่งสินค้า'
              //             //                         ? Colors.yellow[700]
              //             //                         : Colors.green[700],
              //             //                     fontWeight: FontWeight.bold),
              //             //               ),
              //             //             ],
              //             //           ),
              //             //         ),
              //             //       ),
              //             //       if (querySnapshot.docs[index].data().containsKey('signature')
              //             //       )
              //             //         getImageBase64(querySnapshot.docs[index]['signature'])
              //             //       else Container(), //worked
              //             //       Row(
              //             //         children: [
              //             //           Text(
              //             //             'มูลค่าทั้งหมด:',
              //             //             style: TextStyle(
              //             //               fontSize: 24,
              //             //               fontWeight: FontWeight.bold,
              //             //             ),
              //             //           ),
              //             //           Text(
              //             //             '$_total',
              //             //             style: TextStyle(
              //             //                 fontSize: 24,
              //             //                 fontWeight: FontWeight.bold,
              //             //                 color: Colors.red[600]),
              //             //           ),
              //             //         ],
              //             //       ),
              //             //       Row(
              //             //         children: [
              //             //           Text(
              //             //             'วันที่ต้องการรับสินค้า:',
              //             //             style: TextStyle(
              //             //               fontSize: 24,
              //             //               fontWeight: FontWeight.bold,
              //             //             ),
              //             //           ),
              //             //           querySnapshot.docs[index]['dateRecieve']
              //             //               .toString()
              //             //               .isNotEmpty
              //             //               ? Text(
              //             //             '${querySnapshot.docs[index]['dateRecieve']}',
              //             //             style: TextStyle(
              //             //                 fontSize: 24, color: Colors.red),
              //             //           )
              //             //               : Text(''),
              //             //         ],
              //             //       ),
              //             //       // //         Row(
              //             //       // //           children: [
              //             //       // //             Text(
              //             //       // //           'ระยะทาง:',
              //             //       // //           style:
              //             //       // //               TextStyle(fontSize: 24, ),
              //             //       // //         ),
              //             //       // //             Text(
              //             //       // //               '$_distance กิโลเมตร',
              //             //       // //               style:
              //             //       // //                   TextStyle(fontSize: 24, color: Colors.red),
              //             //       // //             ),
              //             //       // //           ],
              //             //       // //         ),
              //             //       querySnapshot.docs[index]['lat']
              //             //           .toString()
              //             //           .isNotEmpty
              //             //           ? Text(
              //             //         'ละติจูด:${querySnapshot.docs[index]['lat']}',
              //             //         style: TextStyle(
              //             //           fontSize: 24,
              //             //         ),
              //             //       )
              //             //           : Text('ละติจูด:'),
              //             //       //
              //             //       querySnapshot.docs[index]['lng'] != null
              //             //           ? Text(
              //             //         'ลองติจูด:${querySnapshot.docs[index]['lng']}',
              //             //         style: TextStyle(
              //             //           fontSize: 24,
              //             //         ),
              //             //       )
              //             //           : Text('ลองติจูด:'),
              //             //       // //       //String === null
              //             //       //
              //             //       querySnapshot.docs[index]['telephone']
              //             //           .toString()
              //             //           .isNotEmpty
              //             //           ? Text(
              //             //         'เบอร์โทร:${querySnapshot.docs[index]['telephone']}',
              //             //         style: TextStyle(
              //             //           fontSize: 24,
              //             //         ),
              //             //       )
              //             //           : Text('เบอร์โทร:'),
              //             //       //
              //             //       if (querySnapshot.docs[index]
              //             //       ['nodelivery'])
              //             //         ListTile(
              //             //           leading: querySnapshot.docs[index]
              //             //           ['nodelivery']
              //             //               ? Icon(
              //             //             Icons.check_box_outlined,
              //             //             color: Colors.green[600],
              //             //           )
              //             //               : Icon(Icons.check_box_outline_blank),
              //             //           title: Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน'),
              //             //         )
              //             //       else
              //             //         Container(),
              //             //       //
              //             //       if (querySnapshot.docs[index]
              //             //       ['delivery'])
              //             //         ListTile(
              //             //           leading: querySnapshot.docs[index]['delivery']
              //             //               ? Icon(
              //             //             Icons.check_box_outlined,
              //             //             color: Colors.green[600],
              //             //           )
              //             //               : Icon(Icons.check_box_outline_blank),
              //             //           title: Text('ต้องการให้ทางร้านไปส่งสินค้า'),
              //             //         )
              //             //       else
              //             //         Container(),
              //             //       //
              //             //       if (querySnapshot.docs[index].data().containsKey('note')
              //             //       )
              //             //         Wrap(
              //             //           children: [
              //             //             Text(
              //             //               'ข้อความจากลูกค้า:${querySnapshot.docs[index]['note']}',
              //             //               style: TextStyle(
              //             //                 fontSize: 24,
              //             //               ),
              //             //             ),
              //             //           ],
              //             //         )
              //             //       else
              //             //         Text('ข้อความจากลูกค้า: ... ',
              //             //             style: TextStyle(
              //             //               fontSize: 24,
              //             //             )),
              //             //       //
              //             //       Row(
              //             //         children: [
              //             //           Text(
              //             //             'สถานะการติดต่อลูกค้า:',
              //             //             style: TextStyle(
              //             //               fontSize: 24,
              //             //               fontWeight: FontWeight.bold,
              //             //             ),
              //             //           ),
              //             //           Text(
              //             //             '${querySnapshot.docs[index]['statusCustomer']}',
              //             //             // statusCustomer
              //             //             style: querySnapshot.docs[index]
              //             //             ['statusCustomer'] ==
              //             //                 'รอโทรยืนยันคำสั่งซื้อ'
              //             //                 ? TextStyle(
              //             //                 fontSize: 24,
              //             //                 color: Colors.red[600],
              //             //                 fontWeight: FontWeight.bold)
              //             //                 : TextStyle(
              //             //                 fontSize: 24,
              //             //                 color: Colors.green[600],
              //             //                 fontWeight: FontWeight.bold),
              //             //           ),
              //             //         ],
              //             //       ),
              //             //
              //             //       Row(
              //             //         mainAxisAlignment: MainAxisAlignment.center,
              //             //         children: [
              //             //           Container(
              //             //             width: screen * 0.4,
              //             //             height: 40,
              //             //             child: querySnapshot.docs[index]['lat']
              //             //                 .toString()
              //             //                 .isNotEmpty
              //             //                 ? RaisedButton.icon(
              //             //                 onPressed: () {
              //             //                   openMap(
              //             //                       querySnapshot.docs[index]
              //             //                       ['lat'],
              //             //                       querySnapshot.docs[index]
              //             //                       ['lng']);
              //             //                   // Navigator.push(
              //             //                   //     context,
              //             //                   //     MaterialPageRoute(
              //             //                   //       builder: (context) =>
              //             //                   //           AdminMap(
              //             //                   //               message: querySnapshot
              //             //                   //                       .documents[
              //             //                   //                   index]),
              //             //                   //     ));
              //             //                 },
              //             //                 icon: Icon(
              //             //                   Icons.place,
              //             //                   size: 20,
              //             //                 ),
              //             //                 label: Text(
              //             //                   'แสดงในแผนที่',
              //             //                   style: TextStyle(
              //             //                       fontSize: 20,
              //             //                       fontWeight: FontWeight.bold),
              //             //                 ))
              //             //                 : RaisedButton.icon(
              //             //                 onPressed: () {
              //             //                   // openMap(
              //             //                   //     querySnapshot.docs[index]['lat'],
              //             //                   //     querySnapshot.docs[index]['lng']);
              //             //                   // Navigator.push(
              //             //                   //     context,
              //             //                   //     MaterialPageRoute(
              //             //                   //       builder: (context) =>
              //             //                   //           AdminMap(
              //             //                   //               message: querySnapshot
              //             //                   //                       .documents[
              //             //                   //                   index]),
              //             //                   //     ));
              //             //                 },
              //             //                 icon: Icon(
              //             //                   Icons.place,
              //             //                   size: 20,
              //             //                 ),
              //             //                 label: Text(
              //             //                   'แสดงในแผนที่',
              //             //                   style: TextStyle(
              //             //                       fontSize: 20,
              //             //                       fontWeight: FontWeight.bold),
              //             //                 )),
              //             //           ),
              //             //           SizedBox(
              //             //             width: 5,
              //             //           ),
              //             //           Container(
              //             //             width: screen * 0.4,
              //             //             height: 40,
              //             //             child: RaisedButton.icon(
              //             //                 onPressed: () {
              //             //                   Navigator.push(
              //             //                       context,
              //             //                       MaterialPageRoute(
              //             //                           builder: (context) =>
              //             //                               PrintPage(
              //             //                                 document: querySnapshot
              //             //                                     .docs[index],
              //             //                               )));
              //             //                 },
              //             //                 icon: Icon(
              //             //                   Icons.print,
              //             //                   size: 20,
              //             //                 ),
              //             //                 label: Text(
              //             //                   'พิมพ์ใบเสนอราคา',
              //             //                   style: TextStyle(
              //             //                       fontSize: 20,
              //             //                       fontWeight: FontWeight.bold),
              //             //                 )),
              //             //           ),
              //             //         ],
              //             //       ),
              //             //       SizedBox(
              //             //         height: 15,
              //             //       ),
              //             //       Row(
              //             //         mainAxisAlignment: MainAxisAlignment.center,
              //             //         children: [
              //             //           Container(
              //             //             width: screen * 0.4,
              //             //             height: 40,
              //             //             child: RaisedButton.icon(
              //             //                 onPressed: () {
              //             //                   Navigator.push(
              //             //                       context,
              //             //                       MaterialPageRoute(
              //             //                         builder: (context) =>
              //             //                             OptionsPage(
              //             //                                 document: querySnapshot
              //             //                                     .docs[index]),
              //             //                       ));
              //             //                   //  querySnapshot.documents[index]['status']
              //             //                   // changeStatus(
              //             //                   //     querySnapshot.documents[index]);
              //             //                 },
              //             //                 icon: Icon(
              //             //                   Icons.local_shipping,
              //             //                   size: 20,
              //             //                 ),
              //             //                 label: Text(
              //             //                   'สถานะOrder',
              //             //                   style: TextStyle(
              //             //                       fontSize: 20,
              //             //                       fontWeight: FontWeight.bold),
              //             //                 )),
              //             //           ),
              //             //           SizedBox(
              //             //             width: 5,
              //             //           ),
              //             //           if (querySnapshot.docs[index].data().containsKey('telephone')
              //             //           )
              //             //             Container(
              //             //                 width: screen * 0.4,
              //             //                 height: 40,
              //             //                 child: RaisedButton.icon(
              //             //                   onPressed: () {
              //             //                     _makePhoneCall(
              //             //                         'tel:${querySnapshot.docs[index]['telephone']}');
              //             //                   },
              //             //                   icon: Icon(
              //             //                     Icons.call,
              //             //                     size: 20,
              //             //                   ),
              //             //                   label: Text(
              //             //                     'โทรหาลูกค้า',
              //             //                     style: TextStyle(
              //             //                         fontSize: 20,
              //             //                         fontWeight: FontWeight.bold),
              //             //                   ),
              //             //                 ))
              //             //           else
              //             //             Container(),
              //             //         ],
              //             //       ),
              //             //
              //             //       SizedBox(
              //             //         height: 15,
              //             //       ),
              //             //       Row(
              //             //         mainAxisAlignment: MainAxisAlignment.center,
              //             //         children: [
              //             //           Container(
              //             //             width: screen * 0.6,
              //             //             height: 40,
              //             //             child: RaisedButton.icon(
              //             //                 onPressed: () {
              //             //                   Navigator.push(
              //             //                       context,
              //             //                       MaterialPageRoute(
              //             //                         builder: (context) =>
              //             //                             OptionsTelPage(
              //             //                                 document: querySnapshot
              //             //                                     .docs[index]),
              //             //                       ));
              //             //                 },
              //             //                 icon: Icon(
              //             //                   Icons.call_end,
              //             //                   size: 20,
              //             //                 ),
              //             //                 label: Text(
              //             //                   'สถานะการโทรหาลูกค้า',
              //             //                   style: TextStyle(
              //             //                       fontSize: 20,
              //             //                       fontWeight: FontWeight.bold),
              //             //                 )),
              //             //           ),
              //             //         ],
              //             //       ),
              //             //
              //             //       Divider(),
              //             //     ],
              //             //   ),
              //             // );
              //           });
              //     })



            ],
          ),
        ),
      ),
    );


  }

// Future<Null> changeStatus(DocumentSnapshot document) async {
//   switch (document[]) {
//     case :

//       break;
//     default:
//   }

//  return showDialog(
//     context: context,
//     builder: (context) => SimpleDialog(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'สถานะสินค้า',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           )
//         ],
//       ),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [Text('docNo: ${document['docNo']}')],
//         ),
//         ListTile(
//           leading: Icon(Icons.check_box_outline_blank),
//           title: Text('ยืนยันการสั่งซื้อ'),
//         ),
//         ListTile(
//           leading: Icon(Icons.check_box),
//           title: Text('กำลังเตรียมสินค้า'),
//         ),
//         ListTile(
//           leading: Icon(Icons.check_box_outline_blank),
//           title: Text('อยู่ระหว่างจัดส่ง'),
//         ),
//         ListTile(
//           leading: Icon(Icons.check_box_outline_blank),
//           title: Text('ลูกค้ารับสินค้า'),
//         )
//       ],
//     ),
//   );
// }
}
