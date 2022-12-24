
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wawa/authen.dart';
import 'package:wawa/backend/admin/adminhomepage.dart';
import 'package:wawa/global.dart';
import 'package:wawa/states/chat_page.dart';
import 'package:wawa/states/product_page.dart';
import 'package:wawa/states/promotion.dart';
import 'package:wawa/states/purchase.dart';
import 'package:wawa/states/searchxmax.dart';
import 'package:wawa/states/show_cart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';


class HomePage extends StatefulWidget {
  final Function onAdItem;
  HomePage({required this.onAdItem});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //params
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Helper helper = Helper();
  int selectedIndex = 0;
  double total = 0;
  int totalItems = 0;
  String? nameLogin;
  String? emailLogin;
  final dbRef = FirebaseFirestore.instance;
  // String uid = 'user';
  String? userName;
  String? userEmail;
  num noVersion = 38;

  ///***** */
  num sqliteDB = 1;
  String? typeUser;
  String? employeeCode;


  // Future<Null> _makePhoneCall(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> checkUpdate() async {
    String googleUrl =
        'https://play.google.com/store/apps/details?id=shop.appthailand.wawa';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'ไม่สามารถหน้าเว็บได้';
    }
  }

  Future<void> checkLogin() async {
    String _uid = await helper.getStorage('uid') ?? 'user';
    // String? _uid = FirebaseAuth.instance.currentUser!.uid;
    print('####_uid/show_cart.dart>>>$_uid');

    if (_uid == 'user') {
      // Navigator.of(context).pushNamed('/authen');
    } else {
      setState(() {
        uid = _uid;
      });
            QuerySnapshot qsTypeUser = await FirebaseFirestore.instance
                .collection('wawastore')
                .doc('wawastore')
                .collection('backend')
                .where('uid', isEqualTo: _uid)
                .get(); //ยัง worked in web***

            String _typeUser = qsTypeUser.docs[0]['typeUser'];
                    setState(() {
                      userName = qsTypeUser.docs[0]['displayName']; //event.displayName;
                      nameLogin = qsTypeUser.docs[0]['displayName'];
                      emailLogin = qsTypeUser.docs[0]['email'];//event.email;
                      userEmail = qsTypeUser.docs[0]['email']; //event.email;
                      employeeCode = qsTypeUser.docs[0]['employeeCode'];
                    });

      await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('customerCols')
          .where('code', isEqualTo: qsTypeUser.docs[0]['employeeCode'])
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          setState(() {
            priceLevel = value.docs[0]['priceLevel'];
          });
        }
      });

      print('####priceLevel===>>$priceLevel');

            setState(() {
              typeUser = _typeUser;
            });
            print('####typeUser>>>$typeUser');

            // print('####uid>>${event.uid}');


    }
    // await Firebase.initializeApp().then((value) async {
    //   FirebaseAuth.instance.authStateChanges().listen((event) async {
    //     if (event != null) {
    //       setState(() {
    //         uid = event.uid;  //Z0xGaVPKG1TkaQ8cOmmfapauMo42
    //         userName = event.displayName;
    //         nameLogin = event.displayName;
    //         emailLogin = event.email;
    //         userEmail = event.email;
    //         helper.setStorage('uid', event.uid);
    //
    //       });
    //
    //       QuerySnapshot qsTypeUser = await FirebaseFirestore.instance
    //           .collection('wawastore')
    //           .doc('wawastore')
    //           .collection('backend')
    //           .where('uid', isEqualTo: uid)
    //           .get(); //ยัง worked in web***
    //
    //       String _typeUser = qsTypeUser.docs[0]['typeUser'];
    //       setState(() {
    //         typeUser = _typeUser;
    //       });
    //       print('####typeUser>>>$typeUser');
    //
    //       print('####uid>>${event.uid}');
    //     } else {}
    //   });
    // });
  }

  // Future<Null> getToken() async {
  //   //FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  //   String token = await messaging.getToken();
  //   helper.setStorage('token', token!);
  //   print('###FCM token>>>>>=$token');

  //   // String token = await helper.getStorage('token');
  //   if (uid != 'user') {
  //     QuerySnapshot qsDashboard = await dbRef
  //         .collection('wawastore')
  //         .doc('wawastore')
  //         .collection('backend')
  //         .where('uid', isEqualTo: uid)
  //         .get();

  //     if (qsDashboard.docs.length > 0) {
  //       await dbRef
  //           .collection('wawastore')
  //           .doc('wawastore')
  //           .collection('backend')
  //           .doc(qsDashboard.docs[0].id)
  //           .update({"token": token});
  //     }
  //   }

  //   // await Firebase.initializeApp().then((value) async {
  //   //   await FirebaseAuth.instance.authStateChanges().listen((event) async {
  //   //     String uid = event.uid;

  //   // ไม่แทนค่าไม่ออกจ้า
  //   // await firebaseMessaging.getToken().then((value) async {

  //   // DocumentSnapshot document = await dbRef
  //   //      .collection('wawastore')
  //   //     .doc('wawastore')
  //   //     .collection('backend')
  //   //     .where('uid', isEqualTo: uid)
  //   //     .get()
  //   // print('####uid>>>$uid');
  //   // print('####qsDashboard.docs[0][token]>>>${qsDashboard.docs[0]['token']}');
  //   // print('####qsDashboard.docs[0].id>>>${qsDashboard.docs[0].id}');

  //   // if (qsDashboard.docs.length > 0) {

  //   //   for (var item in qsDashboard.docs) {
  //   //      await dbRef
  //   //         .collection('wawastore')
  //   //         .doc('wawastore')
  //   //         .collection('backend')
  //   //         .doc(item.id)
  //   //         .update({"token": value});

  //   //   }

  //   //   }

  //   //เก็บเอาไว้ใช้งาน
  //   // });
  //   //   });
  //   //  });
  // }

  Future<void> readCart() async {
    int index = 0;

    // String _uid = FirebaseAuth.instance.currentUser!.uid;
    String? _uid = await helper.getStorage('uid') ;
    print('####_uid>>>$_uid');

    if (_uid != null) {
      await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('addcart')
          .where('uid', isEqualTo: _uid)
          // .where('amounts', isGreaterThan: 0)
          .get()
          .then((QuerySnapshot qtyDocs) {
        int no = 0;
        for (var doc in qtyDocs.docs) {
          no++;
          print('####no>>>$no');
        }
        setState(() {
          totalItems = no;
        });
      }); //worked***
    }

    // print('##############>>>>readCart work ');
    // try {
    //   await SQLiteHelper().readSQLite().then((value) {
    //     int index = 0;
    //     for (var string in value) {
    //       String sumString = string.subtotals;
    //       double sumDouble = double.parse(sumString);
    //       setState(() {
    //         total = total + sumDouble;
    //       });
    //       index++;
    //     }

    //     setState(() {
    //       totalItems = index;
    //     });
    //   });
    // } catch (e) {
    //   print('########### status in SQLite ===>>> ${e.toString()}');
    // }
  }

  // Widget gotoAuthen() {
  //   //return null;
  // }

  // Future notifyUpdate() async {
  //   DocumentSnapshot document = await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('updateApp')
  //       .doc('updateApp')
  //       .get();
  //   // num noVersion = 30;  //fix
  //   // num sqliteDB = 1;  //fix
  //   print('####document[\'noVersion\']>>>${document['noVersion']}');
  //   print('####document[\'sqliteDB\']>>>${document['sqliteDB']}');
  //   if (document['noVersion'] != noVersion) {
  //     //alert notify #1
  //     getUpdate();
  //   }
  // }
  //
  // Future updateOnOff() async {
  //   QuerySnapshot qsOnOff = await dbRef
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('saleMans')
  //       .get();
  //
  //   if (qsOnOff.docs.isNotEmpty) {
  //     for (var item in qsOnOff.docs) {
  //       print('###id>>${item.id}');
  //       await dbRef
  //           .collection('wawastore')
  //           .doc('wawastore')
  //           .collection('saleMans')
  //           .doc(item.id)
  //           .update({
  //         // "password" : '000000',
  //         "onoff": true
  //       });
  //     }
  //   }
  //   // QuerySnapshot qsOnOff = await dbRef
  //   //     .collection('wawastore')
  //   //     .doc('wawastore')
  //   //     .collection('backend')
  //   //     .get();
  //   //
  //   // if(qsOnOff.docs.length > 0){
  //   //   for (var item in qsOnOff.docs) {
  //   //     print('###id>>${item.id}');
  //   //     await dbRef
  //   //         .collection('wawastore')
  //   //         .doc('wawastore')
  //   //         .collection('backend')
  //   //     .doc(item.id)
  //   //         .update({
  //   //       "password" : '000000',
  //   //       "open" : true
  //   //     });
  //   //
  //   //
  //   // }
  //   // //       for (var item in event.docs) {
  //   // //         products.add(item);
  //   // //       }
  //   // }
  // }

  @override
  void initState() {
    // TODO: implement initState
    readCart();
    //getToken();
    checkLogin();
    // notifyUpdate();
    // updateOnOff();
    getUid();
    super.initState();
    // findLogin(); >> ปรับก่อน

    // mapLineLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: GestureDetector(
          onTap: () {
            if (_scaffoldKey.currentState!.isDrawerOpen) {
              _scaffoldKey.currentState!.openEndDrawer();
            } else {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
          child: Row(
            children: [
              Image.network(
                'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
                width: 32,
              ),
              const SizedBox(
                width: 4,
              ),
               const AutoSizeText(
                'WAWA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                 maxLines: 1,
              ),

              const SizedBox(
                width: 6,
              ),

            ],
          ),
        ),
        actions: [
          //  IconButton(
          //   icon: Icon(Icons.print),
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SynDataToFirebase(),
          //         ));
          //   },
          // ),
          GestureDetector(
            onTap: () async {
              String? res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SearchXMax(onAdItem: () => readCart()),
              ));
              print('####res/SearchXMax===$res');
              if (res == null) {
                readCart();
              }

            },
            child: Row(
              children: const [
                Icon(
                  Icons.search,
                  size: 32,
                ),
                AutoSizeText(

                  'ค้นหารายการสินค้า',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  maxLines: 1,

                ),
              ],
            ),
          ),

           SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          // GestureDetector(
          //   onTap: () async {
          //     String res = await Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) =>
          //           SearchVersionTwo(onAdItem: () => readCart()),
          //     ));
          //     if (res == "save") {
          //       readCart();
          //     }
          //   },
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.search,
          //         size: 22,
          //       ),
          //       Text(
          //         'ค้นหา',
          //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   width: 5,
          // ),
          // IconButton(
          //   icon: const Icon(Icons.campaign),
          //   onPressed: () async {
          //     String res = await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Promotion(onAdItem: () => readCart()),
          //         ));
          //     if (res == 'save') {
          //       readCart();
          //     }
          //   },
          // ),
          // const SizedBox(
          //   width: 5,
          // ),
          // IconButton(
          //   icon: Icon(Icons.more_vert),
          //   onPressed: () {
          //     //
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.exit_to_app),
          //   onPressed: () {

          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => SynDataToFirebase(),
          //     ));
          //   },
          // ),
        ],
      ),

      // List pages = [
      //   ProductPage(),
      //   ShowCart(

      //   ),
      //   ChatPage(),
      //   PaymentPage()
      // ];
      body: selectedIndex == 0
          ? ProductPage(onAdItem: () async {
              return readCart();
            })
          : selectedIndex == 1
              ? ShowCart(onAdItem: () async {
                  return readCart();
                })
              : uid != 'user'
                  ? ChatPage()
                  : Container(),
      // : PaymentPage(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xffB7B7B7),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xff000000),
          unselectedItemColor: const Color(0xff7C7C7C),
          showSelectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'สั่งสินค้า',
            ),
            BottomNavigationBarItem(
              label: 'ตะกร้าสินค้า',
//0
              icon: Badge(
                shape: BadgeShape.circle,
                borderRadius: BorderRadius.circular(100),
                child: const Icon(Icons.shopping_basket),
                badgeContent: Text(
                  '$totalItems',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

//1
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'ติดต่อผู้ขาย',
            )
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.account_box),
            //   title: Text('โปรไฟล์'),
            // ),
          ]),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                uid != 'user'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Text('ผู้ใช้งาน: $userName',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          Text('อีเมล์ผู้ใช้งาน: $userEmail',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24))
                        ],
                      )
                    : Row(),
                buildStatusGood(),
                 typeUser != 'admin' ?  SizedBox() :  buildAdmin() ,
                //buildRider(),
                // uid == 'Z0xGaVPKG1TkaQ8cOmmfapauMo42' ? buildAdmin() :SizedBox(),

                // buildCheckUpdate(),
                uid != 'user' ? MyStyle().buildSignOut(context) : const SizedBox(),
                uid == 'user' ? buildUserCurrent()  : SizedBox(),
                // buildAuto(),
                // buildLike(),
                // buildShoppingBasket(),
                // buildOrderStatus(),
                // buildPromotion(),
                // buildNotificate(),
                // buildHistory(),
                // buildPersonPin(),
                // buildMessage()
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'เวอร์ชั่น Web  1.0.22',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
            // buildSingOut(),
          ],
        ),
      ),
    );
  }

  ListTile buildAuto() {
    return ListTile(
      onTap: () {
        // setState(() {});
        Navigator.pop(context);

        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => SynDataToFirebase(),
        // ));
      },
      leading: const Icon(
        Icons.autorenew,
        size: 30,
        color: Colors.black,
      ),
      title: const Text(
        'Test Sync',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }

  // ListTile buildCheckUpdate() {
  //   return ListTile(
  //     onTap: () {
  //       checkUpdate();
  //     },
  //     leading: Icon(
  //       Icons.update_outlined,
  //       size: 30,
  //       color: Colors.black,
  //     ),
  //     title: Text(
  //       'อัพเดทแอปพลิเคชัน',
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
  //     ),
  //     trailing: Icon(Icons.arrow_right),
  //   );
  // }

  ListTile buildRider() {
    return ListTile(
      onTap: () {
        // setState(() {});
        //Navigator.pop(context);

        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => Purchase(),
        // ));
      },
      leading: const Icon(
        Icons.local_shipping,
        size: 30,
        color: Colors.black,
      ),
      title: const Text(
        'Delivery',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }

  ListTile buildStatusGood() {
    return ListTile(
      onTap: () {
        // setState(() {});
        Navigator.pop(context);
        uid != 'user'
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Purchase(),
              ))
            : Navigator.of(context).pushNamed('/authen');
      },
      leading: const Icon(
        Icons.add_shopping_cart,
        size: 30,
        color: Colors.black,
      ),
      title: const Text(
        'สถานะคำสั่งซื้อ',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }

  Widget buildUserCurrent() {
    return ListTile(
      onTap: () async {
        // setState(() {});
        Navigator.pop(context);
       String res = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Authen(),
        ));

       if (res == 'success') {
         checkLogin();


       }
      },
      leading: const Icon(
        Icons.lock_outline_sharp,
        size: 30,
        color: Colors.black,
      ),
      title: const Text(
        'ลงทะเบียนเข้าใช้งาน',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }

  Widget buildAdmin() {
    return ListTile(
      onTap: () {

        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AdminHomePage(),
          //LoginTwo(),
        ));
      },
      leading: const Icon(
        Icons.account_box,
        size: 30,
        color: Colors.black,
      ),
      title: const Text(
        'ระบบจัดการหลังบ้าน',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }

  // ListTile buildLogOut() {
  //   return ListTile(
  //     onTap: () async {
  //       await FirebaseAuth.instance.authStateChanges().listen((event) async {
  //         await FirebaseAuth.instance.signOut().then((value) {
  //           // Navigator.of(context).pop();
  //           // Navigator.pushNamedAndRemoveUntil(
  //           //     context, '/authen2', (route) => false);
  //           exit(0);
  //         });
  //       });

  //       // setState(() {});
  //       // Navigator.pop(context);
  //       // exit(0);
  //       // FirebaseAuth _auth = FirebaseAuth.instance;
  //       // FirebaseUser _user = await _auth.currentUser();
  //       // if (_user != null) {
  //       //   _auth.signOut();
  //       //   Navigator.of(context).push(MaterialPageRoute(
  //       //     builder: (context) => Authen(),
  //       //   ));
  //       // }
  //       //   Navigator.of(context).pushAndRemoveUntil(
  //       //       MaterialPageRoute(
  //       //         builder: (context) => HomePage(),
  //       //       ),
  //       //       (route) => false);
  //       // }
  //     },
  //     leading: Icon(
  //       Icons.exit_to_app,
  //       size: 30,
  //       color: Colors.black,
  //     ),
  //     title: Text(
  //       'ออกจากระบบ',
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
  //     ),
  //     trailing: Icon(Icons.arrow_right),
  //   );
  // }

  Widget buildUserAccountsDrawerHeader() {
    return const Padding(
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                'images/image2.jpg',
              )),
              // gradient: LinearGradient(
              //     begin: Alignment.centerRight,
              //     end: Alignment.centerLeft,
              //     colors: [
              //       // Color(0x66ffb901),
              //       Color(0x99ffb901),
              //       // Color(0xccffb901),
              //       Color(0xffffb901)
              //     ]),
            ),
            // currentAccountPicture: Image.asset('images/LogoLARN8.png',width: 300,),
            accountName: Text(''
                //   nameLogin == null ? '' : 'Login By: $nameLogin',
                //   style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.blue[700]),
                ),
            accountEmail: Text(''

                // emailLogin == null ? '' : 'Email: $emailLogin',
                // style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blue[700]),
                ),
          ),
        ),
      ),
    );
  }

  void getUpdate() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  title: const Text('แอปพลิเคชั่นมีเวอร์ชั่นใหม่'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [Text('กรุณาอัพเดทแอปก่อนการใช้งานคะ')],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                checkUpdate();
                              },
                              icon: const Icon(
                                Icons.update_outlined,
                                size: 32,
                              ),
                              label: const Text('อัพเดท'))
                        ],
                      )
                    ],
                  ),
                )));
  }

  Future<void> getUid() async {
    String? _uid = await helper.getStorage('uid'); //worked!!**

    if (_uid != null) {
      setState(() {
        uid = _uid;
      });

      QuerySnapshot qsTypeUser = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('backend')
          .where('uid', isEqualTo: _uid)
          .get(); //ยัง worked in web***

      String _typeUser = qsTypeUser.docs[0]['typeUser'];
      setState(() {
        typeUser = _typeUser;
      });
      print('####typeUser>>>$typeUser');


    } else {}






  }
}
