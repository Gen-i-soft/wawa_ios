import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wawa/models/barcode_model.dart';
import 'package:wawa/models/product_cloud_model.dart';
import 'package:wawa/states/choose_productnumber.dart';
import 'package:wawa/utility/dialog.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/widget/progress_dialog.dart';

class ChooseProduct extends StatefulWidget {
  final Function onAdItem;
  final DocumentSnapshot products;
  // final String doct;
  ChooseProduct({required this.products, required this.onAdItem});
  @override
  _ChooseProductState createState() => _ChooseProductState();
}

class _ChooseProductState extends State<ChooseProduct> {
  final dbRef = FirebaseFirestore.instance;
  List<int> amounts = [];
  List<double> subTotals = [];
  double total = 0;

  ProductCloudModel? productModel;
  DocumentSnapshot? products;
  String? doct;
  List<BarcodeModel> barcodeModels = [];
  double screen = 0;
  String uid = 'user';
  Helper helper = Helper();

  Future<void> checkUser() async {
    String? _uid =
        FirebaseAuth.instance.currentUser!.uid; //ใช้ได้โดยไม่ต้อง add อ่ะ
    print('####_uid>>>$_uid');
    if (_uid.isNotEmpty) {
      setState(() {
        uid = _uid;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //checkLogin();
    super.initState();
    doct = widget.products.id;
    products = widget.products;
    readProduct();
    checkUser();

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
                child: Container(child: MyStyle().showProgress()
                    // Text(
                    //   '$doct ไม่มีราคากลางครับ',
                    //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    // ),
                    ))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 30, bottom: 30),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              String res = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => ChooseProductNumber(
                                    products: widget.products,
                                    onAdItem: () => widget.onAdItem()),
                              ));
                              if (res == "save") {
                                widget.onAdItem();
                              }
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
                                    'กรอกจำนวนเป็นตัวเลข',
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
            Expanded(
              flex: 1,
              child: Text(
                'จำนวน :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3Whte('จำนวน :')
            ),
            Expanded(
              flex: 1,
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
        products!['name'],  //worked***
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
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 1,
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
            flex: 1,
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
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 32,
                  ),
                  onPressed: () {
                    if (amounts[index] != 0) {
                      setState(() {
                        amounts[index]--;
                        subTotals[index] = barcodeModels[index].price0 *
                            double.parse(amounts[index].toString());
                        total = 0;
                        for (var item in subTotals) {
                          total = total + item;
                        }
                      });
                    }
                  },
                ),
                Text(
                  amounts[index].toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 32,
                  ),
                  onPressed: () {
                    // print('You click Add at index ===>> $index');
                    setState(() {
                      amounts[index]++;
                      subTotals[index] = barcodeModels[index].price0 *
                          double.parse(amounts[index].toString());
                      total = 0;
                      for (var item in subTotals) {
                        total = total + item;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Text(
                MyStyle().myFormat.format(subTotals[index]),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[600],
                ),
              ))
        ],
      ),
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

    int index = 0;
    for (var item in amounts) {
      String? code = doct;
      String name = products!['name'];

      // final int id;
      // final String code;
      // final String name;
      // final String barcodes;
      // final String prices;
      // final String units;
      // final int amounts;
      // final String subtotals;
      // final String picturl;

      // final String namedatabase = 'lekproductdb';
      // final String namedatabase2 = 'lekdb2';
      // final String nametable = 'ordertable';
      // final String nametable2 = 'ordertable2';
      // final String idcolumn = 'id';
      // final String idcode = 'code';
      // final String uid = 'uid';
      // final String namecolum = 'name';
      // final String barcodecolumn = 'barcodes';
      // final String pricecolumn = 'prices';
      // final String unitcolumn = 'units';
      // final String amountcolumn = 'amounts';
      // final String subtotalcolumn = 'subtotals';
      // final String pictcolumn = 'picturl';
      // final int databaseversion = 1;

      //String barcodes = barcodeModels[index].barcode;
      String prices = barcodeModels[index].price0.toString();
      String unitcodes = barcodeModels[index].unit_code;
      int listAmounts = amounts[index];
      String listSubtotals = subTotals[index].toString();
      String urlImage = products!['urlImage'];

      // print(  //worked!!!
      //     'code = $code, name=$name,  prices=$prices, unitcodes=$unitcodes, listAmount=$listAmounts, listSubtotals=$listSubtotals');

      // SQLiteModel model = SQLiteModel(
      //     code: code!,
      //     name: name,
      //     prices: prices,
      //     units: unitcodes,
      //     amounts: listAmounts,
      //     subtotals: listSubtotals,
      //     picturl: urlImage);

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
    // print('#####index==>>$index'); //worked!!!
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
        fontSize: 16.0);
  }
}
