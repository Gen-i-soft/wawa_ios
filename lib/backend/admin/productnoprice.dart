// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:wawa/backend/admin/product_null_price0.dart';
// import 'package:wawa/models/product_null_model.dart';
// import 'package:wawa/utility/my_style.dart';

// class ProductNoPricePage extends StatefulWidget {
//   @override
//   _ProductNoPricePageState createState() => _ProductNoPricePageState();
// }

// class _ProductNoPricePageState extends State<ProductNoPricePage> {
//   List<ProductNullModels> productNullModels = [];
//   bool loading = false;
//   int total = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     readProduct();
//     super.initState();
//   }

//   Future<Null> freshDataToFirebase(String code) async {
//     Map<String, String> headers = Map();
//     headers['GUID'] = 'smlx';
//     headers['provider'] = 'DATA';
//     headers['databasename'] = 'wawa2';

//     // String code = '24-0337';
//    // int _total = 0;
//     try {
//       String urlAPI =
//           'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$code';

//       await Dio()
//           .get(urlAPI, options: Options(headers: headers))
//           .then((value2) async {
//             total = total+ 1;
//         //print('value2==>${value2.toString()}');
//         var _name = value2.data['data']['name'];
//         var _image = value2.data['data']['images'];
//         var _categoryName = value2.data['data']['category_name']; //ok jaa
//         var _itemCategory = value2.data['data']['item_category'];
//         //var _barcodes = value2.data['data']['barcodes'];
//         var priceFormulas = value2.data['data']['price_formulas'];
//         var isPremium = value2.data['data']['is_premium'];
//         //add 16-6-2021
//       var isHoldSale = value2.data['data']['is_hold_sale'];
//       var isHoldPurchase = value2.data['data']['is_hold_purchase'];
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
//         mapName['isHoldSale'] = isHoldSale;
//         mapName['isHoldPurchase'] = isHoldPurchase;
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
//            // total = total + _index;
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


//   Future<Null> readProduct() async {
//     setState(() {
//       loading = true;
//     });

//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         .get();

//     if (querySnapshot.docs.length > 0) {
//       for (var item in querySnapshot.docs) {
//         await FirebaseFirestore.instance
//             .collection('wawastore')
//             .doc('wawastore')
//             .collection('product2')
//             .doc(item.id)
//             .collection('unit_codes')
//             .snapshots()
//             .listen((event) async {
//           if (event.docs.length > 0) {
//             await FirebaseFirestore.instance
//                 .collection('wawastore')
//                 .doc('wawastore')
//                 .collection('productprice0')
//                 .doc(item.id)
//                 .set({"code": item.id, "cell": 'yes'});
//           } else {
//             await FirebaseFirestore.instance
//                 .collection('wawastore')
//                 .doc('wawastore')
//                 .collection('productprice0')
//                 .doc(item.id)
//                 .set({"code": item.id, "cell": 'no'});
//           }
//         });
//       }
//       // });

//     }

//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: loading ? Center(child: Text('กำลังประมวลผล...',style: TextStyle(fontSize: 24,color: Colors.red,fontWeight: FontWeight.bold),)) :  
//      Padding(
//        padding: const EdgeInsets.only(top:80),
//        child: Row(mainAxisAlignment: MainAxisAlignment.center,
//     // crossAxisAlignment: CrossAxisAlignment.center,
//          children: [
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(width: 150,height: 60,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey[800],
//                         ),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => ProductNullPrice0(),
//                             ));
//                           },
//                           child: Text(
//                             'แสดงรายการ',
//                             style: TextStyle(
//                               //fontFamily: 'Sukhumvit Set',
//                               fontSize: 30,
//                               color:  Colors.white,
//                               fontWeight: FontWeight.w700,
//                             ),
//                            // textAlign: TextAlign.left,
//                           ),
//                         ),
//                       ),
//            ),
//          ],
//        ),
//      ),

//         // productNullModels.length == 0
//         //     ? Row(
//         //         mainAxisAlignment: MainAxisAlignment.center,
//         //         children: [
//         //           Text(
//         //             'ไม่มีรายการสินค้า',
//         //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         //           ),
//         //         ],
//         //       )
//         //     : ListView.builder(
//         //         padding: EdgeInsets.all(10),
//         //         shrinkWrap: true,
//         //         physics: ScrollPhysics(),
//         //         itemCount: productNullModels.length,
//         //         itemBuilder: (context, index) => GestureDetector(
//         //           onTap: () {},
//         //           child: Row(
//         //             children: [
//         //               Expanded(
//         //                 flex: 3,
//         //                 child: Text(productNullModels[index].code,
//         //                     style: TextStyle(
//         //                         fontWeight: FontWeight.bold, fontSize: 22)),
//         //               ),
//         //               Expanded(
//         //                 flex: 3,
//         //                 child: Text(productNullModels[index].cell,
//         //                     style: TextStyle(
//         //                         fontWeight: FontWeight.bold, fontSize: 22)),
//         //               )
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         );
//   }
// }
