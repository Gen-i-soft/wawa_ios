// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// //import 'package:wawa/models/barcode_model.dart';
// import 'package:wawa/models/category_model.dart';
// import 'package:wawa/models/product_model.dart';
// import 'package:wawa/models/producttwo.dart';
// //import 'package:wawa/utility/my_style.dart';

// class SynDatabyGroup extends StatefulWidget {
//   @override
//   _SynDatabyGroupState createState() => _SynDatabyGroupState();
// }

// class _SynDatabyGroupState extends State<SynDatabyGroup> {
//   //List<GenderModel> genderModelList = [];
//   String? selectedGender;
//   List<String> categories = [];
//   List<CategoryModel> categoryModels = [];
//   List<String> status = [
//     '001',
//     '002',
//     '003',
//     '004',
//     '005',
//     '006',
//     '007',
//     '008'
//   ];
//   String selectedType = 'start';

//   int index = 0;
//   int runnigNumber = 0;
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController ctrlMin = TextEditingController();
//   TextEditingController ctrlMax = TextEditingController();
//   List<ProductModel> productModels = [];

//   Future<Null> updateProductByGroup(String code) async {
//     setState(() {
//       loading = true;
//     });
//     // for (var page = minPage; page <= maxPage; page++) {
//     //   String path =
//     //       'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product?page=$page&size=20';
//     Map<String, String> headers = Map();
//     headers['GUID'] = 'smlx';
//     headers['provider'] = 'DATA';
//     headers['databasename'] = 'wawa2';

//     await Firebase.initializeApp().then((value) async {
//       await FirebaseFirestore.instance
//           .collection('wawastore')
//           .doc('wawastore')
//           .collection('product')
//           .where('itemCategory', isEqualTo: code)
//           .snapshots()
//           .listen((event) async {
//         //
//         if (event.docs.length > 0) {
//           int _index = 0;
//           setState(() {
//             loading = true;
//           });
//           for (var item in event.docs) {
//             try {
//               print('###itemCategory ==>> ${item['itemCategory']}');
//               print('###id/code ==>> ${item.id}');

//               ProductTwoModel model = ProductTwoModel.fromMap(item.data());
//               //print('###code ==>> ${item['code']}');
//               String urlAPI =
//                   'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/${item.id}';

//               await Dio()
//                   .get(urlAPI, options: Options(headers: headers))
//                   .then((value) async {
//                 var result = value.data['data']['images'];
//                 // if (result == null) {
//                 //   setState(() {
//                 //     loading = false;
//                 //   });
//                 // }
//                 var categoryName = value.data['data']['category_name']; //ok jaa
//                 var itemCategory = value.data['data']['item_category'];
//                 var _barcodes = value.data['data']['barcodes'];

//                 String urlImage = '';
//                 if (result != null) {
//                   for (var item2 in result) {
//                     urlImage = item2['uri'];
//                     print('urlImage of ==>> $urlImage');
//                     if (urlImage != null) {
//                       //select insert array

//                       Map<String, dynamic> mapName = Map();
//                       mapName['name'] = item['name'];
//                       mapName['urlImage'] = urlImage;
//                       mapName['categoryName'] = categoryName;
//                       mapName['itemCategory'] = itemCategory;
//                       mapName['isPromotion'] = false;
//                       mapName['isBest'] = false;
//                       mapName['isOn'] = true;

//                       // await Firebase.initializeApp().then((value) async {
//                       await FirebaseFirestore.instance
//                           .collection('wawastore')
//                           .doc('wawastore')
//                           .collection('product')
//                           .doc(item.id)
//                           // .collection('collectionPath')
//                           .set(mapName);

//                       for (var item3 in _barcodes) {
//                         // print('####barcodes>>${item['barcode']}');
//                         //String _price = item3['price'].toString();
//                         // String _price2 = item3['barcodes'].price.toString();

//                         // print('###_price>>>$_price');
//                         // print('###_price2>>>$_price2');
//                         await FirebaseFirestore.instance
//                             .collection('wawastore')
//                             .doc('wawastore')
//                             .collection('product')
//                             .doc(item.id)
//                             .collection('barcodes')
//                             .doc(item3['barcode'])
//                             .set({
//                           "barcode": item3['barcode'],
//                           "price": item3['price'],
//                           "unit_code": item3['unit_code']
//                         });
//                       }

//                       // .then((value) async {
//                       // for (var i = 0; i < item['barcodes'].length; i++) {
//                       //   print('###item-barcodes]>>>${item['barcodes']}');
//                       // }
//                       // double defaultValue = 0;
//                       // String _price = item['barcodes'][i].price.toString();
//                       // BarcodeModel barcodeModel = BarcodeModel(
//                       //     barcode: item['barcodes'][i].barcode,
//                       //     price: double.tryParse(_price),
//                       //     // price: double.parse(model.barcodes[i].price.toString()) ,
//                       //     unit_code: item['barcodes'][i].unitCode);
//                       // Map<String, dynamic> mapBarcode = barcodeModel.toMap();

//                       // await FirebaseFirestore.instance
//                       //     .collection('wawastore')
//                       //     .doc('wawastore')
//                       //     .collection('product')
//                       //     .doc(item.id)
//                       //     .collection('barcodes')
//                       //     .doc(item['barcodes'][i].barcode)
//                       //     .set(mapBarcode)
//                       //     .then((value) => print('success'));
//                       // }

//                       //
//                       // });
//                       // });
//                     }
//                   }
//                 }
//               });
//             } catch (e) {
//               print('####eror e>>${e.toString()}');
//               print('###error item >>${item['name']}');
//             }
//             _index++; // end.

//           }

//           if (_index == event.docs.length) {
//             setState(() {
//               loading = false;
//             });
//             print('####_index>>>$_index');
//           }
//         }
//       });
//     });

//     //for 1st
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // freshDataByCategory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Syn Data By Group'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 40,
//           ),
//           // Text('อัพเดท ${runnigNumber.toString()} Records'),
//           Wrap(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   '001 =ของใช้อื่นๆ ,002=ข้าวสาร/เครื่องปรุง/อาหารแห้ง ,003=ขนม,004=เครื่องดื่ม/นม,005=แอลกอฮอล์,006=บุหรี่,007=สินค้า แลกเปลี่ยน,008=พลาสติก/ถุง/โฟม',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Column(
//             children: status.map((item) {
//               return ListTile(
//                 onTap: () {
//                   setState(() {
//                     selectedType = item;
//                   });
//                 },
//                 leading: selectedType == item
//                     ? Icon(
//                         Icons.check_box,
//                         color: Colors.green[700],
//                       )
//                     : Icon(Icons.check_box_outline_blank),
//                 title: Text(
//                   item,
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//               );
//             }).toList(),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           loading
//               ? Container(
//                   child: Text(
//                     'ระบบกำลังซิงค์ข้อมูลครับ....',
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red),
//                   ),
//                 )
//               : Container(),
//           selectedType == 'start'
//               ? Container()
//               : RaisedButton.icon(
//                   onPressed: () {
//                     updateProductByGroup(selectedType);
//                   },
//                   icon: Icon(Icons.check, size: 32, color: Colors.green[800]),
//                   label: Text(
//                     'Sync DATA',
//                     style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[800]),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
