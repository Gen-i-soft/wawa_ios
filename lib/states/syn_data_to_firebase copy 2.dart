// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// //import 'package:wawa/models/barcode_model.dart';
// import 'package:wawa/models/category_model.dart';
// //import 'package:wawa/models/product_model.dart';
// //import 'package:wawa/utility/helper.dart';
// //import 'package:wawa/utility/my_style.dart';

// class SynDataToFirebase extends StatefulWidget {
//   @override
//   _SynDataToFirebaseState createState() => _SynDataToFirebaseState();
// }

// class _SynDataToFirebaseState extends State<SynDataToFirebase> {
//   //List<GenderModel> genderModelList = [];
//   String? selectedGender;
//   List<String> categories = [];
//   List<CategoryModel> categoryModels = [];

//   int index = 0;
//   bool loading = false;
//   final dbRef = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController ctrlMin = TextEditingController();
//   TextEditingController ctrlMax = TextEditingController();

//   Future<Null> getData() async {
//     QuerySnapshot querySnapshot = await dbRef.collection('wawaproduct').get();
//     if (querySnapshot.docs.length > 0) {
//       int _index = 1;
//       for (var item in querySnapshot.docs) {
//         setState(() {
//           loading = true;
//         });
//         //worked  print('######$_index.${item['productId']}');
//         freshDataToFirebase(item['productId']);
//         _index++;
//       }
//       setState(() {
//         loading = false;
//         index = _index;
        
//       });
//     }
//   }

//   Future<Null> freshDataToFirebase(String code) async {
//     Map<String, String> headers = Map();
//     headers['GUID'] = 'smlx';
//     headers['provider'] = 'DATA';
//     headers['databasename'] = 'wawa2';

//     // String code = '24-0337';
//     String urlAPI =
//         'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$code';

//     await Dio()
//         .get(urlAPI, options: Options(headers: headers))
//         .then((value2) async {
//       //print('value2==>${value2.toString()}');
//       var _name = value2.data['data']['name'];
//       var _image = value2.data['data']['images'];
//       var _categoryName = value2.data['data']['category_name']; //ok jaa
//       var _itemCategory = value2.data['data']['item_category'];
//       var _barcodes = value2.data['data']['barcodes'];

//       print('########name == $_name');
//       print('########_image == $_image');
//       print('########categoryName == $_categoryName');
//       print('########itemCategory == $_itemCategory');
//       print('########bacodes == $_barcodes');
//       print('####_barcodes.length>>>${_barcodes.length}');
//       //  print('####_barcodes[i].price>>>${_barcodes[0].price}');

//       String _image2 = _image[0]['uri'];
//       Map<String, dynamic> mapName = Map();
//       mapName['name'] = _name;
//       mapName['urlImage'] = _image2;
//       mapName['categoryName'] = _categoryName;
//       mapName['itemCategory'] = _itemCategory;
//       // mapName['isPromotion'] = false;
//       //mapName['isBest'] = false;
//       //  mapName['isOn'] = true;

//       await FirebaseFirestore.instance
//           .collection('wawastore')
//           .doc('wawastore')
//           .collection('products')
//           .doc(code)
//           .set(mapName);

//       for (var item in _barcodes) {
//         num _price = num.parse(item['price'].toString());
//         // String _barcode = item.barcode;
//         // String unit_code = item.unit_code;
//         print('################_price01>>>${item['price']}');

//         //worked print('################_price01>>>${item['price']}');
//         //not work  print('################_price02>>>${item.price}'); show err:  has no instance getter 'price'.

//         // Map<String, dynamic> mapName2 = Map();
//         // mapName2['price'] = _price;
//         // mapName2['barcode'] = item.barcode;
//         // mapName2['unit_code'] = item.unit_code;

//         await FirebaseFirestore.instance
//             .collection('wawastore')
//             .doc('wawastore')
//             .collection('products')
//             .doc(code)
//             .collection('barcodes')
//             .doc(item.barcode)
//             .set({
//           "barcode": item['barcode'],
//           "price": _price,
//           "unit_code": item['unit_code'],
//         });
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     //freshDataToFirebase();
//     getData();
//     super.initState();
//     // freshDataByCategory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // genderModelList = [
//     //   GenderModel('1', "เครื่องดื่ม/นม"),
//     //   GenderModel('2', "Female"),
//     //   GenderModel('3', "Other")
//     // ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Syn Data to Database'),
//       ),
//       body: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               SizedBox(height:80),
//             loading? Text('ระบบกำลัง Syn ข้อมูลครับ') : Text('ระบบอัพเดทข้อมูลเสร็จแล้วจำนวน $index แถว')
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
