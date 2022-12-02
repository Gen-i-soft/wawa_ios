import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wawa/models/barcode_model.dart';
import 'package:wawa/models/product_cloud_model.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/debouncer.dart';
import 'package:wawa/utility/dialog.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/widget/progress_dialog.dart';

import '../utility/helper.dart';

class ChooseProductNumber extends StatefulWidget {
  final Function onAdItem;
  final DocumentSnapshot products;
  // final String doct;
  ChooseProductNumber({required this.products, required this.onAdItem});
  @override
  _ChooseProductNumberState createState() => _ChooseProductNumberState();
}

class _ChooseProductNumberState extends State<ChooseProductNumber> {
  final dbRef = FirebaseFirestore.instance;
  final debouncer = Debouncer(milliseconds: 1500);
  List<int> amounts = [];
  List<double> subTotals = [];
  double total = 0;
  //final debouncer = Debouncer(milliseconds: 1500);

  ProductCloudModel? productModel;
  DocumentSnapshot? products;
  String? doct;
  List<BarcodeModel> barcodeModels = [];
  double screen =0;
  String uid = 'user';
  TextEditingController amountController = TextEditingController();
  Helper helper = Helper();

  @override
  void initState() {
    // TODO: implement initState
    //checkLogin();
    super.initState();
    doct = widget.products.id;
    products = widget.products;
    readProduct();

    // if (uid == 'user') {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => Authen(),
    //   ));
    // }

    // productModel = widget.productModel;
    // print('#####urlImage ===>> ${productModel.urlImage}');

    print('####id-product2==>>> $doct');
  }

  Future<void> readProduct() async {
    barcodeModels.clear();
    await Firebase.initializeApp().then((value) async {
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
          // num _price0 = item['price0'];
          // print('_price0>>>$_price0');
          amounts.add(0);
          subTotals.add(0);

          setState(() {
            barcodeModels.add(model);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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

        body: barcodeModels.isEmpty
            ? Center(
                child: Container(
                child: MyStyle().showProgress()
                // Text(
                //   '$doct ไม่มีราคากลางครับ',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                // ),
              ))
            : GestureDetector(
          onTap: ()=> FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      buildShowImage(),
                      const SizedBox(
                        height: 4,
                      ),
                      buildTitle(),
                      const SizedBox(
                        height: 4,
                      ),

                      buildHeadTable(),
                      buildListView(),
                      buildTotalPrice(),
                          const SizedBox(
                        height: 4,
                      ),
                      Wrap(
                      alignment: WrapAlignment.center,
                        children: const [
                        Text('* คลิกที่ช่องจำนวนเพื่อกรอกตัวเลข กรณีไม่เลือกให้ใส่ 0',style: TextStyle(fontSize: 18),)

                      ],),
                       Wrap(
                         alignment: WrapAlignment.start,
                         children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('** กรอกจำนวนแล้วรอ 2 วินาที เพื่อให้ระบบคำนวณ',style: TextStyle(fontSize: 18),),
                        )

                      ],),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Wrap(children: const [
                        Text('*** ซ่อนคีย์บอร์ด โดยการกดปุ่ม',style: TextStyle(fontSize: 18),),
                        Icon(Icons.expand_more),
                        Text(' มุมล่างขวา',style: TextStyle(fontSize: 18),)

                      ],),
                         ),

                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChooseProduct(
                                    products: widget.products,
                                    onAdItem: () => widget.onAdItem()),
                              ));
                            },
                            child: Container(

                                // width: 300,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'กรอกจำนวนด้วยปุ่มเพิ่ม(+)/ลด(-)',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700]),
                                  ),
                                )),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      buildElevatedButton(context)
                    ],
                  ),
                ),
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
            shape: const RoundedRectangleBorder(
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
          icon: const Icon(
            Icons.cancel,
            color: Colors.white,
            size: 32,
          ),
          label: const Text(
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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.orange[700],
          ),

          onPressed: () {
            if (total == 0) {
              normalDialog(
                  context, 'ไม่มีรายการสินค้า', 'กรุณาเลือกสินค้าก่อนครับ');
            } else {
              addValueToCart();
            }
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white,
            size: 32,
          ),
          label: const Text(
            'ยืนยัน',
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
          children: const [
            Expanded(
              flex: 2,
              child: Text(
                'หน่วย :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'ราคา :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3White('ราคา :')
            ),
            Expanded(
              flex: 2,
              child: Text(
                'จำนวน :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3Whte('จำนวน :')
            ),
            Expanded(
              flex: 3,
              child: Text(
                'ผลรวม :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3White('ผลรวม :')
            ),
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
        style: const TextStyle(
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

  ListView buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: barcodeModels.length,
      itemBuilder: (context, index) {
        amountController =
            TextEditingController(text: amounts[index].toString());
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                barcodeModels[index].unit_code,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                MyStyle().myFormat.format(barcodeModels[index].price0),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: 50,
                    height: 50,
                    child: TextField(
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800]),
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      onChanged: (value) {
                        //  setState(() {
                        amounts[index] = int.parse(value);
                        debouncer.run(() {
                          //  if (amounts[index] != 0) {
                          setState(() {
                            // amounts[index]--;
                            subTotals[index] = barcodeModels[index].price0 *
                                double.parse(amounts[index].toString());
                            total = 0;
                            for (var item in subTotals) {
                              total = total + item;
                            }
                          });
                       // }
                          
                        });
                        // print('####value>>>$value');
                      
                        //   });
                        // setState(() {
                        //   subTotals[index] =
                        //       barcodeModels[index].price0 * double.parse(value);
                        //    total = 0;
                        //   total = total + subTotals[index];
                        // });
                      },
                    ),
                  )

                  // IconButton(
                  //   icon: Icon(
                  //     Icons.remove_circle_outline,
                  //     size: 32,
                  //   ),
                  //   onPressed: () {
                  //     if (amounts[index] != 0) {
                  //       setState(() {
                  //         amounts[index]--;
                  //         subTotals[index] = barcodeModels[index].price0 *
                  //             double.parse(amounts[index].toString());
                  //         total = 0;
                  //         for (var item in subTotals) {
                  //           total = total + item;
                  //         }
                  //       });
                  //     }
                  //   },
                  // ),
                  // Text(
                  //   amounts[index].toString(),
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.add_circle_outline,
                  //     size: 32,
                  //   ),
                  //   onPressed: () {
                  //     // print('You click Add at index ===>> $index');
                  //     setState(() {
                  //       amounts[index]++;
                  //       subTotals[index] = barcodeModels[index].price0 *
                  //           double.parse(amounts[index].toString());
                  //       total = 0;
                  //       for (var item in subTotals) {
                  //         total = total + item;
                  //       }
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  MyStyle().myFormat.format(subTotals[index]),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[600],
                  ),
                ))
          ],
        );
      },
    );
  }

  Future<void> addValueToCart() async {
    String _uid = await helper.getStorage('uid') ?? 'user';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            message: "ระบบกำลังบันทึกข้อมูลครับ...",
          );
        });
    // String? _uid =
    //     FirebaseAuth.instance.currentUser!.uid; //
    int index = 0;
    for (var item in amounts) {
      String? code = doct;
      String name = products!['name'];

      //String barcodes = barcodeModels[index].barcode;
      String prices = barcodeModels[index].price0.toString();
      String unitcodes = barcodeModels[index].unit_code;
      int listAmounts = amounts[index];
      String listSubtotals = subTotals[index].toString();
      String urlImage = products!['urlImage'];

      print(
          'code = $code, name=$name,  prices=$prices, unitcodes=$unitcodes, listAmount=$listAmounts, listSubtotals=$listSubtotals');

      // SQLiteModel model = SQLiteModel(
      //     code: code!,
      //     name: name,
      //     prices: prices,
      //     units: unitcodes,
      //     amounts: listAmounts,
      //     subtotals: listSubtotals,
      //     picturl: urlImage);
      //
      // Map<String, dynamic> map = model.toMap();
      // await SQLiteHelper().insertValueToSQLite(map);
      if (amounts[index] > 0) {
        await FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('addcart')
            .add({
          "uid": _uid,
          "code": code,
          "name": name,
          "prices": prices,
          "units": unitcodes,
          "amounts": listAmounts,
          "subtotals": listSubtotals,
          "picturl": urlImage
        });
      }

      //insert inCart
      if (listAmounts >0) {
        await FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('inCart')
            .add({
          "code": code,
          "name": name,
          "price": prices,
          "unit": unitcodes,
          "amount": listAmounts,
          "subtotal": listSubtotals,
          "uid": _uid
        });
      }

      index++;
    }
    print('#####index==>>$index');
    Navigator.pop(context, "save");
    Navigator.pop(context, "save");
    showToast("หยิบสินค้าใส่ตะกร้าแล้วครับ");
  }

  void showToast(String msg) {
    // Toast.show(msg, context,
    //     backgroundColor: Colors.orange[100],
    //     textColor: Colors.orange[800],
    //     duration: 3);
        Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
