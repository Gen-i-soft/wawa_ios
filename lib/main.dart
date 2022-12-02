import 'dart:async';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wawa/helper/horizontal_scroll.dart';
//import 'package:upgrader/upgrader.dart';

import 'package:wawa/router.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';

String? initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBW9u5-h1OXUfYaWVxHybdtGRjK2rWMEJE",
          appId: "1:606093261383:web:aa5334d3a386c0ddf4cf62",
          messagingSenderId: "606093261383",
          projectId: "wawastore-96761"));
  initialRoute = '/home';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Future<Null> sleepTime() async {
  //   Duration duration = Duration(seconds: 3);
  //   await Timer(duration, () {
  //     initialRoute = '/home';

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //Upgrader().clearSavedSettings();
    // sleepTime();

    // On Android, setup the Appcast.
    // On iOS, the default behavior will be to use the App Store version of
    // the app, so update the Bundle Identifier in example/ios/Runner with a
    // valid identifier already in the App Store.
    // final appcastURL = 'http://103.129.14.34/wawastore/wawa.xml';
    // final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    // SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown
    // ]);
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate, //แคะไม่ตรงก็ไม่ได้จ้า .yaml
      // ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('th', 'TH'), Locale('en', 'US')],
      theme: ThemeData(primaryColor: const Color(0xffB7B7B7), fontFamily: 'Angsa'),
      debugShowCheckedModeBanner: false,
      routes: map,
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Row(
      //       children: [
      //         Image.network(
      //           'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
      //           width: 32,
      //         ),
      //         SizedBox(
      //           width: 4,
      //         ),
      //         Text(
      //           'WAWA',
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //         SizedBox(
      //           width: 6,
      //         )
      //       ],
      //     ),
      //   ),
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).pushNamed('/home');
      //     },
      //     child: Icon(Icons.next_plan_outlined),
      //   ),
      //   body: Column(
      //     children: [
      //       UpgradeAlert(
      //           appcastConfig: cfg,
      //           debugLogging: true,
      //           child: Center(child: Text('ระบบแอปพลิเคชัน WAWA SHOP',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)))),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       RaisedButton.icon(
      //           onPressed: () {
      //             Navigator.of(context).pushNamed('/home');
      //           },
      //           icon: Icon(
      //             Icons.navigate_next_outlined,
      //             size: 32,
      //           ),
      //           label: Text('ไปที่หน้าจอหลัก',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),))
      //     ],
      //   ),
      // ),

      initialRoute: initialRoute,
    );
  }
}
