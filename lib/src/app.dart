// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:wawa/router.dart';
// import 'screen/home_page.dart';

// class MyLine extends StatelessWidget {
//   Widget build(BuildContext context) {
//        SystemChrome.setPreferredOrientations(<DeviceOrientation>[
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown
//     ]);
//     return MaterialApp(
//            builder: (context, child) => MediaQuery(
//             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//             child: child),
//             localizationsDelegates: [
//    GlobalMaterialLocalizations.delegate,
//    GlobalWidgetsLocalizations.delegate, 
//    //แคะไม่ตรงก็ไม่ได้จ้า .yaml
//  ],
//   supportedLocales: [
//    Locale('th','TH')
//  ],
// // R
//       theme: ThemeData(
//       primaryColor: Color(0xffB7B7B7), fontFamily: 'Angsa'
//       ),
//       home: DefaultTabController(
//         length: 1,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Login with LINE'),
//             bottom: TabBar(
//               tabs: [
//                 Tab(icon: Icon(Icons.account_box,size: 16,),
//                 child: Text('ข้อมูลผู้ใช้งาน',style: TextStyle(
//                   fontWeight: FontWeight.bold,fontSize: 16
//                 ),),),
//                 //   Tab(icon: Icon(Icons.vpn_key, size: 16,),
//                 // child: Text('เข้าใช้งาน',style: TextStyle(
//                 //   fontWeight: FontWeight.bold,fontSize: 16
//                 // ),),),
//                 // Tab(text: 'เข้าใช้งานแอป'),
//               ],
//               indicatorColor: null,
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               Center(
//                 child: HomePageLine(),
//               ),
//               // Center(
//               //   child: APIPage(),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }