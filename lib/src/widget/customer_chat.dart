import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wawa/utility/helper.dart';



class CustomerChatItem extends StatelessWidget {
  final DocumentSnapshot message;
  CustomerChatItem({required this.message});

  @override
  Widget build(BuildContext context) {
    Helper helper = Helper();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(message['time']);
    
    return Container(
      padding: const EdgeInsets.only(
        right: 10,
        left: 80,
        top: 10,
        bottom: 10,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
          color: Colors.indigo[100],
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 15),
                child: Wrap(
                  children: [
                    Text(
                      '${message['message']}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),message['isOpened'] ? const Text(' (อ่านแล้ว)',style:  TextStyle(fontSize: 20),)  :const Text('')
                  ],
                ),
              ),
             
              Positioned(bottom: 1, right: 10, child: Text('${helper.timestampToTime2(date)} ${helper.timestampToTime(date)}น.',style: const TextStyle(fontSize: 20),))
            ],
          ),
        ),
      ),
    );
  }
}
