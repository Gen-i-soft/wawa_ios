// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:wawa/backend/admin/adminhomepage.dart';
// import 'package:wawa/models/product_null_model.dart';
// import 'package:wawa/utility/my_style.dart';

// class ProductNullPrice0 extends StatefulWidget {
//   @override
//   _ProductNullPrice0State createState() => _ProductNullPrice0State();
// }

// class _ProductNullPrice0State extends State<ProductNullPrice0> {
//   List<ProductNullModels> productModels = [];
//   bool loading = true;
//   Future<Null> getProduct() async {
//     setState(() {
//       productModels.clear();
//     });
//     await FirebaseFirestore.instance
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('productprice0')
//         .orderBy('cell')
//         .snapshots()
//         .listen((event) {
//       for (var item in event.docs) {
//         ProductNullModels model = ProductNullModels.fromMap(item.data());
//         setState(() {
//           productModels.add(model);
//         });
//       }
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     getProduct();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.home),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AdminHomePage(),
//                 ),
//                 (route) => false);
//           },
//         ),
//         body: loading ? MyStyle().showProgress()   : Padding(
//           padding: const EdgeInsets.only(left: 30, top: 30, right: 20),
//           child: ListView.builder(
//             shrinkWrap: true,
//             physics: ScrollPhysics(),
//             itemCount: productModels.length,
//             itemBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                       flex: 1,
//                       child: Text('${index + 1}.  ${productModels[index].code}',
//                           style: TextStyle(fontSize: 30))), //
//                   Expanded(
//                       flex: 1,
//                       child: Text(productModels[index].cell,
//                           style: TextStyle(
//                             fontSize: 30,
//                           )))
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
