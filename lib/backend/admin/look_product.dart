import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wawa/backend/admin/search.dart';
import 'package:wawa/models/barcode_model.dart';
import 'package:wawa/models/product_cloud_model.dart';

import 'package:wawa/utility/my_style.dart';

class LookProduct extends StatefulWidget {
  final DocumentSnapshot products;
  // final String doct;
  LookProduct({required this.products});
  @override
  _LookProductState createState() => _LookProductState();
}

class _LookProductState extends State<LookProduct> {
  final dbRef = FirebaseFirestore.instance;
  List<int> amounts = [];
  List<double> subTotals = [];
  double total = 0;
  bool isPromotion = false;
  //bool isOn;
  bool isBest = false;

  ProductCloudModel? productModel;
  DocumentSnapshot? products;
  String? doct;
  List<BarcodeModel> barcodeModels = [];
  double screen =0;

  @override
  void initState() {
    // TODO: implement initState

    // productModel = widget.productModel;
    // print('#####urlImage ===>> ${productModel.urlImage}');
    doct = widget.products.id;
    products = widget.products;

    if (widget.products['isPromotion']) {
      setState(() {
        isPromotion = widget.products['isPromotion'];
      });
    }
    print('isPromotion==>>> $isPromotion');

    //isOn = widget.products['isOn'];
    if (widget.products[isBest]) {
      setState(() {
        isBest = widget.products['isBest'];
      });
    }
    print('isBest==>>> $isBest');

    readProduct();

    super.initState();
  }

  Future<Null> readProduct() async {
    // await Firebase.initializeApp().then((value) async {
    await dbRef
        .collection('wawastore')
        .doc('wawastore')
        .collection('product2')
        .doc(doct)
        .collection('unit_codes')
        .snapshots()
        .listen((event) {
      for (var item in event.docs) {
        BarcodeModel model = BarcodeModel.fromMap(item.data());
        amounts.add(0);
        subTotals.add(0);

        setState(() {
          barcodeModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.transparent,
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      //   children: [

      // ElevatedButton(
      //   style: ElevatedButton.styleFrom(
      //       primary: Colors.black,
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(15)),
      //       shadowColor: Colors.black),
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   child: Text(
      //     'ยกเลิก',
      //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      //   ),
      // ),
      // ElevatedButton(
      //   style: ElevatedButton.styleFrom(
      //       primary: MyStyle().primartColor,
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(15)),
      //       shadowColor: Colors.black),
      //   onPressed: () {
      //     if (total == 0) {
      //       normalDialog(context, 'ไม่มีรายการสินค้า', 'กรุณาเลือกสินค้าก่อนครับ');
      //     } else {
      //       addValueToCart();
      //     }
      //   },
      //   child: Text(
      //     'หยิบใส่ตะกร้า',
      //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      //   ),
      // ),
      //   ],
      // ),

      body: barcodeModels.length == 0
          ? MyStyle().showProgress()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  buildShowImage(),
                  SizedBox(
                    height: 4,
                  ),
                  buildTitle(),
                  SizedBox(
                    height: 4,
                  ),
                  buildCat(),
                  SizedBox(
                    height: 4,
                  ),

                  buildHeadTable(),
                  buildListView(),
                  buildCheck(),
                  // buildTotalPrice(),
                  SizedBox(
                    height: 25,
                  ),
                  buildElevatedButton(context)
                ],
              ),
            ),
    );
  }

  Row buildElevatedButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.black,
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
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.blue[300],
          ),

          onPressed: () async {
            // String _name = ctrlName.text.trim();
            // String _detail = ctrlDetail.text.trim();
            // double _pricepro = double.tryParse(ctrlPricepro.text.trim() ?? 0);
            // double _price = double.tryParse(ctrlprice.text.trim() ?? 0);
            // String _category = categoryId;
            bool _ispromotion = isPromotion;
            // bool _isOn = isOn;
            bool _isBest = isBest;

            //แสดงแบบเรียบไทม์
            try {
              await dbRef
                  .collection('wawastore')
                  .doc('wawastore')
                  .collection('product2')
                  .doc(doct)
                  .update({
                // "isOn": _isOn,
                // "isBest": _isBest,
                //  "isPromotion": _ispromotion,
              }).then((value) {
                showToast("รายการสินค้าอัพเดทแล้วครับ");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchAdmin(),
                    ));

                // Navigator.of(context).pop();
                //  readProduct();
              });
            } catch (e) {
              print('error>>>${e.toString()}');
            }

            // if (total == 0) {
            //   normalDialog(
            //       context, 'ไม่มีรายการสินค้า', 'กรุณาเลือกสินค้าก่อนครับ');
            // } else {
            //   addValueToCart();
            // }
          },
          icon: Icon(
            Icons.check,
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

  void showToast(String msg) {
    // Toast.show(msg, context,
    //     backgroundColor: Colors.red[100],
    //     textColor: Colors.red[800],
    //     duration: 2);
    Fluttertoast.showToast(msg: msg);
  }

  Row buildTotalPrice() {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'รวมทั้งหมด:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                    fontSize: 32,
                  ),
                ),
              ],
            )),
        Expanded(
            flex: 2,
            child: Container(
              //alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyStyle().myFormat.format(total),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800]),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Container buildHeadTable() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'หน่วย :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'ราคา :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3White('ราคา :')
            ),
            // Expanded(
            //   flex: 1,
            //   child: Text(
            //     'จำนวน :',
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            //   ),
            //   // MyStyle().titleH3Whte('จำนวน :')
            // ),
            // Expanded(
            //   flex: 1,
            //   child: Text(
            //     'ผลรวม :',
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            //   ),
            //   // MyStyle().titleH3White('ผลรวม :')
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        // productModel.name,
        products!['name'],
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 5,
      ),
    );
  }

  Widget buildCat() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'หมวดหมู่:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange[600],
            ),
          ),
          Text(
            // productModel.name,
            products!['categoryName'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange[300],
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Container buildShowImage() {
    return Container(

        // margin: EdgeInsets.only(top: 16.0, bottom: 16),
        child: CachedNetworkImage(
      // fit: BoxFit.cover,
      width: screen * 0.9,
      height: 300,
      // imageUrl: productModel.urlImage,
      imageUrl: products!['urlImage'],
      placeholder: (context, url) => MyStyle().showProgress(),
      errorWidget: (context, url, error) => Image.asset('images/image.png'),
    ));
  }

  Widget buildCheck() {
    return Column(
      children: [
        Container(
          child: CheckboxListTile(
              value: isBest,
              title: Text(
                'ขายดี',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onChanged: (value) {
                setState(() {
                  isBest = value!;
                });
              }),
        ),
        Container(
          child: CheckboxListTile(
              value: isPromotion,
              title: Text(
                'สินค้าโปรโมชั่น',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onChanged: (value) {
                setState(() {
                  isPromotion = value!;
                });
              }),
        ),
        // Container(
        //   child: CheckboxListTile(
        //       value: isOn,
        //       title: Text(
        //         'เปิด/ปิด ใช้งาน',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //       ),
        //       onChanged: (value) {
        //         setState(() {
        //           isOn = value;
        //         });
        //       }),
        // ),
      ],
    );
  }

  ListView buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: barcodeModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              barcodeModels[index].unit_code,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              MyStyle().myFormat.format(barcodeModels[index].price0),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          //   Expanded(
          //     flex: 2,
          //     child: Row(
          //       children: [
          //         IconButton(
          //           icon: Icon(
          //             Icons.remove_circle_outline,
          //             size: 32,
          //           ),
          //           onPressed: () {
          //             if (amounts[index] != 0) {
          //               setState(() {
          //                 amounts[index]--;
          //                 subTotals[index] = barcodeModels[index].price *
          //                     double.parse(amounts[index].toString());
          //                 total = 0;
          //                 for (var item in subTotals) {
          //                   total = total + item;
          //                 }
          //               });
          //             }
          //           },
          //         ),
          //         Text(
          //           amounts[index].toString(),
          //           style: TextStyle(
          //             fontSize: 28,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //           ),
          //         ),
          //         IconButton(
          //           icon: Icon(
          //             Icons.add_circle_outline,
          //             size: 32,
          //           ),
          //           onPressed: () {
          //             // print('You click Add at index ===>> $index');
          //             setState(() {
          //               amounts[index]++;
          //               subTotals[index] = barcodeModels[index].price *
          //                   double.parse(amounts[index].toString());
          //               total = 0;
          //               for (var item in subTotals) {
          //                 total = total + item;
          //               }
          //             });
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          //   Expanded(
          //       flex: 1,
          //       child: Text(
          //         MyStyle().myFormat.format(subTotals[index]),
          //         style: TextStyle(
          //           fontSize: 32,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.orange[600],
          //         ),
          //       ))
        ],
      ),
    );
  }

  // Future<Null> addValueToCart() async {
  //   int index = 0;
  //   for (var item in amounts) {
  //     String code = doct;
  //     String name = products['name'];

  //     String barcodes = barcodeModels[index].barcode;
  //     String prices = barcodeModels[index].price.toString();
  //     String unitcodes = barcodeModels[index].unit_code;
  //     int listAmounts = amounts[index];
  //     String listSubtotals = subTotals[index].toString();
  //     String urlImage = products['urlImage'];

  //     print(
  //         'code = $code, name=$name, barcode= $barcodes, prices=$prices, unitcodes=$unitcodes, listAmount=$listAmounts, listSubtotals=$listSubtotals');

  //     SQLiteModel model = SQLiteModel(
  //         code: code,
  //         name: name,
  //         barcodes: barcodes,
  //         prices: prices,
  //         units: unitcodes,
  //         amounts: listAmounts,
  //         subtotals: listSubtotals,
  //         picturl: urlImage);

  //     Map<String, dynamic> map = model.toMap();
  //     await SQLiteHelper().insertValueToSQLite(map);

  //     index++;
  //   }
  //   print('#####index==>>$index');

  //   Navigator.of(context).pop(true);
  //   showToast("หยิบสินค้าใส่ตะกร้าแล้วครับ");
  // }
// void showToast(String msg) {
//     Toast.show(msg, context,
//         backgroundColor: Colors.orange[100],
//         textColor: Colors.orange[800],
//         duration: 3);
//   }

}
