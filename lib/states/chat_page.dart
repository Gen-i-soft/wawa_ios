import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:wawa/src/widget/customer_chat.dart';
import 'package:wawa/src/widget/employee_chat.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Helper helper = Helper();
  final dbRef = FirebaseFirestore.instance;
  TextEditingController ctrlMessage = TextEditingController();
  ScrollController? listController;
  String? uid;

  Future callEmployee() async {}

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
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future sendMessage(String message) async {
    //String _uId = await helper.getStorage('uid');
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        String? _uid = event!.uid;
        String? _email = event.email;
        print('####_uid Future_sendMessage>>>$_uid');

         QuerySnapshot qsBackend = await dbRef
              .collection('wawastore')
              .doc('wawastore')
              .collection('backend')
              .where('uid', isEqualTo: _uid)
              .get();


        try {
          await dbRef
              .collection('wawastore')
              .doc('wawastore')
              .collection('chat')
              .doc(_uid)
              .collection('messages')
              .add({
            "isOpened": false,
            "message": message,
            "time": DateTime.now().millisecondsSinceEpoch,
            "uid": _uid,
            "email": _email,
            "displayName": qsBackend.docs[0]['displayName'],
            "type": "CUSTOMER"
          });

          //chat-dashboard

          QuerySnapshot qsDasboard = await dbRef
              .collection('wawastore')
              .doc('wawastore')
              .collection('chats-dashboard')
              .where('orderId', isEqualTo: _uid)
              .get();

          if (qsDasboard.docs.isEmpty) {
            //create
            await dbRef
                .collection('wawastore')
                .doc('wawastore')
                .collection('chats-dashboard')
                .add({
              "isOpened": false,
              "message": message,
              "orderId": _uid,
              "email": _email,
              "displayName": qsBackend.docs[0]['displayName'],
              "time": DateTime.now().millisecondsSinceEpoch,
            });
          } else {
            //update
            await dbRef
                .collection('wawastore')
                .doc('wawastore')
                .collection('chats-dashboard')
                .doc(qsDasboard.docs[0].id)
                .update({
              "message": message,
              "time": DateTime.now().millisecondsSinceEpoch,
              "isOpened": false,
            });
          }

          if (listController!.hasClients) {
            listController!.jumpTo(listController!.position.maxScrollExtent);
          }
        } catch (e) {
          print(e.toString());
        }
      });
    });
  }

  Future<void> readMsg() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event!.uid.isEmpty || event.uid == null || event.uid == '') {
          Navigator.of(context).pushNamed('/authen');
        }
        String _uid = event.uid;
        // String _email = event.email;
        try {
          //set read message Employee
          QuerySnapshot snpEMPLOYEE = await dbRef
              .collection('wawastore')
              .doc('wawastore')
              .collection('chat')
              .doc(_uid)
              .collection('messages')
              .where('type', isEqualTo: 'EMPLOYEE')
              .where('uid', isEqualTo: _uid)
              .get();

          if (snpEMPLOYEE.docs.isNotEmpty) {
            for (var item in snpEMPLOYEE.docs) {
              await dbRef
                  .collection('wawastore')
                  .doc('wawastore')
                  .collection('chat')
                  .doc(_uid)
                  .collection('messages')
                  .doc(item.id)
                  .update({
                "isOpened": true,
                "openTime": DateTime.now().millisecondsSinceEpoch
              });
            }
          }
        } catch (e) {
          print('###Error-readMsg()>>>${e.toString()}');
        }
      });
    });
  }

  @override
  void initState() {
    // final fbm = FirebaseMessaging();
    // fbm.requestNotificationPermissions();
    // fbm.configure(onMessage: (msg) {
    //   print(msg);
    //   return;
    // }, onLaunch: (msg) {
    //   print(msg);
    //   return;
    // }, onResume: (msg) {
    //   print(msg);
    //   return;
    // });

    readMsg();
    super.initState();
    listController = ScrollController(keepScrollOffset: true);
    //findUid();
  }

  // Future<Null> notificationToAdmin(String message) async {
  //   //find token
  //   // String _uId = await helper.getStorage('uid');
  //   QuerySnapshot qsDasboard = await dbRef
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('backend')
  //       .where('typeUser', isEqualTo: 'admin')
  //       .get();
  //   int index = 0;
  //   for (var item in qsDasboard.docs) {
  //     String _token = item['token'];
  //
  //     // print('_token>>>>$_token');
  //     String title = 'WAWA SHOP มีข้อความใหม่จากลูกค้าครับ';
  //     String body = message;
  //     String url =
  //         'http://103.129.14.34/wawastore/apiNotification.php?isAdd=true&token=$_token&title=$title&body=$body';
  //     sendNotificationToMe(url);
  //
  //     index++;
  //   }
  //   print('จำนวนที่ส่งเท่ากับ $index');
  // }
  //
  // Future<Null> sendNotificationToMe(String urltoken) async {
  //   await Dio().get(urltoken).then((value) {
  //     print('ส่งข้อความสำเร็จจ้า');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //new uid
    uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomPadding: true,
        // resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextFormField(
            controller: ctrlMessage,
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: 'พิมพ์ข้อความ...',
                contentPadding: const EdgeInsets.all(10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (ctrlMessage.text.isNotEmpty) {
                      String message = ctrlMessage.text;
                      print('message>>>$message');
                      sendMessage(message);
                      setState(() {
                        ctrlMessage.clear();
                      });

                      //notify admin
                    //  notificationToAdmin(ctrlMessage.text);
                    }
                  },
                )),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.chat,
                    color: Colors.pink,
                    size: 32,
                  ),
                  Text(
                    'แชทกับผู้ขาย',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // FlatButton.icon(
                  //   onPressed: () {
                  //     callEmployee();
                  //   },
                  //   icon: Icon(
                  //     Icons.alarm,
                  //     color: Colors.pink,
                  //   ),
                  //   label: Text(
                  //     'กดเรียกพนักงาน',
                  //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: dbRef
                    .collection('wawastore')
                    .doc('wawastore')
                    .collection('chat')
                    .doc(uid)
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return MyStyle().showProgress();

                  //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
                  if (snapshot.hasError) {
                    print(snapshot.error);

                    return Text('${snapshot.error}');
                  }
                  return ListView(
                    controller: listController,
                    children: snapshot.data!.docs.map((document) {
                      return document['type'] == 'CUSTOMER'
                          ? CustomerChatItem(
                              message: document,
                            )
                          : EmployeeChatItem(
                              message: document,
                            );
                    }).toList(),
                  );
                },

                // children: snapshot.data.docs.length > 0
              ),
            ),
          ],
        ));
  }
}
