import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:wawa/src/widget/product_box.dart';
import 'package:wawa/states/purchase_details.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class Purchase extends StatefulWidget {
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  String? docNo, docDate;
  double total = 0;
  List<int> amounts = [];
  List<double> subTotals = [];

  List<String> docNos = [];
  List<String> docDates = [];
  List<String> statuss = [];

  bool statusHaveData = false;
  List<int> statusInts = [];
  bool loading = false;
  Helper helper = Helper();
  List<DocumentSnapshot> products = [];
  final dbRef = FirebaseFirestore.instance;
  int status = 0;
  double screen =0;
  String? uid;

  Future getProduct() async {
    loading = true;
    setState(() {
      products.clear();
    });
    // String _uId = await helper.getStorage('uid');
    // error แต่ดันโชว์ allจ้า
    uid =   FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot snapshot = await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('purchase-dashboard')
          .where('uId', isEqualTo: uid)
          .orderBy('time', descending: true)
          .get();

      if (snapshot.docs.length != 0) {
        setState(() {
          statusHaveData = true;
        });

        for (var item in snapshot.docs) {
          String _docNo = item['docNo'];
          //New jaa
          docNos.add(_docNo);

          String _docDate = item['dateTimeStr'];
          docDates.add(_docDate);

          String _statuss = item['status'];
          statuss.add(_statuss);
        }

        setState(() {
          loading = false;
          //รับ QuerySnapshot
          products = snapshot.docs;

          // print('products###==>>$products');
        });
      }
    } catch (e) {
      print('error e===>>${e.toString()}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
     
    super.initState();
    getProduct();
   
   
  }

  // Future<Null> checkLogin() async {
  //   await Firebase.initializeApp().then((value) async {
  //     await FirebaseAuth.instance.authStateChanges().listen((event) async {
  //       if (event!.uid.length >0) {
  //         setState(() {
  //           uid = event.uid;
         
  //           helper.setStorage('uid', event.uid);
  //         });
  //         print('####uid>>${event.uid}');
  //       } else {}
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานะคำสั่งซื้อ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text(
                //   'สถานะคำสั่งซื้อ',
                //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),

          Expanded(child: buildListView()),

          // buildIndicator(status),

          // Expanded(child: ListView.builder(itemBuilder: null)),
        ],
      )),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        switch (products[index]['status']) {
          case 'ยืนยันคำสั่งซื้อ':
            status = 0;
            break;

          case 'กำลังเตรียมสินค้า':
            status = 1;
            break;

          case 'กำลังดำเนินการส่งสินค้า':
            status = 2;
            break;

          case 'ลูกค้ารับสินค้าแล้ว':
            status = 3;
            break;

          default:
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    '${index + 1}. เลขที่คำสั่งซื้อ:${products[index]['docNo']}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    'ราคารวม',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${products[index]['total']} ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'บาท',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'วันที่ซื้อ ${products[index]['dateTimeStr']}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screen * 0.6,
                  height: 40,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchaseDetails(
                                document: products[index],
                              ),
                            ));
                      },
                      icon: Icon(
                        Icons.sd_storage,
                        size: 20,
                      ),
                      label: Text(
                        'รายละเอียดเพิ่มเติม',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),

            // Text('ราคารวม =$total'),
            buildIndicator(status),

            Divider(),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
      //
    );
  }

  Widget buildIndicator(int index) {
    print('index >>>$index');
    return Column(
      children: [
        StepsIndicator(
          selectedStepColorIn: Colors.red,
          selectedStepColorOut: Colors.green,
          selectedStepSize: 18,
          lineLength: 80,
          nbSteps: 4,
          selectedStep: index,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                'ยืนยันการสั่งซื้อ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                'เตรียม/จัดสินค้า',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                'อยู่ระหว่างการจัดส่ง',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                'ลูกค้ารับของแล้ว',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        )
      ],
    );
  }
}
