// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class AdminCheckPriceNull extends StatefulWidget {
//   @override
//   _AdminCheckPriceNullState createState() => _AdminCheckPriceNullState();
// }

// class _AdminCheckPriceNullState extends State<AdminCheckPriceNull> {
//   int total = 0;

//   Future<Null> getData() async {
//     QuerySnapshot qsPrice = await FirebaseFirestore.instance
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         .get();

//     if (qsPrice.docs.length > 0) {
//       for (var item in qsPrice.docs) {
//         QuerySnapshot qsPrice0 = await FirebaseFirestore.instance
//             .collection('wawastore')
//             .doc('wawastore')
//             .collection('product2')
//             .doc(item.id)
//             .collection('unit_codes')
//             .get();

//         if (qsPrice0.docs.length > 0) {
//           for (var item2 in qsPrice0.docs) {
//             if (item2['price0'] == null || item2['price0'] == 0) {
//               freshDataToFirebase(item.id);
//               // print(
//               //     '#####################${item.id} >>>>>>>>>>>>>${item2['price0']} ');
//             }
//           }
//         }
//       }
//     }
//   }

//   Future<Null> freshDataToFirebase(String code) async {
//     Map<String, String> headers = Map();
//     headers['GUID'] = 'smlx';
//     headers['provider'] = 'DATA';
//     headers['databasename'] = 'wawa2';

//     // String code = '24-0337';
//     try {
//       String urlAPI =
//           'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$code';

//       await Dio()
//           .get(urlAPI, options: Options(headers: headers))
//           .then((value2) async {
//         //print('value2==>${value2.toString()}');
//         var _name = value2.data['data']['name'];
//         var _image = value2.data['data']['images'];
//         var _categoryName = value2.data['data']['category_name']; //ok jaa
//         var _itemCategory = value2.data['data']['item_category'];
//         //var _barcodes = value2.data['data']['barcodes'];
//         var priceFormulas = value2.data['data']['price_formulas'];
//         var isPremium = value2.data['data']['is_premium'];
//         //is_premium

//         // if (value2.data['data']['price_formulas'].toString().isEmpty) {
//         //  // print('########################################################price_formulas is null $code');
//         //   await FirebaseFirestore.instance
//         //       .collection('wawastore')
//         //       .doc('wawastore')
//         //       .collection('price0Null')
//         //       .doc(code)
//         //       .set({"code": code, "cell": 'no'});
//         // } else {
//         //   await FirebaseFirestore.instance
//         //       .collection('wawastore')
//         //       .doc('wawastore')
//         //       .collection('price0Null')
//         //       .doc(code)
//         //       .set({"code": code, "cell": 'yes'});
//         // }

//         // print('########name == $_name');
//         // print('########_image == $_image');
//         // print('########categoryName == $_categoryName');
//         // print('########itemCategory == $_itemCategory');
//         // print('########bacodes == $_barcodes');
//         // print('####_barcodes.length>>>${_barcodes.length}');
//         // print('########isPremium == $isPremium');
//         //  print('####_barcodes[i].price>>>${_barcodes[0].price}');

//         String _image2 = _image[0]['uri'];
//         Map<String, dynamic> mapName = Map();
//         mapName['name'] = _name;
//         mapName['urlImage'] = _image2;
//         mapName['categoryName'] = _categoryName;
//         mapName['itemCategory'] = _itemCategory;
//         mapName['isPremium'] = isPremium;
//         // mapName['isPromotion'] = false;
//         //mapName['isBest'] = false;
//         //  mapName['isOn'] = true;

//         await FirebaseFirestore.instance
//             .collection('wawastore')
//             .doc('wawastore')
//             .collection('product2')
//             .doc(code)
//             .set(mapName)
//             .then((value) async {
//           int _index = 0;
//           for (var item in priceFormulas) {
//             total = total + _index;
//             print('########code ==>>> $code');
//             print('########item[unit_code] ==>>> ${item['unit_code']}');
//             print('########item[price_0] ==>>> ${item['price_0']}');

//             await FirebaseFirestore.instance
//                 .collection('wawastore')
//                 .doc('wawastore')
//                 .collection('product2')
//                 .doc(code)
//                 .collection('unit_codes')
//                 .doc(item['unit_code'])
//                 .set({
//               "price0": item['price_0'],
//               "unit_code": item['unit_code'],
//             });
//             _index++;
//           }
//         });

//         setState(() {
//           //loading = false;
//         });
//       }).catchError((err) {
//         print('############Dio_err_in_value>>>>###${err.toString()}');
//       });
//     } catch (e) {
//       print('#####Dio_err._try_catch>>>${e.toString()}');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: Text('ระบบกำลังSync Data....>>จำนวน $total Records',style: TextStyle(fontSize: 24,color: Colors.red,fontWeight: FontWeight.bold),)));
//   }
// }
