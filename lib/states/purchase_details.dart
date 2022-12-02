import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/widget/productitembox.dart';

class PurchaseDetails extends StatefulWidget {
  final DocumentSnapshot document; //one
  PurchaseDetails({required this.document});
  @override
  _PurchaseDetailsState createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  bool loading = false;
  bool statusHavedata = false;
  ScrollController scrollController = ScrollController();
  List<DocumentSnapshot> products = [];

  Future<Null> readProduct() async {
    setState(() {
      products.clear();
      loading = true;
    });
    // await Firebase.initializeApp().then((value) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('purchase')
          // .where('urlImage', isNotEqualTo: '')
          .where('docNo', isEqualTo: widget.document['docNo'])
          // .collection('product')
          .where('uid', isEqualTo: widget.document['uId'])
          .get();

      if (snapshot.docs.length != 0) {
        setState(() {
          statusHavedata = true;
        });

         setState(() {
        loading = false;
        products = snapshot.docs;
      });
      }else{
        setState(() {
          loading = false;
           statusHavedata = false;
        });

      }

     
    } catch (e) {
      print('e OrderBy==>${e.toString()}');
    }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสินค้า'),
      ),
      body:  Column(
              children: [
                Row(
                  children: [],
                ),
                Expanded(
                    child: loading
                        ? MyStyle().showProgress()
                        : ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: ProductItemBox(
                                          imageurl: products[index]['picturl'],
                                          width: 60,
                                          height: 60),
                                      title: Text(
                                        '${index + 1}. ${products[index]['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   'บาร์โค้ด: ${products[index]['bacode']},',
                                  //   style: TextStyle(fontSize: 18),
                                  // ),
                                  Text(
                                    'ราคา: ${products[index]['price']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'จำนวน: ${products[index]['amounts']} x ${products[index]['unit']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'ราคารวม: ${products[index]['subtotal']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider()
                                ],
                              );
                            },
                          )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ราคารวม:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${products[0]['total']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.red[600]),
                    ),
                    Text(
                      ' บาท',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                )
              ],
            )
         
    );
  }
}
