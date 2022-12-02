import 'package:flutter/material.dart';
import 'package:wawa/authen.dart';
import 'package:wawa/backend/admin/admin_login.dart';
import 'package:wawa/extra/authentwo.dart';
//import 'package:wawa/states/home.dart';


import 'package:wawa/states/home.dart';

// import 'src/app.dart';
// import 'states/home.dart';
// import 'states/home.dart';


final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/authen2': (BuildContext context) => AuthenTwo(),
  // '/homePage': (BuildContext context) => HomePage(),
  '/home': (BuildContext context) => HomePage(onAdItem: (){},),
  //  '/adminlogin': (BuildContext context) => AdminLoginPage(),
 
};
