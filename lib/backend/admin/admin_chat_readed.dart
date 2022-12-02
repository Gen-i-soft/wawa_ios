// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:wawa/backend/admin/chatadminpage.dart';
// import 'package:wawa/utility/helper.dart';
// import 'package:wawa/utility/my_style.dart';

// class AdminChatReaded extends StatefulWidget {
//   @override
//   _AdminChatReadedState createState() => _AdminChatReadedState();
// }

// class _AdminChatReadedState extends State<AdminChatReaded> {
//   //params

//   final dbRef = FirebaseFirestore.instance;
//   Helper helper = new Helper();

//   Future setMessageOpened(DocumentSnapshot document) async {
//     //่อ่านแล้ว
//     await dbRef
//         .collection('wawastore')
//         .doc('wawastore')
//         .collection('chats-dashboard')
//         .doc(document.id)
//         .update({
//       // "isOpened": true,
//       "openTime": new DateTime.now().millisecondsSinceEpoch
//     });
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('คลังข้อความลูกค้า'),),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
//             child: Row(
//               children: [
//                 Icon(Icons.chat_bubble),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'ข้อความลูกค้าที่อ่านแล้ว',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//             stream: dbRef
//                 .collection('wawastore')
//                 .doc('wawastore')
//                 .collection('chats-dashboard')
//                 .where('isOpened', isEqualTo: true)
//                 .orderBy('time', descending: false)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.data == null) return MyStyle().showProgress();

//               if (snapshot.hasError) {
//                 print(snapshot.error);
//                 return Text('เกิดข้อผิดพลาด');
//               }
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                   return MyStyle().showProgress();

//                   break;
//                 default:
//                   return ListView(
//                     children: snapshot.data.docs.map((document) {
//                       DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//                           document['time']);

//                       return Container(
//                         color: Colors.orange[50],
//                         child: ListTile(
//                           onTap: () {
//                             setMessageOpened(document);
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => ChatAdminPage(
//                                 document: document,
//                               ),
//                             ));
//                           },
//                           leading: CircleAvatar(
//                             child: Icon(
//                               Icons.chat,
//                               color: Colors.white,
//                             ),
//                             backgroundColor: Colors.orange[600],
//                           ),
//                           title: Text('${document['message']}'),
//                           subtitle: Text('ไอดีลูกค้า: ${document['orderId']}'),
//                           trailing: Text('${helper.timestampToTime(date)} น.'),
//                         ),
//                       );
//                     }).toList(),
//                   );
//               }
//             },
//           )),
//         ],
//       ),
//     );
//   }
// }
