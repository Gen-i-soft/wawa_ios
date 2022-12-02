import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:wawa/src/widget/product_box.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/debouncer.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class SearchVersionTwo extends StatefulWidget {
  final Function onAdItem;
  SearchVersionTwo({required this.onAdItem});
  @override
  _SearchVersionTwoState createState() => _SearchVersionTwoState();
}

class _SearchVersionTwoState extends State<SearchVersionTwo> {
  TextEditingController _myCtrl = TextEditingController();
  TextEditingController productNameSelected = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  // List<ProductCloudModel> productModels = List();
  List<String> docts = [];
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  double screen =0;

  String searchtxt = '';
  bool loading = true;
  bool pStart = true;
  //final debouncer = Debouncer(milliseconds: 1000);
  final dbRef = FirebaseFirestore.instance;
  List<DocumentSnapshot> products = [];
  List<String> productNames = [];
  String uid = 'user';

  Future<Null> checkLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event?.uid == '') {
        } else {
          setState(() {
            uid = event!.uid;
          });
          print('####uid>>${event!.uid}');
        }
      });
    });
  }

  Future<void> readProduct() async {
    setState(() {
      // products.clear();
      productNames.clear();
    });
    // await Firebase.initializeApp().then((value) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('product2')
          // .where('urlImage', isNotEqualTo: '')
          .where('isHoldSale', isEqualTo: false)

          // .collection('product')
          //  .where('name', isGreaterThanOrEqualTo: searchtxt)
          //.where('name', arrayContains: ['','0062'])
          //.where('name',whereIn: [searchtxt])
          // .limit(20)
          .orderBy('name', descending: false)
          .get();
      //   .then((value) async {
      // int _index = 0;

      // for (var item in value.docs) {
      //   Map<String, dynamic> mapName = Map();
      //   mapName['name'] = item['name'];
      //   mapName['urlImage'] = item['urlImage'];
      //   mapName['categoryName'] = item['category'];
      //   mapName['itemCategory'] = item['itemCategory'];

      //   await Firebase.initializeApp().then((value) async {
      //     await FirebaseFirestore.instance
      //         .collection('productsearch')
      //         .doc()
      //         .set(mapName);
      //   });
      // }

      // products = snapshot.docs;
      for (var item in snapshot.docs) {
        setState(() {
          productNames.add(item['name']);
        });
      }
      if (productNames.length > 0) {
        setState(() {
          loading = false;
        });
      }

      // print('####productNames==>>>$productNames');

      // await FirebaseFirestore.instance
      //     .collection('product')
      //     // .where('name', isGreaterThanOrEqualTo: searchtxt)
      //     .where('name', isGreaterThanOrEqualTo: searchtxt)
      //     .where('urlImage', isNotEqualTo: '')
      //     .orderBy('name', descending: false)
      //     .limit(20)
      //     .snapshots()
      //     .listen((event) async {
      //   int index = 0;
      //   for (var snapshot in event.docs) {
      //     ProductCloudModel model =
      //         ProductCloudModel.fromMap(snapshot.data());
      //     docts.add(snapshot.id);

      //     productModels.add(model);
      //     print('model==>>${model.name}');
      //   }
      //   setState(() {
      //     loading = false;
      //   });
      //   print('model==>>${productModels.length}');
      //   print('search==>>$searchtxt');
      // });
    } catch (e) {
      print('e OrderBy==>${e.toString()}');
    }
    // });
  }

  Future navigatorTo(String v)async{
    if (uid != 'user') {
      QuerySnapshot product = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('product2')
      .where('name', isEqualTo: v)
      .get();

      String res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseProduct(
            onAdItem: () => widget.onAdItem(),
            products: product.docs[0],
          ),
        ),
      );
      if (res == 'save') {
        widget.onAdItem();
      }
    } else {
      Navigator.of(context).pushNamed('/authen');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
    readProduct();
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     amountListView = amountListView + 4;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค้นหารายการสินค้า',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: InteractiveViewer(
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
                  : Container(),
                  
                  // Container(

                  //     child: DropdownSearch<String>(
                  //         maxHeight: screen * 0.7,
                  //         showSearchBox: true,
                  //         searchBoxController: nameCtrl,
                  //         mode: Mode.MENU,
                  //         showSelectedItem: true,
                  //         items: productNames,
                  //         label: "ค้นหารายการสินค้า",
                  //         hint: "กรอกคำค้นหา",
                  //         //popupItemDisabled: (String s) => s.startsWith('I'),
                  //         // onChanged: print,

                  //         onChanged: (String v) async {
                  //           navigatorTo(v);

                  //           //end
                  //         },
                  //         selectedItem: productNames.first),
                  //   ),
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
    );
  }
}
