// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:wawa/models/linemodels.dart';
// import 'package:wawa/src/screen/ok.dart';
// import 'package:wawa/utility/helper.dart';

// class APIPage extends StatefulWidget {
//   @override
//   _APIPageState createState() => _APIPageState();
// }

// class _APIPageState extends State<APIPage> {
//   Helper helper = new Helper();
//   final dbRef = Firestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _result;
//   String _error;

//   @override
//   void initState() {
//     super.initState();
//     _result = '';
//     _error = '';
//     _getAPIs();
//   }

//   Future<Null> registerThread(LineModels models) async {
//     //check loginmap

//     String _userId = models.userId;
//     try {
//       QuerySnapshot qsDashboard = await dbRef
//           .collection('wawastore')
//           .document('wawastore')
//           .collection('loginmap')

//           // .orderBy('getno', descending: true)
//           // .limit(1)
//           .where('uidLine', isEqualTo: _userId)
//           .getDocuments();
//       if (qsDashboard.documents.length > 0) {
//         String _uID = qsDashboard.documents[0]['uID'];

//         helper.setStorage('uid', _uID);
//         helper.setStorage('displayName', models.displayName);
//         helper.setStorage('email', '');
//         helper.setStorage('phoneNumber', '');
//         helper.setStorage('photoURL', models.pictureUrl);
//         helper.setStorage('isLINE', 'Yes');
//         Navigator.pushNamedAndRemoveUntil(
//             context, '/homePage', (route) => false);
//       } else {
//         await _auth.signInAnonymously().then((value) async {
//           try {
//             await dbRef
//                 .collection('wawastore')
//                 .document('wawastore')
//                 .collection('loginmap')
//                 .add({"uidLine": models.userId, "uID": value.user.uid});
//           } catch (e) {
//             print('e part add signInAnonymously >>>>>${e.toString()}');
//           }

//           helper.setStorage('uid', value.user.uid);
//           helper.setStorage('displayName', models.displayName);
//           helper.setStorage('email', '');
//           helper.setStorage('phoneNumber', '');
//           helper.setStorage('photoURL', models.pictureUrl);
//           helper.setStorage('isLINE', 'Yes');
//           Navigator.pushNamedAndRemoveUntil(
//               context, '/homePage', (route) => false);
//           // value.additionalUserInfo.username;
//           //save new maping
//         });
//       }
//     } catch (e) {
//       print('error check line ?==>>${e.toString()}');
//     }

//     //valid

//     //invalid

//     // await _auth.si
//     // signInWithCustomToken(token: uID).then((value) {
//     //      Navigator.of(context).pushAndRemoveUntil(
//     //       MaterialPageRoute(
//     //         builder: (context) => Okpage(),
//     //       ),
//     //       (route) => false);

//     // });
//     //     .createUserWithEmailAndPassword(email: user, password: password)
//     //     .then((response) {
//     //   Navigator.of(context).pushAndRemoveUntil(
//     //       MaterialPageRoute(
//     //         builder: (context) => HomePage(),
//     //       ),
//     //       (route) => false);
//     // }).catchError((response) {
//     //   String title = response.code;
//     //   String message = response.message;

//     //   //myAlert(title, message);
//     // });
//   }

//   void _setState(Map<String, dynamic> data, PlatformException error) {
//     setState(() {
//       if (data != null) {
//         _result = json.encode(data);
//         LineModels models = LineModels.fromMap(data);
//         // print('models>> $models');
//         print('userId>>>${models}');
//         registerThread(models);
//       } else {
//         _result = '';
//       }

//       if (error != null) {
//         _error = 'Error Code: ${error.code}\nError Message: ${error.message}';
//       } else {
//         _error = '';
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final apis = _getAPIs();
//     final isError = _error != '';

//     return Column(
//       children: <Widget>[
//         // Row(
//         //   children: <Widget>[
//         //     Expanded(
//         //       flex: 1,
//         //       child: Container(
//         //         padding: EdgeInsets.all(16),
//         //         child: SingleChildScrollView(
//         //           child: Text(
//         //             isError ? _error : _result,
//         //             style:
//         //                 TextStyle(color: isError ? Colors.red : Colors.green),
//         //           ),
//         //         ),
//         //         color: Color.fromARGB(30, 30, 30, 30),
//         //         height: 200,
//         //       ),
//         //     ),
//         //   ],
//         // ),
//         // Expanded(
//         //   child: ListView.separated(
//         //     separatorBuilder: (BuildContext context, int index) => Divider(),
//         //     itemCount: apis.length,
//         //     itemBuilder: (context, index) {
//         //       return ListTile(
//         //         title: Text(apis[index].name),
//         //         onTap: () {
//         //           apis[index].run();
//         //         },
//         //       );
//         //     },
//         //   ),
//         // ),
//       ],
//     );
//   }

//   // List<_APIItem>
//   _getAPIs() async {
//     // return [
//     // _APIItem('Login', () async {
//     try {
//       final result = await LineSDK.instance.getProfile();
//       _setState(result.data, null);
//     } on PlatformException catch (e) {
//       _setState(null, e);
//     }
//     // }),
//     // _APIItem('Get Current AccessToken', () async {
//     //   try {
//     //     final result = await LineSDK.instance.currentAccessToken;
//     //     _setState(result.data, null);
//     //   } on PlatformException catch (e) {
//     //     _setState(null, e);
//     //   }
//     // }),
//     // _APIItem('Refresh Token', () async {
//     //   try {
//     //     final result = await LineSDK.instance.refreshToken();
//     //     _setState(result.data, null);
//     //   } on PlatformException catch (e) {
//     //     _setState(null, e);
//     //   }
//     // }),
//     // _APIItem('Verify Access Token', () async {
//     //   try {
//     //     final result = await LineSDK.instance.verifyAccessToken();
//     //     _setState(result.data, null);
//     //   } on PlatformException catch (e) {
//     //     _setState(null, e);
//     //   }
//     // }),
//     // _APIItem('Bot Friendship Status', () async {
//     //   try {
//     //     final result = await LineSDK.instance.getBotFriendshipStatus();
//     //     _setState(result.data, null);
//     //   } on PlatformException catch (e) {
//     //     _setState(null, e);
//     //   }
//     // }),
//     // ];
//   }
// }

// class _APIItem {
//   final String name;
//   final Function run;

//   _APIItem(this.name, this.run);
// }
