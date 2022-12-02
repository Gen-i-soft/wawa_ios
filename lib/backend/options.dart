import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {
  final DocumentSnapshot document;
  OptionsPage({required this.document});
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final dbRef = FirebaseFirestore.instance;
  List<String> status = [
    'ยืนยันคำสั่งซื้อ',
    'กำลังเตรียมสินค้า',
    'กำลังดำเนินการส่งสินค้า',
    'ลูกค้ารับสินค้าแล้ว'
  ];
  String? selectedType;
  List options = [];

  Future<Null> checkOptions() async {
    // QuerySnapshot querySnapshot = await dbRef
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkOptions();
    selectedType = widget.document['status'];
  }

  Row buildCloudButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            // height: 60,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)
                // topLeft: Radius.circular(20),
                // bottomLeft: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.grey[400],
          ),

          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
            size: 32,
          ),
          label: Text(
            'ยกเลิก',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 30,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            // height: 60,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)
                // topLeft: Radius.circular(20),
                // bottomLeft: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.red[400],
          ),

          onPressed: () {
            Navigator.of(context).pop();
            updateFuture();
          },
          icon: Icon(
            Icons.save,
            color: Colors.white,
            size: 32,
          ),
          label: Text(
            'บันทึก',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สถานะคำสั่งซื้อ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('docNo: ${widget.document['docNo']}')],
              ),

              Column(
                children: status.map((item) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        selectedType = item;
                      });
                    },
                    leading: selectedType == item
                        ? Icon(
                            Icons.check_box,
                            color: Colors.green[700],
                          )
                        : Icon(Icons.check_box_outline_blank),
                    title: Text(item),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 30,
              ),
              buildCloudButton()

              // ListTile(
              //   leading: Icon(Icons.check_box_outline_blank),
              //   title: Text('ยืนยันการสั่งซื้อ'),
              // ),
              // ListTile(
              //   leading: Icon(Icons.check_box),
              //   title: Text('กำลังเตรียมสินค้า'),
              // ),

              // ListTile(
              //   leading: Icon(Icons.check_box_outline_blank),
              //   title: Text('ลูกค้ารับสินค้า'),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> notificationToCustomer(String message) async {
    //find token
    // String _uId = await helper.getStorage('uid');
    QuerySnapshot qsDasboard = await dbRef
        .collection('wawastore')
        .doc('wawastore')
        .collection('backend')
        // "uid": widget.document['orderId'],
        .where('uid', isEqualTo: widget.document['uid'])
        .get();
    int index = 0;
    for (var item in qsDasboard.docs) {
      String _token = item['token'];

      // print('_token>>>>$_token');
      String title = 'มีข้อความใหม่จากร้านครับ';
      String body = 'มีการอัพเดทสถานะคำสั่งซื้อของคุณ :$message';
      String url =
          'http://103.129.14.235/wawastore/apiNotification.php?isAdd=true&token=$_token&title=$title&body=$body';
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

  Future<Null> updateFuture() async {
    //update table report
    try {
      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('Report')
          .doc(widget.document.id)
          .update({
        "status": selectedType,
      });
    } catch (e) {
      print('error>>${e.toString()}');
    }
//update table purchase-dashboard

    try {
      QuerySnapshot qsDasboard = await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('purchase-dashboard')
          .where('uId', isEqualTo: widget.document['uid'])
          .where('docNo', isEqualTo: widget.document['docNo'])
          .get();

      for (var item in qsDasboard.docs) {
        //update many
        await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('purchase-dashboard')
            .doc(item.id)
            .update({
          "status": selectedType,
        });
      }
    } catch (e) {
      print('error>>${e.toString()}');
    }

    //แจ้งเตือน
    notificationToCustomer(selectedType!);
  }
}
