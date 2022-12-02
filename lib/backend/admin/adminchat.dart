import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wawa/backend/admin/chatadminpage.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class AdminChatPage extends StatefulWidget {
  @override
  _AdminChatPageState createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  //params

  final dbRef = FirebaseFirestore.instance;
  Helper helper = new Helper();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline_outlined),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'ข้อความลูกค้า',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: dbRef
                .collection('wawastore')
                .doc('wawastore')
                .collection('chats-dashboard')
                // .where('isOpened', isEqualTo: false)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return MyStyle().showProgress();

              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('เกิดข้อผิดพลาด');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return MyStyle().showProgress();

                  break;
                default:
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                          document['time']);

                      return  Container(
                        color: Colors.orange[50],
                        child: ListTile(
                          onTap: () {
                           
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatAdminPage(
                                document: document,
                              ),
                            ));
                          },
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.orange[600],
                          ),
                          title: Wrap(
                            children: [
                              Text('${document['message']} ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),if (document['isOpened'] == false) Image.asset('images/new-24.png',width:24,height:24) else Text('')
                            ],
                          ),
                          //"displayName": qsBackend.docs[0]['displayName'],
                         
                          subtitle: document.data().toString().contains('displayName') ?    Text('ลูกค้า: ${document['displayName']} / ${document['email']}') :Text('ลูกค้า: ${document['email']}') ,
                          trailing: Text('${helper.timestampToTime(date)} น.'),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          )),
        ],
      ),
    );
  }
}
