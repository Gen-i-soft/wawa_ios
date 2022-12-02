import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wawa/src/widget/customer_chat.dart';
import 'package:wawa/src/widget/employee_chat.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class ChatAdminPage extends StatefulWidget {
  final DocumentSnapshot document;
  ChatAdminPage({required this.document});
  @override
  _ChatAdminPageState createState() => _ChatAdminPageState();
}

class _ChatAdminPageState extends State<ChatAdminPage> {
  Helper helper = Helper();
  final dbRef = FirebaseFirestore.instance;
  TextEditingController ctrlMessage = TextEditingController();
  ScrollController? listController;
  String? uID;

  void showToast(String msg) {
    // Toast.show(msg, context,
    //     backgroundColor: Colors.orange[100],
    //     textColor: Colors.orange[800],
    //     duration: 2);
    Fluttertoast.showToast(msg: msg);
  }

  Future setMessageOpened(DocumentSnapshot document) async {
    //่อ่านแล้ว
    try {
      //update
      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('chats-dashboard')
          .doc(document.id)
          .update({
        "isOpened": true,
        "openTime": new DateTime.now().millisecondsSinceEpoch
      }).then((value) {});

      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('chats-dashboard')
          .doc(document.id)
          .snapshots()
          .listen((event) async {

      if (event.data()!.isNotEmpty) {
        //มีค่า
    QuerySnapshot  snpCustomer =  await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('chat')
            .doc(event['orderId'])
            .collection('messages')
            .where('type', isEqualTo: 'CUSTOMER')
            .get();

        if (snpCustomer.docs.isNotEmpty) {
          for (var item in snpCustomer.docs) {
            print('###item.id>>>${item.id}');
            await dbRef
                .collection('wawastore')
                .doc('wawastore')
                .collection('chat')
                .doc(event.data()!['orderId'])
                .collection('messages')
                .doc(item.id)
                .update({
              "isOpened": true,
              "openTime": new DateTime.now().millisecondsSinceEpoch
            });
          }
        }
      }
      });
    } catch (e) {
      print('###Error-setMessageOpened>>>${e.toString()}');
    }
  }

  // Future setMessageOpened(DocumentSnapshot document) async {
  //   await dbRef
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('chat')
  //       .doc(widget.document['orderId'])
  //       .collection('messages')
  //       .doc(document.id)
  //       .update({
  //     "isOpened": true,
  //     "time": new DateTime.now().millisecondsSinceEpoch,
  //   });
  // }

  Future sendMessage(String message) async {
    // String _uId = await helper.getStorage('uid');
    try {
      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('chat')
          .doc(widget.document['orderId'])
          .collection('messages')
          .add({
        "isOpened": false,
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "uid": widget.document['orderId'],
        "type": "EMPLOYEE"
      }).then((value) {
        notificationToCustomer(message);
      });

      //chat-dashboard

      QuerySnapshot qsDasboard = await dbRef
          .collection('larn8mobile')
          .doc('y64sRawQi5skalZniDYh')
          .collection('chats-dashboard')
          .where('orderId', isEqualTo: widget.document['orderId'])
          .get();

      if (qsDasboard.docs.isEmpty) {
        //create
        await dbRef
            .collection('larn8mobile')
            .doc('y64sRawQi5skalZniDYh')
            .collection('chats-dashboard')
            .add({
          "isOpened": false,
          "message": message,
          "orderId": widget.document['orderId'],
          "time": new DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        //update
        await dbRef
            .collection('larn8mobile')
            .doc('y64sRawQi5skalZniDYh')
            .collection('chats-dashboard')
            .doc(qsDasboard.docs[0].id)
            .update({
          "message": message,
          "time": new DateTime.now().millisecondsSinceEpoch,
          "isOpened": false,
        });
      }

      if (listController!.hasClients) {
        listController!.jumpTo(listController!.position.maxScrollExtent);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future findUid() async {
  //   String _uId = await helper.getStorage('uid');
  //   setState(() {
  //     uID = _uId;
  //   });
  // }

  Future<Null> notificationToCustomer(String message) async {
    //find token
    // String _uId = await helper.getStorage('uid');
    QuerySnapshot qsDasboard = await dbRef
        .collection('wawastore')
        .doc('wawastore')
        .collection('backend')
        // "uid": widget.document['orderId'],
        .where('uid', isEqualTo: widget.document['orderId'])
        .get();
    int index = 0;
    for (var item in qsDasboard.docs) {
      String _token = item['token'];

      // print('_token>>>>$_token');
      String title = 'มีข้อความใหม่จากร้านครับ';
      String body = message;
      String url =
          'http://103.129.14.34/wawastore/apiNotification.php?isAdd=true&token=$_token&title=$title&body=$body';
      sendNotificationToMe(url);

      index++;
    }
    print('จำนวนที่ส่งเท่ากับ $index');
  }

  Future<Null> sendNotificationToMe(String urltoken) async {
    await Dio().get(urltoken).then((value) {
      print('ส่งข้อความสำเร็จจ้า');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMessageOpened(widget.document);
    print('###widget.document.id>>>${widget.document.id}');
    listController = ScrollController(keepScrollOffset: true);
    // findUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'ระบบแชทกับลูกค้า',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: TextFormField(
          controller: ctrlMessage,
          style: TextStyle(fontSize: 22),
          decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: true,
              hintText: 'พิมพ์ข้อความ...',
              contentPadding: EdgeInsets.all(10),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (ctrlMessage.text.isNotEmpty) {
                    String message = ctrlMessage.text;
                    print('message>>>$message');
                    sendMessage(message);
                    setState(() {
                      ctrlMessage.clear();
                    });
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
              children: [
                Icon(
                  Icons.chat,
                  color: Colors.pink,
                  size: 32,
                ),
                Text(
                  'แชทกับลูกค้า',
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
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [Text('ลูกค้า:${widget.document['email']}')],
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: dbRef
                    .collection('wawastore')
                    .doc('wawastore')
                    .collection('chat')
                    .doc(widget.document['orderId'])
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
                  if (snapshot.data == null) return MyStyle().showProgress();
                  if (snapshot.hasError) {
                    print(snapshot.error);

                    return Text('${snapshot.error}');
                  }
                  return ListView(
                    controller: listController,
                    children: snapshot.data!.docs.map((e) {
                      return e['type'] == 'CUSTOMER'
                          ? CustomerChatItem(
                              message: e,
                            )
                          : EmployeeChatItem(
                              message: e,
                            );
                    }).toList(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
