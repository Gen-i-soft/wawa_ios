// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// //import 'package:wawa/models/barcode_model.dart';
// import 'package:wawa/models/category_model.dart';
// import 'package:wawa/utility/my_style.dart';
// //import 'package:wawa/models/product_model.dart';
// //import 'package:wawa/utility/helper.dart';
// //import 'package:wawa/utility/my_style.dart';

// class SetStatusOKToFalsePage extends StatefulWidget {
//   @override
//   _SetStatusOKToFalsePageState createState() => _SetStatusOKToFalsePageState();
// }

// class _SetStatusOKToFalsePageState extends State<SetStatusOKToFalsePage> {
//   //List<GenderModel> genderModelList = [];
//   String selectedGender;
//   List<String> categories = List();
//   List<CategoryModel> categoryModels = List();

//   int index = 0;
//   int total = 0;
//   int totaltwo = 0;
//   bool loading = false;
//   final dbRef = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController ctrlMin = TextEditingController();
//   TextEditingController ctrlMax = TextEditingController();

//   Future<Null> readDataFalse() async {
//     print('####is pass readDataFalse');
//     await dbRef
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         .where('statusOK', isNotEqualTo: true)
//         .snapshots()
//         .listen((event) async {
    

//       int count1 = 0;
//       for (var item in event.docs) {
//         String _id = item.id;
//         print('###_id>>>$_id');
//         count1++;

//         total = total + count1;
//         print('####total>>>$total');
//       }
//     });
//   }

//   Future<Null> syncDataFalse() async {
//     QuerySnapshot qsReadDataFalse = await dbRef
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         .where('statusOK', isNotEqualTo: true)
//         .get();
//   }

//   Future<Null> setDataToFalse() async {}

//   // Future<Null> getData() async {
//   //   QuerySnapshot querySnapshot = await dbRef
//   //       .collection('wawastore')
//   //       .doc('wawastore')
//   //       .collection('wawaproduct')
//   //       //.limit(10)
//   //       .get();
//   //   if (querySnapshot.docs.length > 0) {
//   //     int _total = 0;
//   //     for (var item in querySnapshot.docs) {
//   //       // setState(() {
//   //       //   // loading = true;
//   //       // });
//   //       //worked  print('######$_index.${item['productId']}');
//   //       freshDataToFirebase(item['productId']);
//   //       _total++;
//   //       total = total + _total;
//   //     }
//   //     // setState(() {
//   //     //   // loading = false;
//   //     // });
//   //   }
//   // }

//   // Future<Null> freshDataToFirebase(String code) async {
//   //   // setState(() {
//   //   //   loading = true;
//   //   // });
//   //   Map<String, String> headers = Map();
//   //   headers['GUID'] = 'smlx';
//   //   headers['provider'] = 'DATA';
//   //   headers['databasename'] = 'wawa2';

//   //   // String code = '24-0337';
//   //   // try {
//   //   String urlAPI =
//   //       'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$code';

//   //   await Dio()
//   //       .get(urlAPI, options: Options(headers: headers))
//   //       .then((value2) async {
//   //     print('value2==>${value2.toString()}');
//   //     var _name = value2.data['data']['name'];
//   //     var _image = value2.data['data']['images'][0]['uri'];
//   //     var _categoryName = value2.data['data']['category_name']; //ok jaa
//   //     var _itemCategory = value2.data['data']['item_category'];
//   //     // //var _barcodes = value2.data['data']['barcodes'];
//   //     var priceFormulas = value2.data['data']['price_formulas'];
//   //     var isPremium = value2.data['data']['is_premium'];
//   //     //add 16-6-2021
//   //     var isHoldSale = value2.data['data']['is_hold_sale'];
//   //     var isHoldPurchase = value2.data['data']['is_hold_purchase'];
//   //     //is_premium

//   //     // if (value2.data['data']['price_formulas'].toString().isEmpty) {
//   //     //  // print('########################################################price_formulas is null $code');
//   //     //   await FirebaseFirestore.instance
//   //     //       .collection('wawastore')
//   //     //       .doc('wawastore')
//   //     //       .collection('price0Null')
//   //     //       .doc(code)
//   //     //       .set({"code": code, "cell": 'no'});
//   //     // } else {
//   //     //   await FirebaseFirestore.instance
//   //     //       .collection('wawastore')
//   //     //       .doc('wawastore')
//   //     //       .collection('price0Null')
//   //     //       .doc(code)
//   //     //       .set({"code": code, "cell": 'yes'});
//   //     // }

//   //     // print('########name == $_name');
//   //     // print('########_image == $_image');
//   //     // print('########categoryName == $_categoryName');
//   //     // print('########itemCategory == $_itemCategory');
//   //     //   // print('########bacodes == $_barcodes');
//   //     // print('####priceFormulas>>>$priceFormulas');
//   //     //  // print('####_image.length>>>${_image.length}');
//   //     // print('########isPremium == $isPremium');
//   //     //   //  print('####_barcodes[i].price>>>${_barcodes[0].price}');
//   //     //   bool _premium = false;
//   //     //   if (isPremium != null) {
//   //     //     setState(() {
//   //     //       _premium = isPremium;
//   //     //     });
//   //     //   }

//   //     //   String _image2 = _image['uri'];
//   //     //   print('####_image2>>>$_image2');

//   //     Map<String, dynamic> mapName = Map();
//   //     mapName['name'] = _name;
//   //     mapName['urlImage'] = _image;
//   //     mapName['categoryName'] = _categoryName;
//   //     mapName['itemCategory'] = _itemCategory;
//   //     mapName['isPremium'] = isPremium;
//   //     mapName['isHoldSale'] = isHoldSale;
//   //     mapName['isHoldPurchase'] = isHoldPurchase;
//   //     mapName['statusOK'] = true;

//   //     // mapName['isPromotion'] = false;
//   //     //mapName['isBest'] = false;
//   //     // mapName['isOn'] = true;

//   //     await FirebaseFirestore.instance
//   //         .collection('wawastore')
//   //         .doc('wawastore')
//   //         .collection('product2')
//   //         .doc(code)
//   //         .set(mapName);

//   //     int _index = 0;
//   //     for (var i = 0; i < priceFormulas.length; i++) {
//   //       print('########code ==>>> $code');
//   //       print(
//   //           '########priceFormulas#$i-[unit_code] ==>>> ${priceFormulas[i]['unit_code']}');
//   //       print(
//   //           '########priceFormulas#$i-[price_0] ==>>> ${priceFormulas[i]['price_0']}');

//   //       // num _price0 = 0;

//   //       // switch (item['price_0'].runtimeType) {
//   //       //   case num:
//   //       //     _price0 = item['price_0'];
//   //       //     print('########price type num');
//   //       //     break;
//   //       //   case String:
//   //       //     _price0 = double.parse(item['price_0']);
//   //       //     print('########price type String');
//   //       //     break;
//   //       // }

//   //       await FirebaseFirestore.instance
//   //           .collection('wawastore')
//   //           .doc('wawastore')
//   //           .collection('product2')
//   //           .doc(code)
//   //           .collection('unit_codes')
//   //           .doc(priceFormulas[i]['unit_code'])
//   //           .set({
//   //         "price0": num.parse(priceFormulas[i]['price_0'].toString()),
//   //         "unit_code": priceFormulas[i]['unit_code'],
//   //       }).then((value) {
//   //         print('inserted Success>>>${priceFormulas[i]['unit_code']}');
//   //         // setState(() {
//   //         //   loading = false;
//   //         // });
//   //       });

//   //       _index++;
//   //       totaltwo = totaltwo + _index;
//   //       print('inserted Success>>>$totaltwo');
//   //     }

//   //     //   setState(() {
//   //     //     loading = false;
//   //     //   });
//   //   }).catchError((err) {
//   //     print('############Dio_err_in_Dio_api>>>>###${err.toString()}');
//   //   });
//   //   //   } catch (e) {
//   //   //     print('#####Dio_err._try_catch>>>${e.toString()}');
//   //   //}
//   //   // setState(() {
//   //   //   loading = false;
//   //   // });
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     //freshDataToFirebase();
//     // getData();
//     readDataFalse();
//     super.initState();

//     // freshDataByCategory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SET StatusOK To False'),
//       ),
//       body: Form(
//           key: _formKey,
//           child:
//               //  loading
//               //     ? MyStyle().showProgress()
//               //     :
//               Column(
//             children: [
//               SizedBox(height: 80),

//               Center(
//                 child: Text(
//                   'จำนวน ฟิลด์ StatusOk > False = $total ฟิลด์',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 32,
//                       color: Colors.red),
//                 ),
//               ),
//               // :
//               // Center(
//               //     child: Text('ระบบอัพเดทข้อมูลเสร็จแล้ว',
//               //         style: TextStyle(
//               //             fontWeight: FontWeight.bold,
//               //             fontSize: 32,
//               //             color: Colors.green[700])))
//               //   style: TextStyle(
//               //       fontSize: 28,
//               //       fontWeight: FontWeight.bold,
//               //       color: Colors.greenAccent[700]),
//               //   validator: (value) {
//               //     if (value.isEmpty) {
//               //       return 'กรุณาระบุค่าต่ำสุด';
//               //     }
//               //     return null;
//               //   },
//               //   controller: ctrlMin,
//               //   decoration: InputDecoration(
//               //       // fillColor: Colors.white,
//               //       // filled: true,
//               //       labelText: 'ค่าต่ำสุด',
//               //       labelStyle: TextStyle(
//               //           fontWeight: FontWeight.bold, color: Colors.green[700]),
//               //       helperText: 'ระบุค่าต่ำสุด =1',
//               //       helperStyle: TextStyle(
//               //           fontWeight: FontWeight.bold, color: Colors.green[300]),
//               //       prefixIcon: Icon(
//               //         Icons.edit,
//               //         color: Colors.green[700],
//               //         size: 32,
//               //       )),
//               // ),
//               // SizedBox(
//               //   height: 20,
//               // ),
//               // TextFormField(
//               //   style: TextStyle(
//               //       fontSize: 28,
//               //       fontWeight: FontWeight.bold,
//               //       color: Colors.green[700]),
//               //   validator: (value) {
//               //     if (value.isEmpty) {
//               //       return 'กรุณาระบุค่าสูงสุด';
//               //     }
//               //     return null;
//               //   },
//               //   controller: ctrlMax,
//               //   decoration: InputDecoration(
//               //       // fillColor: Colors.white,
//               //       // filled: true,
//               //       labelText: 'ค่าสูงสุด',
//               //       labelStyle: TextStyle(
//               //           fontWeight: FontWeight.bold, color: Colors.green[700]),
//               //       helperText: 'ระบุค่าสูงสุด =2080',
//               //       helperStyle: TextStyle(
//               //           fontWeight: FontWeight.bold, color: Colors.green[300]),
//               //       prefixIcon: Icon(
//               //         Icons.edit,
//               //         size: 32,
//               //         color: Colors.green[700],
//               //       )),
//               // ),
//               // // Row(
//               // //   mainAxisAlignment: MainAxisAlignment.center,
//               // //   children: [
//               // //     Text(
//               // //       'จำนวนฟิล์ดทั้งหมด $index',
//               // //       style: TextStyle(
//               // //           fontSize: 30,
//               // //           color: Colors.red[700],
//               // //           fontWeight: FontWeight.bold),
//               // //     )
//               // //   ],
//               // // ),
//               // SizedBox(
//               //   height: 20,
//               // ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     Container(
//               //       width: 200,
//               //       height: 80,
//               //       child: Padding(
//               //         padding: const EdgeInsets.all(8.0),
//               //         child: ElevatedButton(
//               //             onPressed: () {
//               //               if (_formKey.currentState.validate()) {
//               //                 //valid
//               //                 freshDataToFirebase(
//               //                     int.parse(ctrlMin.text.trim()),
//               //                     int.parse(ctrlMax.text.trim()));
//               //               } else {
//               //                 //invalid
//               //               }
//               //             },
//               //             child: Text(
//               //               'Sync Data($index)',
//               //               style: TextStyle(
//               //                   fontWeight: FontWeight.bold, fontSize: 24),
//               //             )),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               // loading
//               //     ? MyStyle().showProgress()
//               //     : Container(
//               //         child: Text(
//               //           '',
//               //           style: TextStyle(
//               //               fontSize: 30,
//               //               fontWeight: FontWeight.bold,
//               //               color: Colors.red[600]),
//               //         ),
//               //       ),

//               // //   Center(
//               // //     child: new Column(
//               // //       mainAxisAlignment: MainAxisAlignment.center,
//               // //       children: <Widget>[
//               // //         DropdownButtonHideUnderline(
//               // //           child: new DropdownButton<String>(
//               // //             hint: new Text("เลือก Category"),
//               // //             value: selectedGender,
//               // //             isDense: true,
//               // //             onChanged: (String newValue) {
//               // //               setState(() {
//               // //                 selectedGender = newValue;
//               // //               });
//               // //               print(selectedGender);
//               // //             },
//               // //             items: genderModelList.map((GenderModel map) {
//               // //               return new DropdownMenuItem<String>(
//               // //                 value: map.name,
//               // //                 child: new Text(map.name,
//               // //                     style: new TextStyle(color: Colors.black)),
//               // //               );
//               // //             }).toList(),
//               // //           ),
//               // //         ),
//               // //       ],
//               // //     ),
//               // //   ),
//             ],
//           )),
//     );
//   }
// }

// // class GenderModel {
// //   String id;
// //   String name;
// //   @override
// //   String toString() {
// //     return '$id $name';
// //   }

// //   GenderModel(this.id, this.name);
// // }
