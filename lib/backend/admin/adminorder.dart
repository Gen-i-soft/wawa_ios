import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:wawa/backend/admin/printer.dart';
import 'package:wawa/backend/options.dart';
import 'package:wawa/backend/options_tel.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchtxt = TextEditingController();
  final dbRef = FirebaseFirestore.instance;
  double screen = 0;
  List options = [];
  late Future<void> _launched;
  String _phone = '';
  String status = 'ยืนยันคำสั่งซื้อ';
  bool chkone = true;
  bool chktwo = false;
  bool chkthree = false;
  bool chkfour = false;
  bool loading = true;
  int noDoc = 100;

  Uint8List? bytes;
  String? _imageBase64;
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  // bool loading;

  // Future<void> _makePhoneCall(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void initStart() {
  //
  // }

  Future<void> openMap(double lat, double lng) async {
    String googleUrl = 'https://www.google.com/maps/search/?query=$lat,$lng';
    if (await canLaunch(googleUrl)) {
      try {
        await launch(googleUrl);
      } on Exception catch (e) {
        // TODO
        print('#####e.error>>>${e.toString()}');
      }
    } else {
      throw 'ไม่สามารถเปิดแผนที่ได้';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initStart();
  //  status = 'ยืนยันคำสั่งซื้อ';
    // loading = true;
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

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
           // mainAxisAlignment: MainAxisAlignment.center,
           //  crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
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
              Column(
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => AdminOrderSearch(),
                  //     ));
                  //   },
                  //   child: Container(
                  //       width: 200,
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey[200],
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: const Color(0x29000000),
                  //             offset: Offset(0, 3),
                  //             blurRadius: 6,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           children: [
                  //             Icon(Icons.search),
                  //             Text(
                  //               'ค้นหาจากเลขที่เอกสาร',
                  //               style: TextStyle(
                  //                   fontSize: 20, fontWeight: FontWeight.bold),
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //       // TextFormField(
                  //       //   controller: searchtxt,
                  //       //   decoration: InputDecoration(
                  //       //     prefixIcon: Icon(Icons.search),
                  //       //     labelText: 'ค้นหาเลขที่เอกสาร',
                  //       //   ),
                  //       // )
                  //       ),
                  // ),
                  ListTile(
                    leading: chkone
                        ? Icon(
                            Icons.check_box_outlined,
                            color: Colors.green[600],
                          )
                        :  const Icon(Icons.check_box_outline_blank),
                    title: const Text('ยืนยันคำสั่งซื้อ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      setState(() {
                        chkone = !chkone;
                      });
                      if (chkone == true) {
                        setState(() {
                          status = 'ยืนยันคำสั่งซื้อ';
                          chktwo = false;
                          chkthree = false;
                          chkfour = false;
                        });
                      } else {
                        setState(() {
                          //  status = 'ยืนยันคำสั่งซื้อ';
                          //   //chkone = false;
                          //   chktwo = false;
                          //   chkthree = false;
                          //   chkfour = false;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: chktwo
                        ? Icon(
                            Icons.check_box_outlined,
                            color: Colors.green[600],
                          )
                        : const Icon(Icons.check_box_outline_blank),
                    title: Text('กำลังเตรียมสินค้า',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.brown[600],
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      setState(() {
                        chktwo = !chktwo;
                      });
                      if (chktwo == true) {
                        setState(() {
                          status = 'กำลังเตรียมสินค้า';
                          chkone = false;
                          chkthree = false;
                          chkfour = false;
                        });
                      } else {
                        setState(() {
                          //  chkone = false;
                          // chktwo = false;
                          //   chkthree = false;
                          //   chkfour = false;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: chkthree
                        ? Icon(
                            Icons.check_box_outlined,
                            color: Colors.green[600],
                          )
                        : const Icon(Icons.check_box_outline_blank),
                    title: Text('กำลังดำเนินการส่งสินค้า',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.yellow[700],
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      setState(() {
                        chkthree = !chkthree;
                      });
                      if (chkthree == true) {
                        setState(() {
                          status = 'กำลังดำเนินการส่งสินค้า';
                          chkone = false;
                          chktwo = false;
                          chkfour = false;
                        });
                      } else {
                        // chkone = false;
                        // chktwo = false;
                        // chkfour = false;
                      }
                    },
                  ),
                  ListTile(
                    leading: chkfour
                        ? Icon(
                            Icons.check_box_outlined,
                            color: Colors.green[600],
                          )
                        : const Icon(Icons.check_box_outline_blank),
                    title: const Text('ลูกค้ารับสินค้าแล้ว',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      setState(() {
                        chkfour = !chkfour;
                      });
                      if (chkfour == true) {
                        setState(() {
                          status = 'ลูกค้ารับสินค้าแล้ว';
                          chktwo = false;
                          chkthree = false;
                          chkone = false;
                          loading = false;
                        });
                     //  Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminOrderFinished()));
                      //
                      //
                      } else {}
                      //Navigator to new page***
                    },
                  ),
                ],
              ),
              const Divider(),
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
                //                       ? ElevatedButton.icon(
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
                //                       : ElevatedButton.icon(
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
                //                   child: ElevatedButton.icon(
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
                //                   child: ElevatedButton.icon(
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
                //                       child: ElevatedButton.icon(
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
                //                   child: ElevatedButton.icon(
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
//loading ?
              chkfour == true ? StreamBuilder<QuerySnapshot>(
    stream: dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('Report')
          .where('status', isEqualTo: status)
          .orderBy('time', descending: true)
       .limit(noDoc)
          .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

      if (snapshot.hasError) {
          return const Text('');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
          return  Text("กำลังโหลดข้อมูล...",   style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red[400]),);
      }

      // if (snapshot.data == null) {
      //   return Center(child: CircularProgressIndicator());
      // }

      // if (snapshot.data!.docs.length == 0)
      //   return Center(child: Text('จำนวน 0 รายการ'));

      //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
      // if (snapshot.connectionState == ConnectionState.waiting) {
      //   return Center(child: CircularProgressIndicator());
      // }

      // if (snapshot.hasError) {
      //   return Center(child: Text(snapshot.error.toString()));
      // }

      // QuerySnapshot<Object?>? querySnapshot = snapshot.data;
      // QuerySnapshot<Object?>? querySnapshot = snapshot.data;

      return ListView.builder(
          // scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Helper helper = new Helper();

              // DateTime dateRecieve =
              //     new DateTime.fromMillisecondsSinceEpoch();

              String _total = MyStyle()
                  .myFormat
                  .format(snapshot.data!.docs[index]['totalValue']);
              // String _distance = querySnapshot.docs[index]['distance'].toString().length == 0  ? '0.0': MyStyle()
              //     .myFormat
              //     .format(querySnapshot.docs[index]['distance']);
            // String _signature =   snapshot.data!.docs[index]['signature'] ?? 'xxx';
            // // print('####_signature>>>>$_signature');
            // bool _signatureBool = false;
            // if (_signature != 'xxx' ) {
            //   setState(() {
            //     _signatureBool = true;
            //   });
            // //
            // }

           // String _note =   querySnapshot.docs[index]['note'] ?? 'xxx';
           //    bool _noteBool = false;
           //    if (_note != 'xxx' ) {
           //      setState(() {
           //        _noteBool = true;
           //      });
           //
           //    }

            // String _telephone =   querySnapshot.docs[index]['telephone'] ?? 'xxx';
            //   bool _telephoneBool = false;
            //   if (_telephone != 'xxx' ) {
            //     setState(() {
            //       _telephoneBool = true;
            //     });
            //
            //   }

              return Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (snapshot.data!.docs[index]
                  ['displayName'] != null)
                    Wrap(
                      children: [
                        Text(
                          'ชื่อลูกค้า:${snapshot.data!.docs[index]['displayName']}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[600]),
                        ),
                      ],
                    )
                  else
                    const Text(
                      'ชื่อลูกค้า: ...ไม่ระบุ......',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  Text(
                    '${index + 1}. เลขที่เอกสาร:${snapshot.data!.docs[index]['docNo']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'วันที่ออกใบเสนอราคา:${snapshot.data!.docs[index]['docDate']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: screen * 0.4,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Wrap(
                        children: [
                          const Text(
                            'สถานะออร์เดอร์:',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${snapshot.data!.docs[index]['status']}',
                            style: TextStyle(
                                fontSize: 24,
                                color: snapshot.data!.docs[index]
                                ['status'] ==
                                    'ยืนยันคำสั่งซื้อ'
                                    ? Colors.red
                                    : snapshot.data!.docs[index]
                                ['status'] ==
                                    'กำลังเตรียมสินค้า'
                                    ? Colors.orange[600]
                                    : snapshot.data!.docs[index]
                                ['status'] ==
                                    'กำลังดำเนินการส่งสินค้า'
                                    ? Colors.yellow[700]
                                    : Colors.green[700],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                //  if (querySnapshot.docs[index].data().toString().contains('signature')
                  //querySnapshot.docs[index].data().containsKey('signature')
              // factory User.fromDocument(DocumentSnapshot doc) {
              // return User(
              // id: doc.data().toString().contains('id') ? doc.get('id') : '', //String
              // amount: doc.data().toString().contains('amount') ? doc.get('amount') : 0,//Number
              // enable: doc.data().toString().contains('enable') ? doc.get('enable') : false,//Boolean
              // tags: doc.data().toString().contains('tags') ? doc.get('tags').entries.map((e) => TagModel(name: e.key, value: e.value)).toList() : [],//List<dynamic>
              // );
              // }
                 // )
              // _signatureBool ?    getImageBase64(snapshot.data!.docs[index]['signature'])
              //      : Container(), //worked
                  Row(
                    children: [
                      const Text(
                        'มูลค่าทั้งหมด:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _total,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'วันที่ต้องการรับสินค้า:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      snapshot.data!.docs[index]['dateRecieve']
                          .toString()
                          .isNotEmpty
                          ? Text(
                        '${snapshot.data!.docs[index]['dateRecieve']}',
                        style: const TextStyle(
                            fontSize: 24, color: Colors.red),
                      )
                          : const Text(''),
                    ],
                  ),
                  // //         Row(
                  // //           children: [
                  // //             Text(
                  // //           'ระยะทาง:',
                  // //           style:
                  // //               TextStyle(fontSize: 24, ),
                  // //         ),
                  // //             Text(
                  // //               '$_distance กิโลเมตร',
                  // //               style:
                  // //                   TextStyle(fontSize: 24, color: Colors.red),
                  // //             ),
                  // //           ],
                  // //         ),
                  snapshot.data!.docs[index]['lat']
                      .toString()
                      .isNotEmpty
                      ? Text(
                    'ละติจูด:${snapshot.data!.docs[index]['lat']}',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  )
                      : const Text('ละติจูด:'),
                  //
                  snapshot.data!.docs[index]['lng'] != null
                      ? Text(
                    'ลองติจูด:${snapshot.data!.docs[index]['lng']}',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  )
                      : const Text('ลองติจูด:'),
                  // //       //String === null
                  //
                  snapshot.data!.docs[index]['telephone']
                      .toString()
                      .isNotEmpty
                      ? Text(
                    'เบอร์โทร:${snapshot.data!.docs[index]['telephone']}',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  )
                      : const Text('เบอร์โทร:'),
                  //
                  if (snapshot.data!.docs[index]
                  ['nodelivery'])
                    ListTile(
                      leading: snapshot.data!.docs[index]
                      ['nodelivery']
                          ? Icon(
                        Icons.check_box_outlined,
                        color: Colors.green[600],
                      )
                          : const Icon(Icons.check_box_outline_blank),
                      title: const Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน'),
                    )
                  else
                    Container(),
                  //
                  if (snapshot.data!.docs[index]
                  ['delivery'])
                    ListTile(
                      leading: snapshot.data!.docs[index]['delivery']
                          ? Icon(
                        Icons.check_box_outlined,
                        color: Colors.green[600],
                      )
                          : const Icon(Icons.check_box_outline_blank),
                      title: const Text('ต้องการให้ทางร้านไปส่งสินค้า'),
                    )
                  else
                    Container(),
                  //
                 // _noteBool ?
                    Wrap(
                      children: [
                        Text(
                          'ข้อความจากลูกค้า:${snapshot.data!.docs[index]['note']}',
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                 // :
                 //    Text('ข้อความจากลูกค้า: ... ',
                 //        style: TextStyle(
                 //          fontSize: 24,
                 //        )),
                  //
                  Row(
                    children: [
                      const Text(
                        'สถานะการติดต่อลูกค้า:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${snapshot.data!.docs[index]['statusCustomer']}',
                        // statusCustomer
                        style: snapshot.data!.docs[index]
                        ['statusCustomer'] ==
                            'รอโทรยืนยันคำสั่งซื้อ'
                            ? TextStyle(
                            fontSize: 24,
                            color: Colors.red[600],
                            fontWeight: FontWeight.bold)
                            : TextStyle(
                            fontSize: 24,
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  //                  //  _signatureBool  ?
//                 chkfour ?    getImageBase64(querySnapshot.docs[index]['signature'])
//                   : Container(),

                  Row(
                   // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: screen * 0.4,
                      //   height: 40,
                      //   child: querySnapshot.docs[index]['lat']
                      //       .toString()
                      //       .isNotEmpty
                      //       ? ElevatedButton.icon(
                      //       onPressed: () {
                      //         openMap(
                      //             querySnapshot.docs[index]
                      //             ['lat'],
                      //             querySnapshot.docs[index]
                      //             ['lng']);
                      //         // Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //       builder: (context) =>
                      //         //           AdminMap(
                      //         //               message: querySnapshot
                      //         //                       .documents[
                      //         //                   index]),
                      //         //     ));
                      //       },
                      //       icon: Icon(
                      //         Icons.place,
                      //         size: 20,
                      //       ),
                      //       label: Text(
                      //         'แสดงในแผนที่',
                      //         style: TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold),
                      //       ))
                      //       : ElevatedButton.icon(
                      //       onPressed: () {
                      //         // openMap(
                      //         //     querySnapshot.docs[index]['lat'],
                      //         //     querySnapshot.docs[index]['lng']);
                      //         // Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //       builder: (context) =>
                      //         //           AdminMap(
                      //         //               message: querySnapshot
                      //         //                       .documents[
                      //         //                   index]),
                      //         //     ));
                      //       },
                      //       icon: Icon(
                      //         Icons.place,
                      //         size: 20,
                      //       ),
                      //       label: Text(
                      //         'แสดงในแผนที่',
                      //         style: TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold),
                      //       )),
                      // ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width < 1200 ?  MediaQuery.of(context).size.width < 660 ? screen * 0.8 : screen * 0.5 : screen * 0.25 ,
                        height: 60,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.grey.shade600,
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),

                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PrintPage(
                                            document: snapshot.data!
                                                .docs[index],
                                          )));
                            },
                            icon: const Icon(
                              Icons.print,
                              size: 20,
                            ),
                            label: const Text(
                              'พิมพ์ใบเสนอราคา***',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screen * 0.4,
                        height: 60,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OptionsPage(
                                            document: snapshot.data!
                                                .docs[index]),
                                  ));
                              //  querySnapshot.documents[index]['status']
                              // changeStatus(
                              //     querySnapshot.documents[index]);
                            },
                            icon: const Icon(
                              Icons.local_shipping,
                              size: 20,
                            ),
                            label: const Text(
                              'แก้ไข/เปลี่ยนสถานะOrder',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
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

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screen * 0.4,
                        height: 60,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OptionsTelPage(
                                            document: snapshot.data!
                                                .docs[index]),
                                  ));
                            },
                            icon: const Icon(
                              Icons.call_end,
                              size: 20,
                            ),
                            label: const Text(
                              'แก้ไข/เปลี่ยนสถานะการโทรหาลูกค้า',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),

                  const Divider(),
                ],
              );
            });
    })

    : StreamBuilder<QuerySnapshot>(
                  stream: dbRef
                      .collection('wawastore')
                      .doc('wawastore')
                      .collection('Report')
                      .where('status', isEqualTo: status)
                      .orderBy('time', descending: true)
                  // .limit(noDoc)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return const Text('');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Text("กำลังโหลดข้อมูล...",   style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[400]),);
                    }

                    // if (snapshot.data == null) {
                    //   return Center(child: CircularProgressIndicator());
                    // }

                    // if (snapshot.data!.docs.length == 0)
                    //   return Center(child: Text('จำนวน 0 รายการ'));

                    //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return Center(child: CircularProgressIndicator());
                    // }

                    // if (snapshot.hasError) {
                    //   return Center(child: Text(snapshot.error.toString()));
                    // }

                    // QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                    // QuerySnapshot<Object?>? querySnapshot = snapshot.data;

                    return ListView.builder(
                      // scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // Helper helper = new Helper();

                          // DateTime dateRecieve =
                          //     new DateTime.fromMillisecondsSinceEpoch();

                          String _total = MyStyle()
                              .myFormat
                              .format(snapshot.data!.docs[index]['totalValue']);
                          // String _distance = querySnapshot.docs[index]['distance'].toString().length == 0  ? '0.0': MyStyle()
                          //     .myFormat
                          //     .format(querySnapshot.docs[index]['distance']);
                          // String _signature =   querySnapshot.docs[index]['signature'] ?? 'xxx';
                          // print('####_signature>>>>$_signature');
                          // bool _signatureBool = false;
                          // if (_signature != 'xxx' ) {
                          //   setState(() {
                          //     _signatureBool = true;
                          //   });
                          //
                          // }

                          // String _note =   querySnapshot.docs[index]['note'] ?? 'xxx';
                          //    bool _noteBool = false;
                          //    if (_note != 'xxx' ) {
                          //      setState(() {
                          //        _noteBool = true;
                          //      });
                          //
                          //    }

                          // String _telephone =   querySnapshot.docs[index]['telephone'] ?? 'xxx';
                          //   bool _telephoneBool = false;
                          //   if (_telephone != 'xxx' ) {
                          //     setState(() {
                          //       _telephoneBool = true;
                          //     });
                          //
                          //   }

                          return Center(
                            child: Container(
                              color: (index %2 == 0)? Colors.green.shade100 : Colors.grey.shade100 ,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (snapshot.data!.docs[index]
                                  ['displayName'] != null)
                                    Wrap(
                                      children: [
                                        Text(
                                          'ชื่อลูกค้า:${snapshot.data!.docs[index]['displayName']}',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[600]),
                                        ),
                                      ],
                                    )
                                  else
                                    const Text(
                                      'ชื่อลูกค้า: ...ไม่ระบุ......',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  Text(
                                    '${index + 1}. เลขที่เอกสาร:${snapshot.data!.docs[index]['docNo']}',
                                    style: const TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'วันที่ออกใบเสนอราคา:${snapshot.data!.docs[index]['docDate']}',
                                    style: const TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width < 1200 ?  MediaQuery.of(context).size.width < 660 ? screen * 0.8 : screen * 0.3 : screen * 0.25 ,
                                    height: 60,
                                    decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x29000000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Wrap(
                                        children: [
                                          const Text(
                                            'สถานะออเดอร์:',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data!.docs[index]['status']}',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: snapshot.data!.docs[index]
                                                ['status'] ==
                                                    'ยืนยันคำสั่งซื้อ'
                                                    ? Colors.red
                                                    : snapshot.data!.docs[index]
                                                ['status'] ==
                                                    'กำลังเตรียมสินค้า'
                                                    ? Colors.orange[600]
                                                    : snapshot.data!.docs[index]
                                                ['status'] ==
                                                    'กำลังดำเนินการส่งสินค้า'
                                                    ? Colors.yellow[700]
                                                    : Colors.green[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //  if (querySnapshot.docs[index].data().toString().contains('signature')
                                  //querySnapshot.docs[index].data().containsKey('signature')
                                  // factory User.fromDocument(DocumentSnapshot doc) {
                                  // return User(
                                  // id: doc.data().toString().contains('id') ? doc.get('id') : '', //String
                                  // amount: doc.data().toString().contains('amount') ? doc.get('amount') : 0,//Number
                                  // enable: doc.data().toString().contains('enable') ? doc.get('enable') : false,//Boolean
                                  // tags: doc.data().toString().contains('tags') ? doc.get('tags').entries.map((e) => TagModel(name: e.key, value: e.value)).toList() : [],//List<dynamic>
                                  // );
                                  // }
                                  // )
                                  // _signatureBool ?    getImageBase64(querySnapshot.docs[index]['signature'])
                                  //      : Container(), //worked
                                  Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'มูลค่าทั้งหมด:',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _total,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[600]),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'วันที่ต้องการรับสินค้า:',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      snapshot.data!.docs[index]['dateRecieve']
                                          .toString()
                                          .isNotEmpty
                                          ? Text(
                                        '${snapshot.data!.docs[index]['dateRecieve']}',
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.red),
                                      )
                                          : const Text(''),
                                    ],
                                  ),
                                  // //         Row(
                                  // //           children: [
                                  // //             Text(
                                  // //           'ระยะทาง:',
                                  // //           style:
                                  // //               TextStyle(fontSize: 24, ),
                                  // //         ),
                                  // //             Text(
                                  // //               '$_distance กิโลเมตร',
                                  // //               style:
                                  // //                   TextStyle(fontSize: 24, color: Colors.red),
                                  // //             ),
                                  // //           ],
                                  // //         ),
                                  snapshot.data!.docs[index]['lat']
                                      .toString()
                                      .isNotEmpty
                                      ? Text(
                                    'ละติจูด:${snapshot.data!.docs[index]['lat']}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  )
                                      : const Text('ละติจูด:'),
                                  //
                                  snapshot.data!.docs[index]['lng'] != null
                                      ? Text(
                                    'ลองติจูด:${snapshot.data!.docs[index]['lng']}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  )
                                      : const Text('ลองติจูด:'),
                                  // //       //String === null
                                  //
                                  snapshot.data!.docs[index]['telephone']
                                      .toString()
                                      .isNotEmpty
                                      ? Text(
                                    'เบอร์โทร:${snapshot.data!.docs[index]['telephone']}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  )
                                      : const Text('เบอร์โทร:'),
                                  //
                                  if (snapshot.data!.docs[index]
                                  ['nodelivery'])
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        snapshot.data!.docs[index]['nodelivery'] ?
                                        Icon(
                                          Icons.check_box_outlined,
                                          color: Colors.green[600],
                                        )
                                            : const Icon(Icons.check_box_outline_blank),
                                        const Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.green
                                        ),)

                                      ],
                                    )
                                    // ListTile(
                                    //   leading: snapshot.data!.docs[index]
                                    //   ['nodelivery']
                                    //       ?
                                      // Icon(
                                      //   Icons.check_box_outlined,
                                      //   color: Colors.green[600],
                                      // )
                                      //     : const Icon(Icons.check_box_outline_blank),
                                      // title: Center(child: const Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน')),
                                    // )
                                    //     Row(
                                    //
                                    //     )
                                  else
                                    Container(),
                                  //
                                  if (snapshot.data!.docs[index]
                                  ['delivery'])
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        snapshot.data!.docs[index]['delivery'] ?
                                        Icon(
                                          Icons.check_box_outlined,
                                          color: Colors.red[600],
                                        )
                                            : const Icon(Icons.check_box_outline_blank),
                                        const Text('ต้องการให้ทางร้านไปส่งสินค้า', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          color: Colors.red
                                        ),)

                                      ],
                                    ),
                                  //   ListTile(
                                  //     leading: snapshot.data!.docs[index]['delivery']
                                  //         ? Icon(
                                  //       Icons.check_box_outlined,
                                  //       color: Colors.green[600],
                                  //     )
                                  //         : const Icon(Icons.check_box_outline_blank),
                                  //     title: Center(child: const Text('ต้องการให้ทางร้านไปส่งสินค้า')),
                                  //   )
                                  // else
                                  //   Container(),
                                  //
                                  // _noteBool ?
                                  Wrap(
                                    children: [
                                      Text(
                                        'ข้อความจากลูกค้า:${snapshot.data!.docs[index]['note']}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // :
                                  //    Text('ข้อความจากลูกค้า: ... ',
                                  //        style: TextStyle(
                                  //          fontSize: 24,
                                  //        )),
                                  //
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'สถานะการติดต่อลูกค้า:',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data!.docs[index]['statusCustomer']}',
                                        // statusCustomer
                                        style: snapshot.data!.docs[index]
                                        ['statusCustomer'] ==
                                            'รอโทรยืนยันคำสั่งซื้อ'
                                            ? TextStyle(
                                            fontSize: 24,
                                            color: Colors.red[600],
                                            fontWeight: FontWeight.bold)
                                            : TextStyle(
                                            fontSize: 24,
                                            color: Colors.green[600],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   width: screen * 0.4,
                                      //   height: 40,
                                      //   child: querySnapshot.docs[index]['lat']
                                      //       .toString()
                                      //       .isNotEmpty
                                      //       ? ElevatedButton.icon(
                                      //       onPressed: () {
                                      //         openMap(
                                      //             querySnapshot.docs[index]
                                      //             ['lat'],
                                      //             querySnapshot.docs[index]
                                      //             ['lng']);
                                      //         // Navigator.push(
                                      //         //     context,
                                      //         //     MaterialPageRoute(
                                      //         //       builder: (context) =>
                                      //         //           AdminMap(
                                      //         //               message: querySnapshot
                                      //         //                       .documents[
                                      //         //                   index]),
                                      //         //     ));
                                      //       },
                                      //       icon: Icon(
                                      //         Icons.place,
                                      //         size: 20,
                                      //       ),
                                      //       label: Text(
                                      //         'แสดงในแผนที่',
                                      //         style: TextStyle(
                                      //             fontSize: 20,
                                      //             fontWeight: FontWeight.bold),
                                      //       ))
                                      //       : ElevatedButton.icon(
                                      //       onPressed: () {
                                      //         // openMap(
                                      //         //     querySnapshot.docs[index]['lat'],
                                      //         //     querySnapshot.docs[index]['lng']);
                                      //         // Navigator.push(
                                      //         //     context,
                                      //         //     MaterialPageRoute(
                                      //         //       builder: (context) =>
                                      //         //           AdminMap(
                                      //         //               message: querySnapshot
                                      //         //                       .documents[
                                      //         //                   index]),
                                      //         //     ));
                                      //       },
                                      //       icon: Icon(
                                      //         Icons.place,
                                      //         size: 20,
                                      //       ),
                                      //       label: Text(
                                      //         'แสดงในแผนที่',
                                      //         style: TextStyle(
                                      //             fontSize: 20,
                                      //             fontWeight: FontWeight.bold),
                                      //       )),
                                      // ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width < 1200 ?  MediaQuery.of(context).size.width < 660 ? screen * 0.8 : screen * 0.3 : screen * 0.25 ,
                                        height: 60,
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)),
                                              backgroundColor: Colors.grey,
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                              ),

                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrintPage(
                                                            document: snapshot.data!
                                                                .docs[index],
                                                          )));
                                            },
                                            icon: const Icon(
                                              Icons.print,
                                              size: 20,
                                            ),
                                            label: const Text(
                                              'พิมพ์ใบเสนอราคา',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        // width: screen * 0.4,
                                        width: MediaQuery.of(context).size.width < 1200 ?  MediaQuery.of(context).size.width < 660 ? screen * 0.8 : screen * 0.3 : screen * 0.25 ,
                                        height: 60,
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)),
                                              backgroundColor: Colors.grey,
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                              ),

                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OptionsPage(
                                                            document: snapshot.data!
                                                                .docs[index]),
                                                  ));
                                              //  querySnapshot.documents[index]['status']
                                              // changeStatus(
                                              //     querySnapshot.documents[index]);
                                            },
                                            icon: const Icon(
                                              Icons.local_shipping,
                                              size: 20,
                                            ),
                                            label: const Text(
                                              'แก้ไข/เปลี่ยนสถานะOrder',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
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

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        // width: screen * 0.4,
                                        width: MediaQuery.of(context).size.width < 1200 ?  MediaQuery.of(context).size.width < 660 ? screen * 0.8 : screen * 0.3 : screen * 0.25 ,

                                        height: 60,
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)),
                                              backgroundColor: Colors.grey,
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                              ),

                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OptionsTelPage(
                                                            document: snapshot.data!
                                                                .docs[index]),
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.call_end,
                                              size: 20,
                                            ),
                                            label: const Text(
                                              'แก้ไข/เปลี่ยนสถานะการโทรหาลูกค้า',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 40,),

                                  // const Divider(),
                                ],
                              ),
                            ),
                          );
                        });
                  }),


// StreamBuilder<QuerySnapshot>(
//     stream: dbRef
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('Report')
//         .where('status', isEqualTo: status)
//         .orderBy('time', descending: true)
//     .limit(noDoc)
//         .snapshots(),
//     builder: (context, snapshot) {
//       //loading = false;
//       if (snapshot.data == null) //.data ถ้ามากกว่านี้ไม่ทำงานจ้า
//         return MyStyle().showProgress();
//
//       if (snapshot.data!.docs.length == 0)
//         return Center(child: Text('ไม่พบรายการ'));
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
//       QuerySnapshot<Object?>? querySnapshot = snapshot.data;
//
//       return ListView.builder(
//         // scrollDirection: Axis.vertical,
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: querySnapshot!.docs.length,
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
//             // String _signature =   querySnapshot.docs[index].data().toString().contains('signature') ? querySnapshot.docs[index]['signature'] : 'xxx';
//             // print('####_signature>>>>$_signature');
//             // bool _signatureBool = false;
//             // if (_signature != 'xxx' ) {
//             //   setState(() {
//             //     _signatureBool = true;
//             //   });
//             //
//             // }
//             //
//             // String _note =   querySnapshot.docs[index].data().toString().contains('note') ? querySnapshot.docs[index]['note'] : 'xxx';
//             // bool _noteBool = false;
//             // if (_note != 'xxx' ) {
//             //   setState(() {
//             //     _noteBool = true;
//             //   });
//             //
//             // }
//
//             // String _telephone =  querySnapshot.docs[index].data().toString().contains('telephone') ? querySnapshot.docs[index]['telephone'] : 'xxx';
//             // bool _telephoneBool = false;
//             // if (_telephone != 'xxx' ) {
//             //   setState(() {
//             //     _telephoneBool = true;
//             //   });
//             //
//             // }
//
//             return Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (querySnapshot.docs[index]
//                   ['displayName'] != null)
//                     Wrap(
//                       children: [
//                         Text(
//                           'ชื่อลูกค้า:${querySnapshot.docs[index]['displayName']}',
//                           style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red[600]),
//                         ),
//                       ],
//                     )
//                   else
//                     Text(
//                       'ชื่อลูกค้า: ...ไม่ระบุ......',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                   Text(
//                     '${index + 1}. เลขที่เอกสาร:${querySnapshot.docs[index]['docNo']}',
//                     style: TextStyle(
//                         fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'วันที่ออกใบเสนอราคา:${querySnapshot.docs[index]['docDate']}',
//                     style: TextStyle(
//                         fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     width: screen * 0.8,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0x29000000),
//                           offset: Offset(0, 3),
//                           blurRadius: 6,
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Wrap(
//                         children: [
//                           Text(
//                             'สถานะออร์เดอร์:',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             '${querySnapshot.docs[index]['status']}',
//                             style: TextStyle(
//                                 fontSize: 24,
//                                 color: querySnapshot.docs[index]
//                                 ['status'] ==
//                                     'ยืนยันคำสั่งซื้อ'
//                                     ? Colors.red
//                                     : querySnapshot.docs[index]
//                                 ['status'] ==
//                                     'กำลังเตรียมสินค้า'
//                                     ? Colors.orange[600]
//                                     : querySnapshot.docs[index]
//                                 ['status'] ==
//                                     'กำลังดำเนินการส่งสินค้า'
//                                     ? Colors.yellow[700]
//                                     : Colors.green[700],
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                  //  _signatureBool  ?
//                 chkfour ?    getImageBase64(querySnapshot.docs[index]['signature'])
//                   : Container(), //worked
//                   Row(
//                     children: [
//                       Text(
//                         'มูลค่าทั้งหมด:',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '$_total',
//                         style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red[600]),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         'วันที่ต้องการรับสินค้า:',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       querySnapshot.docs[index]['dateRecieve']
//                           .toString()
//                           .isNotEmpty
//                           ? Text(
//                         '${querySnapshot.docs[index]['dateRecieve']}',
//                         style: TextStyle(
//                             fontSize: 24, color: Colors.red),
//                       )
//                           : Text(''),
//                     ],
//                   ),
//                   // //         Row(
//                   // //           children: [
//                   // //             Text(
//                   // //           'ระยะทาง:',
//                   // //           style:
//                   // //               TextStyle(fontSize: 24, ),
//                   // //         ),
//                   // //             Text(
//                   // //               '$_distance กิโลเมตร',
//                   // //               style:
//                   // //                   TextStyle(fontSize: 24, color: Colors.red),
//                   // //             ),
//                   // //           ],
//                   // //         ),
//                   querySnapshot.docs[index]['lat']
//                       .toString()
//                       .isNotEmpty
//                       ? Text(
//                     'ละติจูด:${querySnapshot.docs[index]['lat']}',
//                     style: TextStyle(
//                       fontSize: 24,
//                     ),
//                   )
//                       : Text('ละติจูด:'),
//                   //
//                   querySnapshot.docs[index]['lng'] != null
//                       ? Text(
//                     'ลองติจูด:${querySnapshot.docs[index]['lng']}',
//                     style: TextStyle(
//                       fontSize: 24,
//                     ),
//                   )
//                       : Text('ลองติจูด:'),
//                   // //       //String === null
//                   //
//                   querySnapshot.docs[index]['telephone']
//                       .toString()
//                       .isNotEmpty
//                       ? Text(
//                     'เบอร์โทร:${querySnapshot.docs[index]['telephone']}',
//                     style: TextStyle(
//                       fontSize: 24,
//                     ),
//                   )
//                       : Text('เบอร์โทร:'),
//                   //
//                   if (querySnapshot.docs[index]
//                   ['nodelivery'])
//                     ListTile(
//                       leading: querySnapshot.docs[index]
//                       ['nodelivery']
//                           ? Icon(
//                         Icons.check_box_outlined,
//                         color: Colors.green[600],
//                       )
//                           : Icon(Icons.check_box_outline_blank),
//                       title: Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน'),
//                     )
//                   else
//                     Container(),
//                   //
//                   if (querySnapshot.docs[index]
//                   ['delivery'])
//                     ListTile(
//                       leading: querySnapshot.docs[index]['delivery']
//                           ? Icon(
//                         Icons.check_box_outlined,
//                         color: Colors.green[600],
//                       )
//                           : Icon(Icons.check_box_outline_blank),
//                       title: Text('ต้องการให้ทางร้านไปส่งสินค้า'),
//                     )
//                   else
//                     Container(),
//                   //
//                  // _noteBool ?
//                     Wrap(
//                       children: [
//                         Text(
//                           'ข้อความจากลูกค้า:${querySnapshot.docs[index]['note']}',
//                           style: TextStyle(
//                             fontSize: 24,
//                           ),
//                         ),
//                       ],
//                     )
//                  // :
//                  //    Text('ข้อความจากลูกค้า: ... ',
//                  //        style: TextStyle(
//                  //          fontSize: 24,
//                  //        ))
//                   ,
//                   //
//                   Row(
//                     children: [
//                       Text(
//                         'สถานะการติดต่อลูกค้า:',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '${querySnapshot.docs[index]['statusCustomer']}',
//                         // statusCustomer
//                         style: querySnapshot.docs[index]
//                         ['statusCustomer'] ==
//                             'รอโทรยืนยันคำสั่งซื้อ'
//                             ? TextStyle(
//                             fontSize: 24,
//                             color: Colors.red[600],
//                             fontWeight: FontWeight.bold)
//                             : TextStyle(
//                             fontSize: 24,
//                             color: Colors.green[600],
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   children: [
//                   //     Container(
//                   //       width: screen * 0.4,
//                   //       height: 40,
//                   //       child: querySnapshot.docs[index]['lat']
//                   //           .toString()
//                   //           .isNotEmpty
//                   //           ? ElevatedButton.icon(
//                   //           onPressed: () {
//                   //             openMap(
//                   //                 querySnapshot.docs[index]
//                   //                 ['lat'],
//                   //                 querySnapshot.docs[index]
//                   //                 ['lng']);
//                   //             // Navigator.push(
//                   //             //     context,
//                   //             //     MaterialPageRoute(
//                   //             //       builder: (context) =>
//                   //             //           AdminMap(
//                   //             //               message: querySnapshot
//                   //             //                       .documents[
//                   //             //                   index]),
//                   //             //     ));
//                   //           },
//                   //           icon: Icon(
//                   //             Icons.place,
//                   //             size: 20,
//                   //           ),
//                   //           label: Text(
//                   //             'แสดงในแผนที่',
//                   //             style: TextStyle(
//                   //                 fontSize: 20,
//                   //                 fontWeight: FontWeight.bold),
//                   //           ))
//                   //           : ElevatedButton.icon(
//                   //           onPressed: () {
//                   //             // openMap(
//                   //             //     querySnapshot.docs[index]['lat'],
//                   //             //     querySnapshot.docs[index]['lng']);
//                   //             // Navigator.push(
//                   //             //     context,
//                   //             //     MaterialPageRoute(
//                   //             //       builder: (context) =>
//                   //             //           AdminMap(
//                   //             //               message: querySnapshot
//                   //             //                       .documents[
//                   //             //                   index]),
//                   //             //     ));
//                   //           },
//                   //           icon: Icon(
//                   //             Icons.place,
//                   //             size: 20,
//                   //           ),
//                   //           label: Text(
//                   //             'แสดงในแผนที่',
//                   //             style: TextStyle(
//                   //                 fontSize: 20,
//                   //                 fontWeight: FontWeight.bold),
//                   //           )),
//                   //     ),
//                   //     SizedBox(
//                   //       width: 5,
//                   //     ),
//                   //     Container(
//                   //       width: screen * 0.4,
//                   //       height: 40,
//                   //       child: ElevatedButton.icon(
//                   //           onPressed: () {
//                   //             Navigator.push(
//                   //                 context,
//                   //                 MaterialPageRoute(
//                   //                     builder: (context) =>
//                   //                         PrintPage(
//                   //                           document: querySnapshot
//                   //                               .docs[index],
//                   //                         )));
//                   //           },
//                   //           icon: Icon(
//                   //             Icons.print,
//                   //             size: 20,
//                   //           ),
//                   //           label: Text(
//                   //             'พิมพ์ใบเสนอราคา',
//                   //             style: TextStyle(
//                   //                 fontSize: 20,
//                   //                 fontWeight: FontWeight.bold),
//                   //           )),
//                   //     ),
//                   //   ],
//                   // ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: screen * 0.4,
//                         height: 40,
//                         child: ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         OptionsPage(
//                                             document: querySnapshot
//                                                 .docs[index]),
//                                   ));
//                               //  querySnapshot.documents[index]['status']
//                               // changeStatus(
//                               //     querySnapshot.documents[index]);
//                             },
//                             icon: Icon(
//                               Icons.local_shipping,
//                               size: 20,
//                             ),
//                             label: Text(
//                               'สถานะOrder',
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       // if (querySnapshot.docs[index].data().containsKey('telephone')
//                       // )
//
//                         Container(
//                             width: screen * 0.4,
//                             height: 40,
//                             child: ElevatedButton.icon(
//                               onPressed: () {
//                                 _makePhoneCall(
//                                     'tel:${querySnapshot.docs[index]['telephone']}');
//                               },
//                               icon: Icon(
//                                 Icons.call,
//                                 size: 20,
//                               ),
//                               label: Text(
//                                 'โทรหาลูกค้า',
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ))
//                       // :
//                       //   Container()
//                       ,
//                     ],
//                   ),
//
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: screen * 0.6,
//                         height: 40,
//                         child: ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         OptionsTelPage(
//                                             document: querySnapshot
//                                                 .docs[index]),
//                                   ));
//                             },
//                             icon: Icon(
//                               Icons.call_end,
//                               size: 20,
//                             ),
//                             label: Text(
//                               'สถานะการโทรหาลูกค้า',
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                       ),
//                     ],
//                   ),
//
//                   Divider(),
//                 ],
//               ),
//             );
//           });
//     }),

           chkfour ?   Row(mainAxisAlignment: MainAxisAlignment.center,
             children: [
             ElevatedButton.icon(onPressed: (){
               setState(() {
              noDoc =  noDoc+100;
               });

             }, icon: Icon(Icons.skip_next,size: 32,), label: Text('แสดงข้อมูลเพิ่ม'))
          ],) : SizedBox()

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
