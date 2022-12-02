// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:wawa/models/barcode_model.dart';
// import 'package:wawa/models/category_model.dart';
// import 'package:wawa/models/product_model.dart';
// import 'package:wawa/utility/my_style.dart';

// class SyncDataByCategory extends StatefulWidget {
//   @override
//   _SyncDataByCategoryState createState() => _SyncDataByCategoryState();
// }

// class _SyncDataByCategoryState extends State<SyncDataByCategory> {
//   List<GenderModel> genderModelList = [];
//   String? selectedGender;
//   List<String> categories = [];
//   List<CategoryModel> categoryModels = [];

//   int index = 0;
//   int numx = 0;
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController ctrlMin = TextEditingController();
//   TextEditingController ctrlMax = TextEditingController();

//   Future<Null> checkTure(String syntxt) async {
//     await FirebaseFirestore.instance
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         .where('statusOK', isEqualTo: true)
//         .where('itemCategory', isEqualTo: syntxt)
//         .snapshots()
//         .listen((event) async {
//       int count = 0;
//       for (var item in event.docs) {
//         String code = item.id;
//         count++; //
//         print('####count.code  true >>>$count.) $code');
//       }
//     });
//   }

//   Future<Null> checkFalse(syntxt) async {
//     await FirebaseFirestore.instance
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         .where('statusOK', isEqualTo: false)
//         .where('itemCategory', isEqualTo: syntxt)
//         .snapshots()
//         .listen((event) async {
//       int count = 0;
//       for (var item in event.docs) {
//         String code = item.id;
//         count++; //
//         print('####count.code  true >>>$count.) $code');
//       }
//     });
//   }

//   Future<Null> freshDataByCategory(syntxt) async {
//     await FirebaseFirestore.instance
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('product2')
//         // .limit(300)

//         .where('itemCategory', isEqualTo: syntxt)
//         .snapshots()
//         .listen((event) async {
//       int number = 0;
//       for (var snapshot in event.docs) {
//         String code = snapshot.id;
//         print('####code>>>>$code');
//         try {
//           String urlAPI =
//               'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$code';
//           Map<String, String> headers = Map();
//           headers['GUID'] = 'smlx';
//           headers['provider'] = 'DATA';
//           headers['databasename'] = 'wawa2';

//           await Dio()
//               .get(urlAPI, options: Options(headers: headers))
//               .then((value2) async {
//             print('value2==>${value2.toString()}');
//             var _name = '';
//             if (value2.data['data']['name'] != null) {
//               _name = value2.data['data']['name'];
//             }
//             var _image = '';
//             if (value2.data['data']['images'] != null) {
//               _image = value2.data['data']['images'][0]['uri'];
//             }

//             var _categoryName = '';
//             if (value2.data['data']['category_name'] != null) {
//               _categoryName = value2.data['data']['category_name'];
//             }

//             var _itemCategory = '';
//             if (value2.data['data']['item_category'] != null) {
//               _itemCategory = value2.data['data']['item_category'];
//             }

//            // var priceFormulas = [];
//            // if (value2.data['data']['price_formulas'] != null) {
//             var priceFormulas =   value2.data['data']['price_formulas'];
//            // }

//             var isPremium = false;
//             if (value2.data['data']['is_premium'] != null) {
//               isPremium = value2.data['data']['is_premium'];
//             }
//             //add 16-6-2021
//             var isHoldSale = false;
//             if (value2.data['data']['is_hold_sale'] != null) {
//               isHoldSale = value2.data['data']['is_hold_sale'];
//             }

//             var isHoldPurchase = false;
//            if ( value2.data['data']['is_hold_purchase'] != null) {
//              isHoldPurchase = value2.data['data']['is_hold_purchase'];
             
//            }

//             Map<String, dynamic> mapName = Map();
//             mapName['name'] = _name;
//             mapName['urlImage'] = _image;
//             mapName['categoryName'] = _categoryName;
//             mapName['itemCategory'] = _itemCategory;
//             mapName['isPremium'] = isPremium;
//             mapName['isHoldSale'] = isHoldSale;
//             mapName['isHoldPurchase'] = isHoldPurchase;
//             mapName['statusOK'] = true;

//             await FirebaseFirestore.instance
//                 .collection('wawastore')
//                 .doc('wawastore')
//                 .collection('product2')
//                 .doc(code)
//                 .set(mapName);

//             for (var i = 0; i < priceFormulas.length; i++) {
//               print('########code ==>>> $code');
//               print(
//                   '########priceFormulas#$i-[unit_code] ==>>> ${priceFormulas[i]['unit_code']}');
//               print(
//                   '########priceFormulas#$i-[price_0] ==>>> ${priceFormulas[i]['price_0']}');

//               await FirebaseFirestore.instance
//                   .collection('wawastore')
//                   .doc('wawastore')
//                   .collection('product2')
//                   .doc(code)
//                   .collection('unit_codes')
//                   .doc(priceFormulas[i]['unit_code'])
//                   .set({
//                 "price0": num.parse(priceFormulas[i]['price_0'].toString()),
//                 "unit_code": priceFormulas[i]['unit_code'],
//               }).then((value) {
//                 print('inserted Success>>>${priceFormulas[i]['unit_code']}');
//               });
//             }
//           });

//           number++;
//           print('######number>>>$number'); // end.

//         } on DioError catch (e) {
//           if (e.response!.statusCode == 404) {
//             print('#####e.response.statusCode>>>${e.response!.statusCode}');
//           } else {
//             print('#####e.message>>>${e.message}');
//            // print('#####e.request>>>${e.request}');
//           }
//         }
//       }
//     });
//     // });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // freshDataByCategory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     genderModelList = [
//       GenderModel('001', "ของใช้อื่นๆ"),
//       GenderModel('002', "ข้าวสาร/เครื่องปรุง/อาหารแห้ง"),
//       GenderModel('004', "เครื่องดื่ม/นม"),
//       GenderModel('005', "แอลกอฮอล"),
//       GenderModel('006', "บุหรี่"),
//       GenderModel('007', "สินค้า แลกเปลี่ยน"),
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Syn Data By Category'),
//       ),
//       body: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15),
//                   child: TextFormField(
//                     style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.greenAccent[700]),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'กรุณาระบุ รหัส category ';
//                       }
//                       return null;
//                     },
//                     controller: ctrlMin,
//                     decoration: InputDecoration(
//                         labelText: 'รหัส Category',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green[700]),
//                         helperText:
//                             'ระบุเลขรหัส เช่น 001, 002, 003,004,005,...',
//                         helperStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green[300]),
//                         prefixIcon: Icon(
//                           Icons.edit,
//                           color: Colors.green[700],
//                           size: 32,
//                         )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 200,
//                         height: 80,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   //valid
//                                   freshDataByCategory(ctrlMin.text);
//                                 } else {
//                                   //invalid
//                                 }
//                               },
//                               child: Text(
//                                 'Sync Data',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 24),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 200,
//                         height: 80,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 checkTure(ctrlMin.text);
//                               },
//                               child: Text(
//                                 'Check True',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 24),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 200,
//                         height: 80,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 checkFalse(ctrlMin.text);
//                               },
//                               child: Text(
//                                 'Check False',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 24),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }

// class GenderModel {
//   String id;
//   String name;
//   @override
//   String toString() {
//     return '$id $name';
//   }

//   GenderModel(this.id, this.name);
// }
