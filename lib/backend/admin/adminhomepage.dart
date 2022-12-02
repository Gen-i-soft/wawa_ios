import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wawa/backend/admin/adminchat.dart';
import 'package:wawa/backend/admin/adminorder.dart';
import 'package:wawa/backend/admin/edit_user.dart';
import 'package:wawa/backend/admin/search.dart';
import 'package:wawa/states/create_account.dart';
import 'package:wawa/states/home.dart';
import 'package:wawa/syn_data_by_range.dart';
import 'package:wawa/syn_data_by_range_two.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/widget/productitembox.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  String? name;
  bool superAdmin = false;

  int selectedIndex = 0;
  List pages = [AdminOrderPage(), AdminChatPage()];

  // Future logout() async {
  //   // await Firebase.initializeApp().then((value) async {
  //   await FirebaseAuth.instance.signOut().then((value) {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Authen(),
  //         ),
  //         (route) => false);
  //   });
  //   // });
  // }

  Future checkLogin() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
          name = event.displayName;
          // if(email == 'lek2@g.com' ){
          //   setState(() {
          //     superAdmin = true;
          //   });
          // }

          if(email == 'wawa@w.com' ){
            setState(() {
              superAdmin = true;
            });
          }

          if(email == 'wawa@wawa.com' ){
            setState(() {
              superAdmin = true;
            });
          }
        });

        QuerySnapshot qsUser = await FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('backend')
            .where('uid', isEqualTo: event!.uid)
            .get();

        // if (qsUser.docs.length > 0) {
        //   if (qsUser.docs[0].data().containsKey('superAdmin'))
        //     setState(() {
        //       superAdmin = qsUser.docs[0]['superAdmin'];
        //       // emmail = qsUser.docs[0]['email'];
        //       // // emCode = snapshot.docs[0]['employeeCode'];
        //       // codeSML = qsUser.docs[0]['employeeCode'].toString().toUpperCase();
        //       // emTel = qsUser.docs[0]['tel'];
        //     });

        //   //
        //   // helper.setStorage('emTel', emTel);
        // }
      });
    });
  }

  Future<void> confirmSynAllData() async {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'อัพเดทข้อมูล',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400]),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 32,
                          color: Colors.orange[400],
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800]),
                        ),
                      ),
                      //  RaisedButton.icon(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => SetStatusOKToFalsePage(),
                      //     ));

                      //     // if (lat1 == 0) {
                      //     //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                      //     //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                      //     // } else {
                      //     //   // normalDialog(
                      //     //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                      //     // }
                      //   },
                      //   icon: Icon(Icons.check,
                      //       size: 32, color: Colors.green[400]),
                      //   label: Text(
                      //     'set statusOK to false',
                      //     style: TextStyle(
                      //         fontSize: 32,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.green[800]),
                      //   ),
                      // ),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SyncDataByRange(),
                          ));

                          // if (lat1 == 0) {
                          //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                          //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                          // } else {
                          //   // normalDialog(
                          //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                          // }
                        },
                        icon: Icon(Icons.check,
                            size: 32, color: Colors.green[400]),
                        label: Text(
                          'ตกลง',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800]),
                        ),
                      ),
                      // RaisedButton.icon(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => SynDataToFirebase(),
                      //     ));

                      //     // if (lat1 == 0) {
                      //     //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                      //     //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                      //     // } else {
                      //     //   // normalDialog(
                      //     //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                      //     // }
                      //   },
                      //   icon: Icon(Icons.check,
                      //       size: 32, color: Colors.green[400]),
                      //   label: Text(
                      //     'ยืนยัน',
                      //     style: TextStyle(
                      //         fontSize: 32,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.green[800]),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future<void> confirmSynAllDataTwo() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เพืิ่มรายการสินค้า',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[400]),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 32,
                      color: Colors.orange[400],
                    ),
                    label: Text(
                      'ยกเลิก',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800]),
                    ),
                  ),
                  //  RaisedButton.icon(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => SetStatusOKToFalsePage(),
                  //     ));

                  //     // if (lat1 == 0) {
                  //     //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                  //     //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                  //     // } else {
                  //     //   // normalDialog(
                  //     //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                  //     // }
                  //   },
                  //   icon: Icon(Icons.check,
                  //       size: 32, color: Colors.green[400]),
                  //   label: Text(
                  //     'set statusOK to false',
                  //     style: TextStyle(
                  //         fontSize: 32,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.green[800]),
                  //   ),
                  // ),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SyncDataByRangeTwo(),
                      ));

                      // if (lat1 == 0) {
                      //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                      //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                      // } else {
                      //   // normalDialog(
                      //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                      // }
                    },
                    icon: Icon(Icons.check,
                        size: 32, color: Colors.green[400]),
                    label: Text(
                      'ตกลง',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                  ),
                  // RaisedButton.icon(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => SynDataToFirebase(),
                  //     ));

                  //     // if (lat1 == 0) {
                  //     //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                  //     //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                  //     // } else {
                  //     //   // normalDialog(
                  //     //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                  //     // }
                  //   },
                  //   icon: Icon(Icons.check,
                  //       size: 32, color: Colors.green[400]),
                  //   label: Text(
                  //     'ยืนยัน',
                  //     style: TextStyle(
                  //         fontSize: 32,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.green[800]),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> confirmSynById() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Wrap(
                children: [
                  Text(
                    'ยืนยันการอัพเดทข้อมูลที่ละรายการ',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700]),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 32,
                          color: Colors.orange[400],
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800]),
                        ),
                      ),
                      // RaisedButton.icon(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => SynDataSearchById(),
                      //     ));
                      //
                      //     // if (lat1 == 0) {
                      //     //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                      //     //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                      //     // } else {
                      //     //   // normalDialog(
                      //     //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');
                      //
                      //     // }
                      //   },
                      //   icon: Icon(Icons.check,
                      //       size: 32, color: Colors.green[400]),
                      //   label: Text(
                      //     'ยืนยัน',
                      //     style: TextStyle(
                      //         fontSize: 32,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.green[800]),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Row(
            children: [
              SizedBox(
                  width: 60,
                  height: 60,
                  child: ProductItemBox(
                      imageurl:
                          'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
                      width: 50,
                      height: 50)),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'ระบบจัดการหลังบ้าน WAWA SHOP****',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.exit_to_app),
            //   onPressed: () {
            //     logout();
            //   },
            // ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey.shade500,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black45
                ),
                accountName: Text(name ?? "@admin"),
                accountEmail: Text(email ?? "admin@demo.com"),
                currentAccountPicture: Container(
                  child: ProductItemBox(
                      imageurl:
                          'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
                      width: 60,
                      height: 60),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.folder_open, color: Colors.black),
                title: const Text(
                  'ข้อมูลสินค้า',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_right, color: Colors.black),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchAdmin(),
                  ));
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditUserPage(),
                  ));
                },
                leading: const Icon(Icons.category, color: Colors.black),
                title: const Text(
                  'จัดการข้อมูลผู้ใช้งาน',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                trailing: const Icon(Icons.arrow_right, color: Colors.black),
              ),
              // ListTile(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => SyncDataByRange(),
              //     ));
              //   },
              //   leading: Icon(Icons.home, color: Colors.blue[700]),
              //   title: Text(
              //     'Sync Admin',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.blue[700]),
              //   ),
              //   trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              // ),
              // ListTile(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => SyncDataCentre(),
              //     ));
              //   },
              //   leading: Icon(Icons.home, color: Colors.blue[700]),
              //   title: Text(
              //     'Sync Data',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.blue[700]),
              //   ),
              //   trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              // ),

              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateAccount(),
                  ));
                },
                leading:
                    Icon(Icons.supervised_user_circle, color: Colors.black),
                title: Text(
                  'ลงทะเบียนลูกค้าใหม่',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black),
              ),
              // ListTile(
              //   leading: Icon(Icons.folder_open, color: Colors.blue[700]),
              //   title: Text(
              //     'ข้อความลูกค้า(อ่านแล้ว)',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.blue[700]),
              //   ),
              //   trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => AdminChatReaded(),
              //     ));
              //   },
              // ),

              superAdmin
                  ? ListTile(
                      onTap: () {
                        confirmSynAllData();
                      },
                      leading: const Icon(Icons.cloud_download_outlined,
                          color: Colors.black),
                      title: const Text(
                        'Sync Data',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      trailing:
                          const Icon(Icons.arrow_right, color: Colors.black),
                    )
                  : const SizedBox(),

             ListTile(
                onTap: () {
                  confirmSynAllDataTwo();
                },
                leading: const Icon(Icons.list_alt_rounded,
                    color: Colors.black),
                title: const Text(
                  'เพิ่มรายการสินค้า/อัพเดทรายการสินค้า',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                trailing:
                const Icon(Icons.arrow_right, color: Colors.black),
              ),
                 // : SizedBox(),

              // superAdmin
              //     ?
              // ListTile(
              //   onTap: () {
              //     // confirmSynAllData();
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => SynByCode(),
              //     ));
              //   },
              //   leading: Icon(Icons.cloud_download_outlined,
              //       color: Colors.blue[700]),
              //   title: Text(
              //     'Sync Data by ที่ละรายการสินค้า',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.blue[700]),
              //   ),
              //   trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              // ),
              //: SizedBox(),
              // superAdmin
              //       ?   ListTile(
              //     onTap: () {

              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => ProductNoPricePage(),
              //           ));
              //       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductNoPricePage,));
              //     },
              //     leading: Icon(Icons.cloud_download, color: Colors.blue[700]),
              //     title: Text(
              //       'รายการที่ไม่มีราคากลาง',
              //       style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.blue[700]),
              //     ),
              //     trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              //   ): SizedBox(),
              //  superAdmin
              //     ?   ListTile(
              //   onTap: () {

              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => SynPriceZero(),
              //         ));
              //     //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductNoPricePage,));
              //   },
              //   leading: Icon(Icons.cloud_download, color: Colors.blue[700]),
              //   title: Text(
              //     'Sync By Group Price0',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.blue[700]),
              //   ),
              //   trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              // ): SizedBox(),

              ListTile(
                leading:
                    const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                title: const Text(
                  'หน้าร้าน',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(onAdItem: (){},),
                  ));
                },
              ),
              MyStyle().buildSignOut(context)
            ],
          ),
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black45,
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'ออเดอร์สินค้า'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat), label: 'ข้อความลูกค้า'),
              // BottomNavigationBarItem(
              // icon: Icon(Icons.call), title: Text('ลูกค้าเรียก')),
            ]));
  }
}
