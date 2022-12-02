// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';
// import 'package:wawa/models/catigory_model.dart';
// import 'package:wawa/states/sub_catigory.dart';
// import 'package:wawa/utility/my_style.dart';


// class ShowCatigory extends StatefulWidget {
//   @override
//   _ShowCatigoryState createState() => _ShowCatigoryState();
// }

// class _ShowCatigoryState extends State<ShowCatigory> {
//   List<Widget> widgets = List();
//   List<String> idDocs = List();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     readAllCatigory();
//   }

//   Future<Null> readAllCatigory() async {
//     // if (catigoryModels.length != 0) {
//     //   catigoryModels.clear();
//     // }
//     // await Firebase.initializeApp().then((value) async {
//       await Firestore.instance
//           .collection('MainCatigory')
//           .orderBy('name')
//           .snapshots()
//           .listen((event) {
//         int index = 0;
//         for (var item in event.documents) {
//           CatigoryModel model = CatigoryModel.fromMap(item.data);
//           print('name=${model.name}');
//           String idDoc = item.documentID;
//           idDocs.add(idDoc);
//           setState(() {
//             // catigoryModels.add(model);
//             widgets.add(createWidget(model, index));
//           });
//           index++;
//         }
//       });
//     // });
//   }

//   Widget createWidget(CatigoryModel model, int index) {
//     String detail = model.detail;
//     if (detail?.isEmpty ?? true) {
//       detail = '?';
//     }
//     return GestureDetector(
//       onTap: () {
//         print('You Click idex=$index');
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SubCatigory(
//                 idDoc: idDocs[index],
//               ),
//             ));
//       },
//       child: Card(
//         child: Column(
//           children: [Text(model.name), Text(detail)],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widgets.length == 0 ? MyStyle().showProgress() : buildGridView(),
//     );
//   }

//   GridView buildGridView() {
//     return GridView.extent(
//       maxCrossAxisExtent: 160,
//       children: widgets,
//     );
//   }
// }
