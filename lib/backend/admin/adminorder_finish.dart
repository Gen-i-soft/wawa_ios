import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wawa/models/report_model.dart';
import 'package:wawa/utility/my_style.dart';


class AdminOrderFinished extends StatefulWidget {
  const AdminOrderFinished({Key? key}) : super(key: key);

  @override
  State<AdminOrderFinished> createState() => _AdminOrderFinishedState();
}

class _AdminOrderFinishedState extends State<AdminOrderFinished> {

  List<ReportModels> listDocument = [];
  Uint8List? bytes;
  String? _imageBase64;
  var scrollController = ScrollController();
  late QuerySnapshot collectionState;
  double screen = 0;
  bool showButton = false;



  Widget getImageBase64(String img) {
    _imageBase64 = img;
    Base64Codec base64 = Base64Codec();
    if (_imageBase64 == null) return Container();
    bytes = base64.decode(_imageBase64!);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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


  Future<void> getDocuments() async {
    listDocument = [];
    Query<Map<String, dynamic>> collection = FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('Report')
        .where('status', isEqualTo: 'ลูกค้ารับสินค้าแล้ว')
        .orderBy('time', descending: true)
        .limit(30);

    // print('####collection>>>$collection');

    fetchDocuments(collection);
  }

  Future<void> getDocumentsNext() async {
    var lastVisible = collectionState.docs[collectionState.docs.length - 1];
    print('listDocument legnth: ${collectionState.size} last: $lastVisible');
    var collection = FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('Report')
        .where('status', isEqualTo: 'ลูกค้ารับสินค้าแล้ว')
        .orderBy('time', descending: true)
        // .collection('product2')
        // .where('categoryName', isEqualTo: categoryId)
        // .where('isHoldSale', isEqualTo: false)
        // .orderBy('brandName')
        // .orderBy('groupMainName')
        .startAfterDocument(lastVisible)
        .limit(30);
    fetchDocuments(collection);
  }

  fetchDocuments(Query<Map<String, dynamic>> collection) {
    collection.get().then((value) {
      collectionState = value;

    if (value.docs.isNotEmpty) {
      for(var item in value.docs){
        ReportModels model = ReportModels.fromMap(item.data());
        listDocument.add(model);
      }

    }

      // value.docs.forEach((element) {
      //   print('#####element.data()>>>${element.data()}');
      //   setState(() {
      //     listDocument.add(DocObj.setDetails(element.data()));
      //   });
      // });

      print('#####elistDocument listDocument>>>${listDocument.length}');
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocuments();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          print('####ListView scroll at top');
          setState(() {
            showButton = false;
          });
        } else {
          print('####Listview scroll at bottom');
          setState(() {
            showButton = true;
          });
          getDocumentsNext();
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('WAWA SHOP'),
      ),
      body:


          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              controller: scrollController,
              physics: ScrollPhysics(),
           shrinkWrap: true,
            itemCount: listDocument.length,
              itemBuilder: (context, index) {
                String _total = MyStyle()
                    .myFormat
                    .format(listDocument[index].totalValue);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (listDocument[index].displayName
                    != null)
                      Wrap(
                        children: [
                          Text(
                            'ชื่อลูกค้า:${listDocument[index].displayName}',
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
                      '${index + 1}. เลขที่เอกสาร:${listDocument[index].docNo}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'วันที่ออกใบเสนอราคา:${listDocument[index].docDate}',
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
                              listDocument[index].status,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: listDocument[index].status
                                   ==
                                      'ยืนยันคำสั่งซื้อ'
                                      ? Colors.red
                                      : listDocument[index].status ==
                                      'กำลังเตรียมสินค้า'
                                      ? Colors.orange[600]
                                      : listDocument[index].status ==
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
                        listDocument[index].dateRecieve
                            .toString()
                            .isNotEmpty
                            ? Text(
                          '${listDocument[index].dateRecieve}',
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
                    listDocument[index].lat
                        .toString()
                        .isNotEmpty
                        ? Text(
                      'ละติจูด:${listDocument[index].lat}',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    )
                        : const Text('ละติจูด:'),
                    //
                    listDocument[index].lng != null
                        ? Text(
                      'ลองติจูด:${listDocument[index].lng}',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    )
                        : const Text('ลองติจูด:'),
                    // //       //String === null
                    //
                    listDocument[index].telephone
                        .toString()
                        .isNotEmpty
                        ? Text(
                      'เบอร์โทร:${listDocument[index].telephone}',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    )
                        : const Text('เบอร์โทร:'),
                    //
                    if (listDocument[index].nodelivery)
                      ListTile(
                        leading: listDocument[index].nodelivery

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
                    if (listDocument[index].delivery
                   )
                      ListTile(
                        leading: listDocument[index].delivery
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
                          'ข้อความจากลูกค้า:${listDocument[index].note}',
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
                          listDocument[index].statusCustomer,
                          // statusCustomer
                          style: listDocument[index].statusCustomer
                           ==
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
                          width: screen * 0.4,
                          height: 60,
                          child: ElevatedButton.icon(
                              onPressed: ()  async {


                                // QuerySnapshot qsData = await  FirebaseFirestore.instance
                                //         .collection('wawastore')
                                //         .doc('wawastore')
                                //         .collection('Report')
                                // .where('docNo', isEqualTo: listDocument[index].docNo)
                                // .get();




                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             PrintPage(
                                //               document: qsData[0],
                                //             )));
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
                    // Row(
                    //   //mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       width: screen * 0.4,
                    //       height: 60,
                    //       child: ElevatedButton.icon(
                    //           onPressed: () {
                    //             // Navigator.push(
                    //             //     context,
                    //             //     MaterialPageRoute(
                    //             //       builder: (context) =>
                    //             //           OptionsPage(
                    //             //               document: snapshot.data!
                    //             //                   .docs[index]),
                    //             //     ));
                    //             //  querySnapshot.documents[index]['status']
                    //             // changeStatus(
                    //             //     querySnapshot.documents[index]);
                    //           },
                    //           icon: const Icon(
                    //             Icons.local_shipping,
                    //             size: 20,
                    //           ),
                    //           label: const Text(
                    //             'แก้ไข/เปลี่ยนสถานะOrder',
                    //             style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold),
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
                    //   height: 15,
                    // ),
                    // Row(
                    //   //mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       width: screen * 0.4,
                    //       height: 60,
                    //       child: ElevatedButton.icon(
                    //           onPressed: () {
                    //             // Navigator.push(
                    //             //     context,
                    //             //     MaterialPageRoute(
                    //             //       builder: (context) =>
                    //             //           OptionsTelPage(
                    //             //               document: snapshot.data!
                    //             //                   .docs[index]),
                    //             //     ));
                    //           },
                    //           icon: const Icon(
                    //             Icons.call_end,
                    //             size: 20,
                    //           ),
                    //           label: const Text(
                    //             'แก้ไข/เปลี่ยนสถานะการโทรหาลูกค้า',
                    //             style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold),
                    //           )),
                    //     ),
                    //   ],
                    // ),

                    const Divider(),
                  ],
                );

              }),


    );
  }
}
