import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wawa/global.dart';

//import 'package:wawa/states/syn_data_to_firebase.dart';
//import 'package:wawa/states/home.dart';

import 'package:wawa/utility/dialog.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';
//import 'package:wawa/widget/productitembox.dart';

//import 'utility/dialog.dart';
//import 'utility/dialog.dart';
//import 'utility/sqlite_helper.dart';

class AuthenTwo extends StatefulWidget {
  const AuthenTwo({Key? key}) : super(key: key);

  @override
  _AuthenTwoState createState() => _AuthenTwoState();
}

class _AuthenTwoState extends State<AuthenTwo> {
  final dbRef = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double screen = 0;
  double total = 0;
  String? user, password;
  bool statusRedEye = true;
  Map<String, dynamic>? datas;

  Helper helper = new Helper();

  void showToast(String msg) {
    // Toast.show(msg, context,
    //     backgroundColor: Colors.orange[100],
    //     textColor: Colors.orange[800],
    //     duration: 3);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange[100],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  // Future<Null> checkLogin() async {
  //   // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   FirebaseUser _user = await _auth.currentUser();
  //   if (_user != null) {
  //     // _auth.signOut();
  //     helper.setStorage('uid', _user.uid);
  //     helper.setStorage('displayName', _user.displayName);
  //     helper.setStorage('email', _user.email);

  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (context) => HomePage(),
  //         ),
  //         (route) => false);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // floatingActionButton: buildCreateAccount(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x66D2C6C6),
                Color(0x99D2C6C6),
                Color(0xccD2C6C6),
                Color(0xffD2C6C6)
              ]),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildLogo(),
                  buildUser(),
                  buildPassword(),
                  buildLogin(),
                  const SizedBox(
                    height: 10,
                  ),
                  // GestureDetector(
                  //     onTap: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => SynDataToFirebase(),
                  //       ));
                  //     },
                  //     child: Text('Syndata'))
                  // Text(
                  //   '-OR-',
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 20.0,
                  //       fontWeight: FontWeight.w600),
                  // ),
                  // buildLoginWiteLine(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // buildCreateAccount() => Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text('No Account?',
  //             style: TextStyle(
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //             )),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pushNamed(context, '/createAccount');
  //           },
  //           child: Text(
  //             '?????????????????????????????????????????????',
  //             style: TextStyle(
  //                 fontSize: 22,
  //                 color: Color(0xff71501C),
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     );

  Container buildUser() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.5,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => user = value.trim(),
        style: TextStyle(color: Colors.black, fontSize: 28),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.black38),
          hintText: '?????????????????? :',
          prefixIcon: Icon(
            Icons.email,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black45),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      // color: Colors.white,
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.5,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        obscureText: statusRedEye,
        onChanged: (value) => password = value.trim(),
        style: TextStyle(color: Colors.black, fontSize: 28),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.black38),
          hintText: '???????????????????????? :',
          prefixIcon: Icon(
            Icons.vpn_key,
          ),
          suffixIcon: IconButton(
              icon: Icon(statusRedEye
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined),
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              }),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black45),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return GestureDetector(
        onTap: () {
          //go to backend
          // Navigator.pushNamedAndRemoveUntil(
          //     context, '/adminlogin', (route) => false);
        },
        child: MyStyle().showLogo(150, 150));
  }

  // Widget buildLoginWiteLine() {
  //   return GestureDetector(
  //     onTap: () {
  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyLine(),));
  //       Navigator.pushNamedAndRemoveUntil(context, '/myline', (route) => false);
  //     },
  //     child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.green[600]),
  //         height: 60,
  //         margin: EdgeInsets.only(top: 16),
  //         width: screen * 0.7,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ProductItemBox(
  //                 imageurl:
  //                     'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fline.png?alt=media&token=b2faca8f-9842-490e-a53b-7ad34cd4b89f',
  //                 width: 50,
  //                 height: 50),
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               '??????????????????????????????????????????????????? ',
  //               style: TextStyle(
  //                   fontSize: 28,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold),
  //             )
  //           ],
  //         )

  //         // ElevatedButton(
  //         //   style: ElevatedButton.styleFrom(
  //         //     primary: Color(0xff45F034),
  //         //     shape:
  //         //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         //   ),
  //         // onPressed: () {
  //         //   _startLogin();
  //         // },
  //         //   child: Text(
  //         //     '??????????????????????????????????????????????????????????????????',

  //         //   ),
  //         // ),
  //         ),
  //   );
  // }
  //
  // Future<Null> checkList() async {
  //   await SQLiteHelper().readSQLite().then((value) {
  //     for (var item in value) {
  //       double _subtotal = double.parse(item.subtotals);
  //       double _total = 0;
  //       _total = _total + _subtotal;
  //       setState(() {
  //         total = _total;
  //       });
  //     }
  //     print('###total>>>$total');
  //   });
  //   if (total > 0) {
  //     normalDialog(context, '????????????????????????????????????????????????????????????????????????',
  //         '???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? user/password ????????????');
  //   } else {
  //     checkAuthen();
  //   }
  // }

  Widget buildLogin() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffA97474),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(
                context, '????????????????????????????????????', '????????????????????????????????????????????????????????????????????????????????????????????????');
          } else {
            //check cart is emty
            // checkList();
            checkAuthen();
            //
          }
        },
        child: Text(
          '????????????????????????????????????????????????',
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.toString(), password: password.toString())
          .then((value2) async {
      //  Navigator.of(context).pop();
        print('################################value2==>${value2.user!.uid}');
        helper.setStorage('uid', value2.user!.uid);  //set uid***
        setState(() {
          uid = value2.user!.uid;
        });
         String? token = await helper.getStorage('token');
        if (token != null){
           QuerySnapshot qsDashboard = await dbRef
        .collection('wawastore')
        .doc('wawastore')
        .collection('backend')
        .where('uid', isEqualTo: value2.user!.uid)
        .get();


        if (qsDashboard.docs.isNotEmpty) {

                await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('backend')
            .doc(qsDashboard.docs[0].id)
            .update({"token": token});


        }


        }


        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }).catchError((value3) {
        normalDialog(context, value3.code, value3.message);
      });
    });
  }
}

// try {
//   AuthResult authResult = await _auth.signInWithEmailAndPassword(
//       email: user, password: password);
//   if (authResult == null) {
//     //???????????????????????????????????????. ??????????????????
//   } else {
//     //admin ????????????????????????????????????
//     //????????????????????? ??????????????????????????????????????????????????????????????????
//     helper.setStorage('uid', authResult.user.uid);
//     helper.setStorage('displayName', authResult.user.displayName);
//     helper.setStorage('email', authResult.user.email);
//     helper.setStorage('phoneNumber', authResult.user.phoneNumber);
//     helper.setStorage('photoURL', authResult.user.photoUrl);
//     helper.setStorage('isLINE', 'No');
//     helper.setStorage('lineUserID', '');

//??????????????????????????????????????????????????????????????? backend ?????????????????????????????????????????????

// try {
//     await dbRef
//       .collection('wawastore')
//       .document('wawastore')
//       .collection('backend')
//       .document(qsDashboard.documents[0].documentID)
//       .updateData({"token": token});
// } catch (e) {
//   print('error in page authen>> ${e.toString()}');
// }

//   Navigator.pushNamedAndRemoveUntil(
//       context, '/homePage', (route) => false);
// }
// } catch (e) {
//   print('error>>${e.toString()}');
// }
//   }
// }

// String _displayName = value.user.displayName;
// String _pictureUrl = value.user.photoURL;
// String _uid = value.user.uid;
// helper.setStorage('lineUserID', 'No');
// helper.setStorage('displayName', _displayName);
// helper.setStorage('pictureUrl', _pictureUrl);
// helper.setStorage('uid', _uid); //???????????????????????????????????????????????? ???????????????????????????????????????????????????
