// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import 'package:wawa/models/linemodels.dart';
// import 'package:wawa/states/home.dart';

// import 'package:wawa/utility/helper.dart';
// import 'package:wawa/utility/sqlite_helper.dart';
// import 'dart:convert';

// import '../theme.dart';
// import '../widget/user_info_widget.dart';

// class HomePageLine extends StatefulWidget {
//   @override
//   _HomePageLineState createState() => _HomePageLineState();
// }

// class _HomePageLineState extends State<HomePageLine>
//     with AutomaticKeepAliveClientMixin {
//   Helper helper = new Helper();
//   final dbRef = Firestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _result;
//   String _error;
//   UserProfile _userProfile;
//   String _userEmail;
//   StoredAccessToken _accessToken;
//   bool _isOnlyWebLogin = false;
//   double total = 0;
//   int totalItems = 0;

//   final Set<String> _selectedScopes = Set.from(['profile']);

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     readCart();
//   }

//   Future<Null> readCart() async {
//     print('##############>>>>readCart work ');
//     try {
//       await SQLiteHelper().readSQLite().then((value) {
//         int index = 0;
//         for (var string in value) {
//           String sumString = string.subtotals;
//           double sumDouble = double.parse(sumString);
//           setState(() {
//             total = total + sumDouble;
//           });
//           index++;
//         }

//         setState(() {
//           totalItems = index;
//         });
//       });
//     } catch (e) {
//       print('########### status in SQLite ===>>> ${e.toString()}');
//     }
//   }

//   Future<void> initPlatformState() async {
//     UserProfile userProfile;
//     StoredAccessToken accessToken;

//     try {
//       accessToken = await LineSDK.instance.currentAccessToken;
//       if (accessToken != null) {
//         userProfile = await LineSDK.instance.getProfile();
//       }
//     } on PlatformException catch (e) {
//       print(e.message);
//     }

//     if (!mounted) return;

//     setState(() {
//       _userProfile = userProfile;
//       _accessToken = accessToken;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     if (_userProfile == null) {
//       return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: <Widget>[
//             _configCard(),
//             Expanded(
//               child: Center(
//                 child:
//                     // ElevatedButton(
//                     //   style: ElevatedButton.styleFrom(
//                     //     primary: Color(0xff45F034),
//                     //     shape:
//                     //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                     //   ),
//                     // onPressed: () {
//                     //   _startLogin();
//                     // },
//                     //   child: Text(
//                     //     'เข้าใช้งานผ่านระบบไลน์',

//                     //   ),
//                     // ),

//                     RaisedButton(
//                   textColor: textColor,
//                   color: accentColor,
//                   onPressed: _signIn,
//                   child: Text('Sign In'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return UserInfoWidget(
//         userProfile: _userProfile,
//         userEmail: _userEmail,
//         accessToken: _accessToken,
//         onLoginPressed: _login,
//         onSignOutPressed: _signOut,
//       );
//     }
//   }

//   Widget _configCard() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _scopeListUI(),
//             SizedBox(
//               height: 10.0,
//             ),
//             // Row(
//             //   children: <Widget>[
//             //     Checkbox(
//             //       activeColor: accentColor,
//             //       value: _isOnlyWebLogin,
//             //       onChanged: (bool value) {
//             //         setState(() {
//             //           _isOnlyWebLogin = !_isOnlyWebLogin;
//             //         });
//             //       },
//             //     ),
//             //     Text('only Web Login'),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _scopeListUI() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Scopes: '),
//           Wrap(
//             children:
//                 _scopes.map<Widget>((scope) => _buildScopeChip(scope)).toList(),
//           ),
//         ],
//       );

//   Widget _buildScopeChip(String scope) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//         child: ChipTheme(
//           data: ChipTheme.of(context).copyWith(brightness: Brightness.dark),
//           child: FilterChip(
//             label: Text(scope, style: TextStyle(color: textColor)),
//             selectedColor: accentColor,
//             selected: _selectedScopes.contains(scope),
//             onSelected: (_) {
//               setState(() {
//                 _selectedScopes.contains(scope)
//                     ? _selectedScopes.remove(scope)
//                     : _selectedScopes.add(scope);
//               });
//             },
//           ),
//         ),
//       );

//   void _signIn() async {
//     try {
//       /// requestCode is for Android platform only, use another unique value in your application.
//       final loginOption =
//           LoginOption(_isOnlyWebLogin, 'normal', requestCode: 8192);
//       final result = await LineSDK.instance
//           .login(scopes: _selectedScopes.toList(), option: loginOption);
//       final accessToken = await LineSDK.instance.currentAccessToken;

//       final idToken = result.accessToken.idToken;
//       final userEmail = (idToken != null) ? idToken['email'] : null;

//       setState(() {
//         _userProfile = result.userProfile;
//         _userEmail = userEmail;
//         _accessToken = accessToken;
//       });
//     } on PlatformException catch (e) {
//       _showDialog(context, e.toString());
//     }
//   }

//   void _signOut() async {
//     try {
//       await LineSDK.instance.logout();
//       setState(() {
//         _userProfile = null;
//         _accessToken = null;
//       });
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//   }

//   void _login() async {
//     try {
//       final result = await LineSDK.instance.getProfile();
//       _setState(result.data, null);
//     } on PlatformException catch (e) {
//       _setState(null, e);
//     }

//     // Navigator.of(context).push(MaterialPageRoute(
//     //   builder: (context) => APIPage(),
//     // ));
//     // pushAndRemoveUntil(
//     //     MaterialPageRoute(
//     //       builder: (context) => APIPage(),
//     //     ),
//     //     (route) => false);
//   }

//   Future<Null> registerThread(LineModels models) async {
//     //check loginmap

//     String _userId = models.userId;
//     try {
//       QuerySnapshot qsDashboard = await dbRef
//           .collection('wawastore')
//           .document('wawastore')
//           .collection('backend')

//           // .orderBy('getno', descending: true)
//           // .limit(1)
//           .where('uidLine', isEqualTo: _userId)
//           .getDocuments();
//       if (qsDashboard.documents.length > 0) {
//         //old case
//         String _uID = qsDashboard.documents[0]['uid'];

//         print(
//             'qsDashboard.documents[0][uid]>>>${qsDashboard.documents[0]['uid']}');

//         helper.setStorage('uid', _uID);
//         helper.setStorage('displayName', models.displayName);
//         helper.setStorage('email', '');
//         helper.setStorage('phoneNumber', '');
//         helper.setStorage('photoURL', models.pictureUrl);
//         helper.setStorage('isLINE', 'Yes');
//         helper.setStorage('uidLine', _userId);
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => HomePage(),
//             ),
//             (route) => false);
//       } else {
//         //new case
//         await _auth.signInAnonymously().then((value) async {
//           try {
//             await dbRef
//                 .collection('wawastore')
//                 .document('wawastore')
//                 .collection('backend')
//                 .add({
//               "uidLine": models.userId,
//               "uid": value.user.uid,
//               "displayName": models.displayName,
//               "photoURL": models.pictureUrl,
//             });
//           } catch (e) {
//             print('error in  zone  signInAnonymously >>>>>${e.toString()}');
//           }

//           helper.setStorage('uid', value.user.uid);
//           helper.setStorage('displayName', models.displayName);
//           helper.setStorage('email', '');
//           helper.setStorage('phoneNumber', '');
//           helper.setStorage('photoURL', models.pictureUrl);
//           helper.setStorage('isLINE', 'Yes');
//           helper.setStorage('uidLine', models.userId);
//           Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (context) => HomePage(),
//               ),
//               (route) => false);
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

//   void _showDialog(BuildContext context, String text) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(text),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// const List<String> _scopes = <String>[
//   'profile',
//   // 'openid',
//   // 'email',
//   // 'customScope',
// ];
