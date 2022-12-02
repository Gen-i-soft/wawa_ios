// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';
// import 'package:wawa/models/producttwo.dart';
// import 'package:wawa/utility/my_style.dart';

// class ProductManage extends StatefulWidget {
//   @override
//   _ProductManageState createState() => _ProductManageState();
// }

// class _ProductManageState extends State<ProductManage> {
//   //params
//   List<ProductTwoModel> products = [];
//   double screen;
//   ScrollController scrollController = ScrollController();
//   int amountListView = 6;
//   final dbRef = FirebaseFirestore.instance;

//   //method
//   Future<Null> getProduct() async {
//     try {
//       // await Firebase.initializeApp().then((value) async {
//       await dbRef
//           .collection('wawastore')
//           .doc('wawastore')
//           .collection('product')
//           .snapshots()
//           .listen((event) async {
//         //listen ได้ปะ
//         for (var item in event.docs) {
//           ProductTwoModel model = ProductTwoModel.fromMap(item.data());
//           setState(() {
//             products.add(model);
//           });
//         }
//         // มี สองแบบเองจ้า
//       });
//       // });
//     } catch (e) {
//       print('e==>>${e.toString()}');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getProduct();

//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         amountListView = amountListView + 4;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     screen = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'ข้อมูลสินค้า',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: products.length == 0
//           ? MyStyle().showProgress()
//           : SafeArea(
//               child: Column(
//               children: [Row(), buildListView()],
//             )),
//     );
//   }

//   ListView buildListView() {
//     return ListView.builder(
//       controller: scrollController,
//       padding: EdgeInsets.all(8),
//       shrinkWrap: true,
//       physics: ScrollPhysics(),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         return Card(
//           color: index % 2 == 0 ? Colors.white : Colors.grey[100],
//           child: Column(
//             children: [
//               Container(
//                 width: screen * 0.8 - 5,
//                 height: 60,
//                 child: CachedNetworkImage(
//                   imageUrl: products[index].urlImage,
//                   width: 80,
//                   height: 40,
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
