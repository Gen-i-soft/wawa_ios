import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wawa/utility/helper.dart';




class EmployeeChatItem extends StatelessWidget {
  final DocumentSnapshot message;
  EmployeeChatItem({required this.message});
  @override
  Widget build(BuildContext context) {
    Helper helper = Helper();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(message['time']);
    
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.record_voice_over),
      ),
      title: const Text('พนักงาน'),
      subtitle: Wrap(
        children: [
           Text('${message['message']}',style: const TextStyle(fontSize: 30),),message['isOpened'] ? const Text(' (อ่านแล้ว)',style:  TextStyle(fontSize: 20),)  :const Text('')
        ],
      ),
      trailing: Text('${helper.timestampToTime2(date)} ${helper.timestampToTime(date)}น.',style: const TextStyle(fontSize: 20),),
    );
  }
}
