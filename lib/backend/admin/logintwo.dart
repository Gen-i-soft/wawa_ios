// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:wawa/utility/my_style.dart';

// import '../../utility/dialog.dart';
// import 'adminhomepage.dart';

// class LoginTwo extends StatefulWidget {
//   @override
//   _LoginTwoState createState() => _LoginTwoState();
// }

// class _LoginTwoState extends State<LoginTwo> {
//   Future<Null> checkLogin() async {
//     await Firebase.initializeApp().then((value) async {
//       await FirebaseAuth.instance.authStateChanges().listen((event) async {
//         if (event != null) {
//           String _uid = event.uid;

//           QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//               .collection('wawastore')
//               .doc('wawastore')
//               .collection('backend')
//               .where('uid', isEqualTo: _uid)
//               .get();

//           // .listen((event) {
//           //listen ได้เหรอจ๊ะ  ทดสอบ
//           // TypeUserModel model = TypeUserModel.fromMap(event.data);
//           if (querySnapshot.docs[0].data().length> 0) {

//               if (querySnapshot.docs[0]['typeUser'] == 'admin') {
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AdminHomePage(),
//                     ),
//                     (route) => false);
//               } else {
//                 print('i go to this!');
//                 Navigator.of(context).pop();
//                 normalDialog(context, 'ไม่สามารถเข้าระบบหลังบ้านได้',
//                     'Userของคุณไม่มีสิทธิ์เข้าใช้เมนูนี้ครับ');
//               }

//           } else {
//             Navigator.of(context).pop();
//           }
//         } else {
//           Navigator.of(context).pop();
//         }
//       });
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//    // checkLogin();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Column(
//         children: [
//           Container(
//             width: 300,
//             height: 300,
//             child: MyStyle().showProgress(),
//           ),
//           Text(
//             'กำลังเช็คสิทธิ์การเข้าถึงระบบหลังบ้าน...',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//         ],
//       )),
//     );
//   }
// }
