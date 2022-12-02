import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:wawa/backend/admin/adminhomepage.dart';
import 'package:wawa/backend/admin/edit_user_detail.dart';
import 'package:wawa/backend/admin/look_product.dart';
import 'package:wawa/src/widget/product_box.dart';

import 'package:wawa/utility/debouncer.dart';
import 'package:wawa/utility/my_style.dart';

class EditUserPage extends StatefulWidget {
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController _myCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  // List<ProductCloudModel> productModels = List();
  List<String> docts = [];
  ScrollController scrollController = ScrollController();
  int amountListView = 15;
  double screen =0;

  String? searchtxt;
  bool loading = false;
  bool checkOne = false;
  bool checkTwo = false;
  bool checkThree = false;
  //final debouncer = Debouncer(milliseconds: 1000);
  DocumentSnapshot? products;

  List<bool> haveDisplay = [];
  List<bool> haveEmail = [];
  List<bool> haveTel = [];
  List<String> productNames = [];




  Future<Null> readProduct() async {

    setState(() {
      productNames.clear();
    });

    setState(() {
      loading = true;
    });


    try {
      QuerySnapshot qsdisplayName = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('backend')
          .where('open', isEqualTo: true)
          .orderBy('email', descending: false)
          .get();

      if(qsdisplayName.docs.length > 0){
        print('####qsdisplayName>>>${qsdisplayName.docs.length}');

        // for (var item in qsdisplayName.docs) {
        //   setState(() {
        //     productNames.add(item['displayName']);
        //
        //   });
        // }

        for (var item in qsdisplayName.docs) {
          setState(() {

            productNames.add(item['email']);

          });
        }

        // for (var item in qsdisplayName.docs) {
        //   setState(() {
        //
        //     productNames.add(item['tel']);
        //   });
        // }

       // print('####productNames>>>$productNames');

      }



      setState(() {
       // products = snapshot.docs;
        loading = false;
      });
    } catch (e) {
      print('#####error==>${e.toString()}');
    }


    }



  Future navigatorTo(String v)async{



      // QuerySnapshot qsDisplayName = await FirebaseFirestore.instance
      //     .collection('wawastore')
      //     .doc('wawastore')
      //     .collection('backend')
      //     .where('displayName', isEqualTo: v)
      //     .get();


      QuerySnapshot qsEmail = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('backend')
          .where('email', isEqualTo: v)
          .get();


      // QuerySnapshot qsTel = await FirebaseFirestore.instance
      //     .collection('wawastore')
      //     .doc('wawastore')
      //     .collection('backend')
      //     .where('tel', isEqualTo: v)
      //     .get();

      // if(qsDisplayName.docs.length > 0){
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(
      //     builder: (context) =>
      //         EditUserDetail(document: qsDisplayName.docs[0]),
      //   ));
      //
      //   return;
      // }else
        if(qsEmail.docs.length > 0){
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) =>
              EditUserDetail(document: qsEmail.docs[0]),
        ));


      }
      //   else   if(qsTel.docs.length > 0){
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(
      //     builder: (context) =>
      //         EditUserDetail(document: qsTel.docs[0]),
      //   ));
      //
      //   return;
      // }else {
      //   return;
      // }





    //
    //   String res = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => ChooseProduct(
    //         onAdItem: () => widget.onAdItem(),
    //         products: product.docs[0],
    //       ),
    //     ),
    //   );
    //   if (res == 'save') {
    //     widget.onAdItem();
    //   }
    // } else {
    //   Navigator.of(context).pushNamed('/authen');
    // }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initReset();
    readProduct();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          'แก้ไขข้อมูลผู้ใช้งาน',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body:
      SingleChildScrollView(
        child: InteractiveViewer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),
            child: Column(
              children: [
                loading
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'ผลลัพธ์ 0 รายการ',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                )
                    : Container(

                  child: DropdownSearch<String>(
                      maxHeight: screen * 0.7,
                      showSearchBox: true,
                      //searchBoxController: nameCtrl,
                      mode: Mode.MENU,
                      // showSelectedItem: true,
                      items: productNames,
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "ค้นหาผู้ใช้งาน",
                        hintText: "กรอกคำค้นหา",
                      ),
                      //label: "ค้นหาผู้ใช้งาน",
                     // hint: "กรอกคำค้นหา",
                      //popupItemDisabled: (String s) => s.startsWith('I'),
                      // onChanged: print,

                      onChanged: (String? v) async {
                       navigatorTo(v!);

                        //end
                      },
                      selectedItem: productNames.first),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       // decoration: BoxDecoration(
                //       //   borderRadius: BorderRadius.circular(10),
                //       //   color: Colors.orange[200]
                //       // ),
                //       width: screen * 0.6,
                //       child: Padding(
                //         padding: const EdgeInsets.all(10.0),
                //         child: TextField(
                //           controller: _myCtrl,
                //           decoration: InputDecoration(
                //             // hintStyle: TextStyle(color: Colors.black38),
                //             hintText: 'ระบุคำค้น...',
                //             prefixIcon: Icon(
                //               Icons.search,
                //               size: 36,
                //             ),
                //           ),
                //           style: TextStyle(
                //             fontSize: 28,
                //             fontWeight: FontWeight.bold,
                //             // backgroundColor: Colors.orange[200]
                //           ),
                //           onChanged: (text) {
                //             // print('value==>>$text');
                //             setState(() {
                //               searchtxt = text;
                //             });
                //             debouncer.run(() {
                //               readProduct();
                //             });
                //           },
                //         ),
                //       ),
                //     ),
                //     // IconButton(
                //     //   icon: Icon(
                //     //     Icons.check,
                //     //     size: 36,
                //     //     color: Colors.green,
                //     //   ),
                //     //   onPressed: () {
                //     //     readProduct();
                //     //   },
                //     // ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     IconButton(
                //       icon: Icon(
                //         Icons.clear,
                //         size: 36,
                //         color: Colors.red[600],
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           _myCtrl.clear();
                //         });
                //       },
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //   ],
                // ),

                // Expanded(
                //     child: Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: StreamBuilder<QuerySnapshot>(
                //       stream: FirebaseFirestore.instance
                //           .collection('product')
                //           // .where('urlImage', isNotEqualTo: '')
                //           .where('name', isGreaterThanOrEqualTo: searchtxt)
                //           .where('urlImage', isNotEqualTo: '')
                //           // .orderBy('name', descending: false)
                //           .limit(20)
                //           .snapshots(),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasError) {
                //           print(snapshot.hasError);
                //           return new Text('Error: ${snapshot.error}');
                //         }
                //         switch (snapshot.connectionState) {
                //           case ConnectionState.waiting:
                //             return MyStyle().showProgress();

                //             break;
                //           default:
                //             return ListView(
                //               scrollDirection: Axis.vertical,
                //               children: [
                //                 Wrap(
                //                   spacing: 8,
                //                   runSpacing: 8,
                //                   children: snapshot.data.docs
                //                       .map((DocumentSnapshot document) {
                //                     return Column(
                //                       children: [

                // Stack(
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.of(context)
                //             .push(MaterialPageRoute(
                //           builder: (context) =>
                //               ChooseProduct(
                //             products: document,
                //             onAdItem: () =>
                //                 widget.onAdItem(),
                //           ),
                //         ));
                //       },
                //       child: ProductItemBox(
                //           imageurl: document['urlImage'],
                //           width: 100,
                //           height: 70),
                //     ),
                //     Container(
                //       child: Text(
                //         'ขายดี',
                //         style:
                //             TextStyle(color: Colors.pink),
                //       ),
                //       decoration: BoxDecoration(
                //           color: Colors.pink[50],
                //           borderRadius:
                //               BorderRadius.circular(5)),
                //     ),
                //   ],
                // )
                //                       ],
                //                     );
                //                   }).toList(),
                //                 )
                //               ],
                //             );
                //         }
                //       }),
                // ))

                // Expanded(child: null)
                // Container(
                //     child: DropDownField(

                //         controller: productNameSelected,
                //         hintText: 'ระบุคำค้น, กด x เพื่อเคลียร์รายการเดิม',
                //         enabled: true,
                //         itemsVisibleInDropdown: 30,
                //         items: productNames,
                //         textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:Colors.black),

                //       hintStyle: const TextStyle(fontSize:22.0),

                //        labelStyle: const TextStyle(fontSize:22.0),
                //         onValueChanged: (value) {
                //           setState(() {
                //             searchtxt = value;
                //             pStart = false;
                //           });
                //         },
                //       ),
                // ),

                //         DropdownSearch<String>(
                // mode:
                // Mode.MENU
                // ,
                // showSearchBox: true,
                // showClearButton: true,
                // maxHeight: 500,
                // showSelectedItem: true,
                // items: productNames,
                // //label: "Menu mode",
                // hint: "ระบุคำค้น, กด x เพื่อเคลียร์รายการเดิม",

                // onChanged: (value) {
                //        setState(() {
                //               searchtxt = value;
                //               pStart = false;
                //             });

                // },
                // ),

                SizedBox(
                  height: 20,
                ),
                // pStart
                //     ? StreamBuilder<QuerySnapshot>(
                //         stream: dbRef
                //             .collection('wawastore')
                //             .doc('wawastore')
                //             .collection('product2')
                //             .limit(100)
                //             .snapshots(),
                //         builder: (context, snapshot) {
                //           return ListView.builder(
                //             //  controller: scrollController,
                //             // scrollDirection: Axis.vertical,
                //             padding: EdgeInsets.all(10),
                //             shrinkWrap: true,
                //             physics: ScrollPhysics(),
                //             itemCount: snapshot.data.docs.length,
                //             itemBuilder: (context, index) {
                //               products = snapshot.data.docs;
                //               return Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Container(
                //                   //  child: ListTile(
                //                   //    onTap: () async {
                //                   //      if (uid != 'user') {
                //                   //        String res = await Navigator.push(
                //                   //          context,
                //                   //          MaterialPageRoute(
                //                   //            builder: (context) => ChooseProduct(
                //                   //              onAdItem: () => widget.onAdItem(),
                //                   //              products: products[index],
                //                   //            ),
                //                   //          ),
                //                   //        );
                //                   //        if (res == 'save') {
                //                   //          widget.onAdItem();
                //                   //        }
                //                   //      } else {
                //                   //        Navigator.of(context)
                //                   //            .pushNamed('/authen');
                //                   //      }
                //                   //    },
                //                   //    leading: ProductItemBox(
                //                   //        imageurl: products[index]['urlImage'],
                //                   //        width: 60,
                //                   //        height: 60),
                //                   //    title: Text(
                //                   //      '${products[index]['name']}',
                //                   //      style: TextStyle(
                //                   //          fontWeight: FontWeight.bold,
                //                   //          fontSize: 24),
                //                   //    ),
                //                   //    trailing: Icon(
                //                   //      Icons.arrow_right,
                //                   //      size: 24,
                //                   //    ),
                //                   //  ),
                //                   decoration: BoxDecoration(
                //                       color: Colors.grey[300],
                //                       borderRadius: BorderRadius.circular(10)),
                //                 ),
                //               );
                //             },
                //           );
                //         })
                //     :
                // StreamBuilder<QuerySnapshot>(
                //            stream: dbRef
                //                .collection('wawastore')
                //                .doc('wawastore')
                //                .collection('product2')
                //                .where('name', isEqualTo: searchtxt)
                //                .snapshots(),
                //            builder: (context, snapshot) {
                //              return ListView.builder(
                //                //  controller: scrollController,
                //                //  scrollDirection: Axis.vertical,
                //                padding: EdgeInsets.all(10),
                //                shrinkWrap: true,
                //                physics: ScrollPhysics(),
                //                itemCount: snapshot.data.docs.length,
                //                itemBuilder: (context, index) {
                //                  products = snapshot.data.docs;
                //                  return Padding(
                //                    padding: const EdgeInsets.all(8.0),
                //                    child:GestureDetector(
                //                      onTap: () async {
                //                          if (uid != 'user') {
                //                            String res = await Navigator.push(
                //                              context,
                //                              MaterialPageRoute(
                //                                builder: (context) => ChooseProduct(
                //                                  onAdItem: () => widget.onAdItem(),
                //                                  products: products[index],
                //                                ),
                //                              ),
                //                            );
                //                            if (res == 'save') {
                //                              widget.onAdItem();
                //                            }
                //                          } else {
                //                            Navigator.of(context).pushNamed('/authen');
                //                          }
                //                        },
                //
                //                                                  child: Card(
                //                                                    color: Colors.grey[100],
                //                                                    elevation: 4,
                //                        child: Column(
                //                          children: [
                //                            ProductItemBox(
                //                              imageurl: products[index]['urlImage'],
                //                              width: screen*0.8,
                //                              height: screen*0.8),
                //
                //                              Text(
                //            '${products[index]['name']}',
                //            overflow: TextOverflow.ellipsis,
                //            softWrap: false,
                //            maxLines: 3,
                //            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                //          ),
                //
                //
                //
                //                          ],
                //                        ),
                //                      ),
                //                    )
                //
                //                    //  Container(
                //                    //   child: ListTile(
                //                    //     onTap: () async {
                //                    //       if (uid != 'user') {
                //                    //         String res = await Navigator.push(
                //                    //           context,
                //                    //           MaterialPageRoute(
                //                    //             builder: (context) => ChooseProduct(
                //                    //               onAdItem: () => widget.onAdItem(),
                //                    //               products: products[index],
                //                    //             ),
                //                    //           ),
                //                    //         );
                //                    //         if (res == 'save') {
                //                    //           widget.onAdItem();
                //                    //         }
                //                    //       } else {
                //                    //         Navigator.of(context).pushNamed('/authen');
                //                    //       }
                //                    //     },
                //                    //     leading: ProductItemBox(
                //                    //         imageurl: products[index]['urlImage'],
                //                    //         width: 60,
                //                    //         height: 60),
                //                    //     title: Text(
                //                    //       '${products[index]['name']}',
                //                    //       style: TextStyle(
                //                    //           fontWeight: FontWeight.bold,
                //                    //           fontSize: 24),
                //                    //     ),
                //                    //     trailing: Icon(
                //                    //       Icons.arrow_right,
                //                    //       size: 24,
                //                    //     ),
                //                    //   ),
                //                    //   decoration: BoxDecoration(
                //                    //       color: Colors.grey[300],
                //                    //       borderRadius: BorderRadius.circular(10)),
                //                    // ),
                //                  );
                //                },
                //              );
                //            })
              ],
            ),
          ),
        ),
      ),

      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 40,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 10, left: 10),
      //         child: Row(
      //           children: [
      //             Text(
      //               'ค้นหาผู้ใช้งาน',
      //               style: TextStyle(
      //                   fontSize: 30,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             flex: 1,
      //             child: ListTile(
      //               leading: checkOne
      //                   ? Icon(
      //                       Icons.check_box_outlined,
      //                       color: Colors.green[600],
      //                     )
      //                   : Icon(Icons.check_box_outline_blank),
      //               title: Text(
      //                 'ชื่อ',
      //                 style:
      //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      //               ),
      //               onTap: () {
      //                 setState(() {
      //                   checkOne = !checkOne;
      //
      //                   checkTwo = false;
      //                   checkThree = false;
      //                 });
      //               },
      //             ),
      //           ),
      //           Expanded(
      //             flex: 1,
      //             child: ListTile(
      //               leading: checkTwo
      //                   ? Icon(
      //                       Icons.check_box_outlined,
      //                       color: Colors.green[600],
      //                     )
      //                   : Icon(Icons.check_box_outline_blank),
      //               title: Text(
      //                 'อีเมล์',
      //                 style:
      //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      //               ),
      //               onTap: () {
      //                 setState(() {
      //                   checkTwo = !checkTwo;
      //                   checkOne = false;
      //                   checkThree = false;
      //                 });
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             flex: 1,
      //             child: ListTile(
      //               leading: checkThree
      //                   ? Icon(
      //                       Icons.check_box_outlined,
      //                       color: Colors.green[600],
      //                     )
      //                   : Icon(Icons.check_box_outline_blank),
      //               title: Text(
      //                 'เบอร์โทรศัพท์',
      //                 style:
      //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      //               ),
      //               onTap: () {
      //                 setState(() {
      //                   checkThree = !checkThree;
      //                   checkOne = false;
      //                   checkTwo = false;
      //                 });
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Container(
      //             // decoration: BoxDecoration(
      //             //   borderRadius: BorderRadius.circular(10),
      //             //   color: Colors.orange[200]
      //             // ),
      //             width: screen * 0.6,
      //             child: Padding(
      //               padding: const EdgeInsets.all(10.0),
      //               child: TextField(
      //                 decoration: InputDecoration(
      //                   hintStyle: TextStyle(color: MyStyle().darkColor),
      //                   prefixIcon: Icon(
      //                     Icons.search,
      //                     color: MyStyle().darkColor,
      //                   ),
      //                   hintText: 'ระบุคำค้น',
      //                 ),
      //                 controller: _myCtrl,
      //                 style: TextStyle(
      //                     fontSize: 28,
      //                     fontWeight: FontWeight.bold,
      //                     backgroundColor: Colors.orange[200]),
      //                 onChanged: (text) {
      //                   // print('value==>>$text');
      //                   setState(() {
      //                     searchtxt = text;
      //                   });
      //                   // debouncer.run(() {
      //                   //  // readProduct();
      //                   // });
      //                 },
      //               ),
      //             ),
      //           ),
      //           IconButton(
      //             icon: Icon(
      //               Icons.done,
      //               size: 36,
      //               color: Colors.blue,
      //             ),
      //             onPressed: () {
      //               readProduct();
      //             },
      //           ),
      //           SizedBox(
      //             width: 5,
      //           ),
      //           SizedBox(
      //             width: 5,
      //           ),
      //           IconButton(
      //             icon: Icon(
      //               Icons.clear,
      //               size: 36,
      //               color: Colors.red[600],
      //             ),
      //             onPressed: () {
      //               setState(() {
      //                 _myCtrl.clear();
      //               });
      //             },
      //           ),
      //           SizedBox(
      //             width: 5,
      //           ),
      //         ],
      //       ),
      //       loading
      //           ? MyStyle().showProgress()
      //           : ListView.builder(
      //               controller: scrollController,
      //               scrollDirection: Axis.vertical,
      //               padding: EdgeInsets.all(10),
      //               shrinkWrap: true,
      //               physics: ScrollPhysics(),
      //               itemCount: products.length,
      //               itemBuilder: (context, index) {
      //
      //
      //                 return Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Column(
      //                     children: [
      //                       GestureDetector(
      //                         onTap: () {
      //
      //                           Navigator.of(context)
      //                               .push(MaterialPageRoute(
      //                             builder: (context) =>
      //                                 EditUserDetail(document: products[index]),
      //                           ));
      //                           // if (res != null) {
      //                           //   // setState(() {
      //                           //     readProduct();
      //                           //   // });
      //                           //   print('res>>>$res');
      //                           // }
      //                         },
      //                         child: Wrap(
      //                           children: [
      //                             Text(
      //                               '${index + 1} .',
      //                               style: TextStyle(
      //                                   fontWeight: FontWeight.bold,
      //                                   fontSize: 24),
      //                             ),
      //                             Text(
      //                               'DisplayName: ${products[index]['displayName']}',
      //                               style: TextStyle(
      //                                   fontWeight: FontWeight.bold,
      //                                   fontSize: 24),
      //                             ),
      //                             Text(
      //                               ' Email: ${products[index]['email']}',
      //                               style: TextStyle(
      //                                   fontWeight: FontWeight.bold,
      //                                   fontSize: 24),
      //                             ),
      //                             Text(
      //                               ' Telephone: ${products[index]['tel']}',
      //                               style: TextStyle(
      //                                   fontWeight: FontWeight.bold,
      //                                   fontSize: 24),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Divider(),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                     ],
      //                   ),
      //                 );
      //               },
      //             )
      //     ],
      //   ),
      // ),
    );
  }
}
