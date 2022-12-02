// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// //import 'package:wawa/models/barcode_model.dart';
// import 'package:wawa/models/category_model.dart';
// import 'package:wawa/utility/my_style.dart';
// //import 'package:wawa/models/product_model.dart';
// //import 'package:wawa/utility/helper.dart';
// //import 'package:wawa/utility/my_style.dart';
//
// class SynPriceZero extends StatefulWidget {
//   @override
//   _SynPriceZeroState createState() => _SynPriceZeroState();
// }
//
// class _SynPriceZeroState extends State<SynPriceZero> {
//   //List<GenderModel> genderModelList = [];
//   String? selectedGender;
//   List<String> categories = [];
//   List<CategoryModel> categoryModels = [];
//
//   int index = 0;
//   int total = 0;
//   int total2 = 0;
//   bool loading = true;
//   final dbRef = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController ctrlMin = TextEditingController();
//   TextEditingController ctrlMax = TextEditingController();
//
//   void closeLoading() {
//     loading = false;
//   }
//
//   Future<Null> getData() async {
//     QuerySnapshot querySnapshot = await dbRef
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('productprice0')
//         .where('cell', isEqualTo: 'no')
//         //.limit(10)
//         .get();
//     if (querySnapshot.docs.length > 0) {
//       for (var item in querySnapshot.docs) {
//         setState(() {
//           // loading = true;
//         });
//         //worked  print('######$_index.${item['productId']}');
//         freshDataToFirebase(item['code']);
//       }
//       setState(() {
//         // loading = false;
//       });
//     }
//   }
//
//   Future<Null> freshDataToFirebase(String code) async {
//     Map<String, String> headers = Map();
//     headers['GUID'] = 'smlx';
//     headers['provider'] = 'DATA';
//     headers['databasename'] = 'wawa2';
//
//     // String code = '24-0337';
//
//     String urlAPI =
//         'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$code';
//
//     await Dio()
//         .get(urlAPI, options: Options(headers: headers))
//         .then((value2) async {
//       print('value2==>${value2.toString()}');
//       var _name = value2.data['data']['name'];
//       var _image = value2.data['data']['images'][0]['uri'];
//       var _categoryName = value2.data['data']['category_name']; //ok jaa
//       var _itemCategory = value2.data['data']['item_category'];
//       // //var _barcodes = value2.data['data']['barcodes'];
//       var priceFormulas = value2.data['data']['price_formulas'];
//       var isPremium = value2.data['data']['is_premium'];
//       //add 16-6-2021
//       var isHoldSale = value2.data['data']['is_hold_sale'];
//       var isHoldPurchase = value2.data['data']['is_hold_purchase'];
//       // print('###code>>>>$code total2===$total2');
//       // total2 = total2 + 1;
//       // //print('value2==>${value2.toString()}');
//       // var _name = value2.data['data']['name'];
//       // var _image = value2.data['data']['images'];
//       // var _categoryName = value2.data['data']['category_name']; //ok jaa
//       // var _itemCategory = value2.data['data']['item_category'];
//       // //var _barcodes = value2.data['data']['barcodes'];
//       // var priceFormulas = value2.data['data']['price_formulas'];
//       // var isPremium = value2.data['data']['is_premium'];
//       //is_premium
//
//       // if (value2.data['data']['price_formulas'].toString().isEmpty) {
//       //  // print('########################################################price_formulas is null $code');
//       //   await FirebaseFirestore.instance
//       //       .collection('wawastore')
//       //       .doc('wawastore')
//       //       .collection('price0Null')
//       //       .doc(code)
//       //       .set({"code": code, "cell": 'no'});
//       // } else {
//       //   await FirebaseFirestore.instance
//       //       .collection('wawastore')
//       //       .doc('wawastore')
//       //       .collection('price0Null')
//       //       .doc(code)
//       //       .set({"code": code, "cell": 'yes'});
//       // }
//
//       // print('########name == $_name');
//       // print('########_image == $_image');
//       // print('########categoryName == $_categoryName');
//       // print('########itemCategory == $_itemCategory');
//       // print('########bacodes == $_barcodes');
//       // print('####_barcodes.length>>>${_barcodes.length}');
//       // print('########isPremium == $isPremium');
//       //  print('####_barcodes[i].price>>>${_barcodes[0].price}');
//       print('########name == $_name');
//       print('########_image == $_image');
//       print('########categoryName == $_categoryName');
//       print('########itemCategory == $_itemCategory');
//       //   // print('########bacodes == $_barcodes');
//       print('####priceFormulas>>>$priceFormulas');
//       //  // print('####_image.length>>>${_image.length}');
//       print('########isPremium == $isPremium');
//
//       // String _image2 = _image[0]['uri'];
//       // Map<String, dynamic> mapName = Map();
//       // mapName['name'] = _name[0];
//       // mapName['urlImage'] = _image2;
//       // mapName['categoryName'] = _categoryName[0];
//       // mapName['itemCategory'] = _itemCategory[0];
//       // mapName['isPremium'] = isPremium[0];
//       // mapName['isPromotion'] = false;
//       //mapName['isBest'] = false;
//       //  mapName['isOn'] = true;
//
//       Map<String, dynamic> mapName = Map();
//       mapName['name'] = _name;
//       mapName['urlImage'] = _image;
//       mapName['categoryName'] = _categoryName;
//       mapName['itemCategory'] = _itemCategory;
//       mapName['isPremium'] = isPremium;
//       mapName['isHoldSale'] = isHoldSale;
//       mapName['isHoldPurchase'] = isHoldPurchase;
//
//       await FirebaseFirestore.instance
//           .collection('wawastore')
//           .doc('wawastore')
//           .collection('product2')
//           .doc(code)
//           .set(mapName);
//
//       for (var i = 0; i < priceFormulas.length; i++) {
//         print('########code ==>>> $code');
//         print(
//             '########priceFormulas#$i-[unit_code] ==>>> ${priceFormulas[i]['unit_code']}');
//         print(
//             '########priceFormulas#$i-[price_0] ==>>> ${priceFormulas[i]['price_0']}');
//
//         await FirebaseFirestore.instance
//             .collection('wawastore')
//             .doc('wawastore')
//             .collection('product2')
//             .doc(code)
//             .collection('unit_codes')
//             .doc(priceFormulas[i]['unit_code'])
//             .set({
//           "price0": num.parse(priceFormulas[i]['price_0'].toString()),
//           "unit_code": priceFormulas[i]['unit_code'],
//         }).then((value) {
//           print('inserted Success>>>${priceFormulas[i]['unit_code']}');
//         });
//       }
//
//
//       // await FirebaseFirestore.instance
//       //     .collection('wawastore')
//       //     .doc('wawastore')
//       //     .collection('product2')
//       //     .doc(code)
//       //     .set(mapName)
//       //     .then((value) async {
//       //   int _index = 0;
//       //   for (var item in priceFormulas) {
//       //     print('########code ==>>> $code');
//       //     print('########item[unit_code] ==>>> ${item['unit_code']}');
//       //     print('########item[price_0] ==>>> ${item['price_0']}');
//
//       //     await FirebaseFirestore.instance
//       //         .collection('wawastore')
//       //         .doc('wawastore')
//       //         .collection('product2')
//       //         .doc(code)
//       //         .collection('unit_codes')
//       //         .doc(item['unit_code'])
//       //         .set({
//       //       "price0": item['price_0'],
//       //       "unit_code": item['unit_code'],
//       //     });
//       //     _index++;
//       //     total = total + _index;
//       //   }
//       // });
//
//       // setState(() {
//       //   loading = false;
//       // });
//     }).catchError((err) {
//       print('############Dio_err_in_Dio_api>>>>###${err.toString()}');
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     //freshDataToFirebase();
//     getData();
//     super.initState();
//     // freshDataByCategory();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Syn Data to By Price0 v-2'),
//       ),
//       body: Form(
//           key: _formKey,
//           child: loading
//               ? Column(children: [
//                   SizedBox(height: 80),
//                   Center(
//                       child: Text(
//                     'ระบบกำลัง Syn ข้อมูล ...',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                         color: Colors.red),
//                   ))
//                 ])
//               : Column(
//                   children: [
//                     RaisedButton.icon(
//                         onPressed: () {
//                           getData();
//                           closeLoading();
//                         },
//                         icon: Icon(Icons.sync,
//                             size: 36, color: Colors.lightGreen),
//                         label: Text('Sync Data from Price0',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                                 color: Colors.green[700])))
//                   ],
//                 )),
//     );
//   }
// }
//
// // class GenderModel {
// //   String id;
// //   String name;
// //   @override
// //   String toString() {
// //     return '$id $name';
// //   }
//
// //   GenderModel(this.id, this.name);
// // }
