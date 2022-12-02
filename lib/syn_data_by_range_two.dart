import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
//import 'package:wawa/models/barcode_model.dart';
import 'package:wawa/models/category_model.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';
//import 'package:wawa/models/product_model.dart';
//import 'package:wawa/utility/my_style.dart';

class SyncDataByRangeTwo extends StatefulWidget {
  @override
  _SyncDataByRangeTwoState createState() => _SyncDataByRangeTwoState();
}

class _SyncDataByRangeTwoState extends State<SyncDataByRangeTwo> {
  // List<GenderModel> genderModelList = [];
  String? selectedGender;
  List<String> categories = [];
  List<CategoryModel> categoryModels = [];
  final dbRef = FirebaseFirestore.instance;
  int coutNum = 0;
  int countProcess = 0;
  int qtyTotal = 0;

  int index = 0;
  int numx = 0;
  int numm = 0;
  double uploadPer = 0;
  double _value = 0;
  bool loading = false;
  Helper helper = Helper();
  var myFormat = NumberFormat('#,##0.0#', 'en_US');
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMin = TextEditingController();
  TextEditingController ctrlMax = TextEditingController();
  TextEditingController productCtrl = TextEditingController();
  double screen = 0;

  // Future<Null> genNumber() async {
  //   await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('wawaproduct02')
  //       // .where('statusOK', isEqualTo: true)
  //       // .where('itemCategory', isEqualTo: syntxt)
  //       .snapshots()
  //       .listen((event) async {
  //     int count = 1;
  //     for (var item in event.docs) {
  //       await FirebaseFirestore.instance
  //           .collection('wawastore')
  //           .doc('wawastore')
  //           .collection('wawaproduct')
  //           .doc(item.id)
  //           .update({"no": count});
  //       count++;
  //     }
  //   });
  // }

  // Future<Null> getCode(int minNumber, int maxNumber) async {
  //   await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('wawaproduct')
  //       //.orderBy('no')
  //       .where('no', isGreaterThanOrEqualTo: minNumber)
  //       .where('no', isLessThanOrEqualTo: maxNumber)

  //       // .where('statusOK', isEqualTo: true)
  //       // .where('itemCategory', isEqualTo: syntxt)
  //       .snapshots()
  //       .listen((event) async {
  //     int count = 0;
  //     for (var item in event.docs) {
  //       String code = item['productId'];
  //       count++; //
  //       print('####count.code  true >>>$count.) $code');
  //     }
  //   });
  // }

  // Future<Null> checkTure(syntxt) async {
  //   await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('product2')
  //       .where('statusOK', isEqualTo: true)
  //       .where('itemCategory', isEqualTo: syntxt)
  //       .snapshots()
  //       .listen((event) async {
  //     int count = 0;
  //     for (var item in event.docs) {
  //       String code = item.id;
  //       count++; //
  //       print('####count.code  true >>>$count.) $code');
  //     }
  //   });
  // }
  //
  // Future<Null> checkFalse(syntxt) async {
  //   await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('product2')
  //       .where('statusOK', isEqualTo: false)
  //       .where('itemCategory', isEqualTo: syntxt)
  //       .snapshots()
  //       .listen((event) async {
  //     int count = 0;
  //     for (var item in event.docs) {
  //       String code = item.id;
  //       count++; //
  //       print('####count.code  true >>>$count.) $code');
  //     }
  //   });
  // }

  Future getNumMax() async {
    QuerySnapshot qsMax = await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('wawaproduct04')
        .get();
    int _i = 0;
    for (var item in qsMax.docs) {
      setState(() {
        _i = _i + 1;
      });
    }

    setState(() {
      numx = _i;
    });
    print('####numx>>>$numx');
    getMin();
  }

  Future<Null> freshDataByCategory(int minNumber, int maxNumber) async {
    await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        // .collection('product2')
        // .limit(300)

        // .where('itemCategory', isEqualTo: syntxt)
        .collection('wawaproduct04')
        //.orderBy('no')
        .where('no', isGreaterThanOrEqualTo: minNumber)
        .where('no', isLessThanOrEqualTo: maxNumber)
        //.limit(10)
        .snapshots()
        .listen((event) async {
      // print('###event>>>${event.docs}');
      int number = minNumber;
      for (var item in event.docs) {
        String code = item['productId'];
        print('####$number code>>>>$code');
        //   number++;
        // }
        try {
          String urlAPI =
              'http://43.229.149.11:8086/SMLJavaRESTService/v3/api/product/$code';
          Map<String, String> headers = Map();
          headers['GUID'] = 'smlx';
          headers['provider'] = 'DATA';
          headers['databasename'] = 'wawa2';
          headers['configFileName'] = 'SMLConfigDATA.xml';

          await Dio()
              .get(urlAPI, options: Options(headers: headers))
              .then((value2) async {
            print('value2==>${value2.toString()}');
            var _name = '';
            if (value2.data['data']['name'] != null) {
              _name = value2.data['data']['name'];
            }
            // //off เพื่อรู้ว่าตัวไหน error
            var _image = 'none';
            if (value2.data['data']['images'] != null) {
              _image = value2.data['data']['images'][0]['uri'];
            }

            //var _image = value2.data['data']['images'][0]['uri'];

            var _categoryName = '';
            if (value2.data['data']['category_name'] != null) {
              _categoryName = value2.data['data']['category_name'];
            }

            var _itemCategory = '';
            if (value2.data['data']['item_category'] != null) {
              _itemCategory = value2.data['data']['item_category'];
            }

            //work แต่ไม่รู้ว่า error ตรงไหน
            var priceFormulas = [];

            if (value2.data['data']['price_formulas'].toString().length > 0) {
              priceFormulas = value2.data['data']['price_formulas'];
              print('######priceFormulas>>>${priceFormulas.toString()}');
            }

            // if (value2.data['data']['price_formulas'] != null) {
            //var priceFormulas = value2.data['data']['price_formulas'];
            //   priceFormulas = value2.data['data']['price_formulas'];
            // }
            // if (priceFormulas.length != 0) {
            //   priceFormulas = value2.data['data']['price_formulas'];
            // //  print('######priceFormulas>>>${priceFormulas.toString()}');
            // }

            // //error จะดีกว่า จะได้รู้ว่ารหัสอะไร

            var isPremium = false;
            if (value2.data['data']['is_premium'] != null) {
              isPremium = value2.data['data']['is_premium'];
            }
            //add 16-6-2021
            var isHoldSale = false;
            if (value2.data['data']['is_hold_sale'] != null) {
              isHoldSale = value2.data['data']['is_hold_sale'];
            }

            var isHoldPurchase = false;
            if (value2.data['data']['is_hold_purchase'] != null) {
              isHoldPurchase = value2.data['data']['is_hold_purchase'];
            }

            var brandName = 'zzz';
            if (value2.data['data']['brand_name'] != null) {
              brandName = value2.data['data']['brand_name'];
            }

            var groupMainName = 'yyy';
            if (value2.data['data']['group_main_name'] != null) {
              groupMainName = value2.data['data']['group_main_name'];
            }

            Map<String, dynamic> mapName = Map();
            mapName['name'] = _name;
            mapName['urlImage'] = _image;
            mapName['categoryName'] = _categoryName;
            mapName['itemCategory'] = _itemCategory;
            mapName['isPremium'] = isPremium;
            mapName['isHoldSale'] = isHoldSale;
            mapName['isHoldPurchase'] = isHoldPurchase;
            mapName['statusOK'] = true;
            mapName['brandName'] = brandName;
            mapName['groupMainName'] = groupMainName;

            await FirebaseFirestore.instance
                .collection('wawastore')
                .doc('wawastore')
                .collection('product2')
                .doc(code)
                .set(mapName);
            //clear all if value != 0;

            for (var i = 0; i < priceFormulas.length; i++) {
              // print('########code ==>>> $code');
              // print(
              //     '########priceFormulas#$i-[unit_code] ==>>> ${priceFormulas[i]['unit_code']}');
              // print(
              //     '########priceFormulas#$i-[price_0] ==>>> ${priceFormulas[i]['price_0']}');

              await FirebaseFirestore.instance
                  .collection('wawastore')
                  .doc('wawastore')
                  .collection('product2')
                  .doc(code)
                  .collection('unit_codes')
                  .doc(priceFormulas[i]['unit_code'])
                  .set({
                "price0": num.parse(priceFormulas[i]['price_0'].toString()),
                "unit_code": priceFormulas[i]['unit_code'],
              }).then((value) {
                print('inserted Success>>>${priceFormulas[i]['unit_code']}');
              });
            }
          });
          setState(() {
            numm = number;
          });
          double _numm = numm.toDouble();
          double _nummax = numx.toDouble();
          // double _v = _numm/_nummax;
          double _v2 = _numm * 0.5 / _nummax;
          setState(() {
            uploadPer = _v2;
          });

          //  print('######_value>>>$_value'); //

          number++;
          print('######number>>>$number'); // end.

        } on DioError catch (e) {
          if (number < 400) {
            if (numm <= numx) {
              freshDataByCategory(numm, numx);
            }
          } else {
            // sleepTime20();
            if (numm <= numx) {
              freshDataByCategory(numm, numx);
            }
          }

          //error
          if (e.response!.statusCode == 404) {
            print('#####e.response.statusCode>>>${e.response!.statusCode}');
          } else {
            print('#####e.message>>>${e.message}');
            // print('#####e.request>>>${e!.request}');
          }
        }
      } // loop for
    });
    // });
  }

  Future<Null> updateByCode(code) async {
    // await FirebaseFirestore.instance
    //     .collection('wawastore')
    //     .doc('wawastore')
    // // .collection('product2')
    // // .limit(300)
    //
    // // .where('itemCategory', isEqualTo: syntxt)
    //     .collection('wawaproduct04')
    // //.orderBy('no')
    //     .where('no', isGreaterThanOrEqualTo: minNumber)
    //     .where('no', isLessThanOrEqualTo: maxNumber)
    // //.limit(10)
    //     .snapshots()
    //     .listen((event) async {
    // print('###event>>>${event.docs}');

    // for (var item in event.docs) {
    //   String code = item['productId'];
    //   print('####$number code>>>>$code');
    //   number++;
    // }

    // int number = 0;
    try {
      String urlAPI =
          'http://43.229.149.11:8086/SMLJavaRESTService/v3/api/product/$code';
      Map<String, String> headers = Map();
      headers['GUID'] = 'smlx';
      headers['provider'] = 'DATA';
      headers['databasename'] = 'wawa2';
      headers['configFileName'] = 'SMLConfigDATA.xml';

      await Dio()
          .get(urlAPI, options: Options(headers: headers))
          .then((value2) async {
        print('value2==>${value2.toString()}');
        var _name = '';
        if (value2.data['data']['name'] != null) {
          _name = value2.data['data']['name'];
        }
        // //off เพื่อรู้ว่าตัวไหน error
        var _image = 'none';
        if (value2.data['data']['images'] != null) {
          _image = value2.data['data']['images'][0]['uri'];
        }

        //var _image = value2.data['data']['images'][0]['uri'];

        var _categoryName = '';
        if (value2.data['data']['category_name'] != null) {
          _categoryName = value2.data['data']['category_name'];
        }

        var _itemCategory = '';
        if (value2.data['data']['item_category'] != null) {
          _itemCategory = value2.data['data']['item_category'];
        }

        //work แต่ไม่รู้ว่า error ตรงไหน
        var priceFormulas = [];

        if (value2.data['data']['price_formulas'] != [] ||
            value2.data['data']['price_formulas'].toString().isNotEmpty) {
          priceFormulas = value2.data['data']['price_formulas'];
          print('######priceFormulas>>>${priceFormulas.toString()}');
        }

        // if (value2.data['data']['price_formulas'] != null) {
        //var priceFormulas = value2.data['data']['price_formulas'];
        //   priceFormulas = value2.data['data']['price_formulas'];
        // }
        // if (priceFormulas.length != 0) {
        //   priceFormulas = value2.data['data']['price_formulas'];
        // //  print('######priceFormulas>>>${priceFormulas.toString()}');
        // }

        // //error จะดีกว่า จะได้รู้ว่ารหัสอะไร

        var isPremium = false;
        if (value2.data['data']['is_premium'] != null) {
          isPremium = value2.data['data']['is_premium'];
        }
        //add 16-6-2021
        var isHoldSale = false;
        if (value2.data['data']['is_hold_sale'] != null) {
          isHoldSale = value2.data['data']['is_hold_sale'];
        }

        var isHoldPurchase = false;
        if (value2.data['data']['is_hold_purchase'] != null) {
          isHoldPurchase = value2.data['data']['is_hold_purchase'];
        }

        var brandName = 'zzz';
        if (value2.data['data']['brand_name'] != null) {
          brandName = value2.data['data']['brand_name'];
        }

        var groupMainName = 'yyy';
        if (value2.data['data']['group_main_name'] != null) {
          groupMainName = value2.data['data']['group_main_name'];
        }

        Map<String, dynamic> mapName = Map();
        mapName['name'] = _name;
        mapName['urlImage'] = _image;
        mapName['categoryName'] = _categoryName;
        mapName['itemCategory'] = _itemCategory;
        mapName['isPremium'] = isPremium;
        mapName['isHoldSale'] = isHoldSale;
        mapName['isHoldPurchase'] = isHoldPurchase;
        mapName['statusOK'] = true;
        mapName['brandName'] = brandName;
        mapName['groupMainName'] = groupMainName;

        var collection = FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('product2')
            .doc(code)
            .collection('unit_codes');

        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete(); //for loop delete in firebase
        }

        //clear old code  || delete data by code in searchDB mySQL***
        // deleteApi(code);
        deleteApi(code, _name, _image, isHoldSale, isHoldPurchase);

        await FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('product2')
            .doc(code)
            .set(mapName);
        //clear all if value != 0;

        for (var i = 0; i < priceFormulas.length; i++) {
          // print('########code ==>>> $code');
          // print(
          //     '########priceFormulas#$i-[unit_code] ==>>> ${priceFormulas[i]['unit_code']}');
          // print(
          //     '########priceFormulas#$i-[price_0] ==>>> ${priceFormulas[i]['price_0']}');

          await FirebaseFirestore.instance
              .collection('wawastore')
              .doc('wawastore')
              .collection('product2')
              .doc(code)
              .collection('unit_codes')
              .doc(priceFormulas[i]['unit_code'])
              .set({
            "price0": num.parse(priceFormulas[i]['price_0'].toString()),
            "unit_code": priceFormulas[i]['unit_code'],
          }).then((value) {
            print('inserted Success>>>${priceFormulas[i]['unit_code']}');
          });
        }
      });
      // setState(() {
      //   numm = number;
      //
      // });
      // double _numm = numm.toDouble();
      // double _nummax = numx.toDouble();
      // // double _v = _numm/_nummax;
      // double _v2 = _numm*0.5/_nummax;
      // setState(() {
      //   uploadPer = _v2;
      // });

      //  print('######_value>>>$_value'); //

      // number++;
      // print('######number>>>$number'); // end.
      //

    } on DioError catch (e) {
      // if(number < 400){
      //   if(numm <= numx){
      //     freshDataByCategory(numm, numx);
      //   }
      //
      //
      // }else{
      //   // sleepTime20();
      //   if(numm <= numx){
      //     freshDataByCategory(numm, numx);
      //   }
      // }
      //
      // //error
      // if (e.response.statusCode == 404) {
      //   print('#####e.response.statusCode>>>${e.response.statusCode}');
      // } else {
      //   print('#####e.message>>>${e.message}');
      //   // print('#####e.request>>>${e!.request}');
      // }
    }
    // }// loop for
    // });
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getMin() async {
    String _numm = await helper.getStorage('numm');

    if (_numm != null) {
      int _no = int.parse(_numm);
      if (_no >= numx - 1) {
        setState(() {
          _no = 0;
        });
      }
      setState(() {
        numm = _no;
      });
      print('####getMin=>>>numm>>$numm, _no>>>$_no');
    }
  }

  // Future sleepTime() async{
  //   Duration duration = Duration(seconds: 3);
  //   await Timer(duration, (){
  //     if(numm <= numx){
  //       freshDataByCategory(numm, numx);
  //     }
  //
  //   });
  // }

  Future sleepTime20() async {
    Duration duration = Duration(seconds: 3);
    await Timer(duration, () {
      if (numm <= numx) {
        freshDataByCategory(numm, numx);
      }
    });
  }

  Container buildUser() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        controller: productCtrl,
        keyboardType: TextInputType.text,
        //onChanged: (value) => user = value.trim(),
        style: TextStyle(color: MyStyle().darkColor, fontSize: 28),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: MyStyle().darkColor),
          hintText: 'รหัสสินค้า :',
          prefixIcon: Icon(
            Icons.list_alt,
            color: MyStyle().darkColor,
            size: 28,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    // double _percent = 0;
    // if(numx == 0){
    //   _percent = numm*100/1;
    //
    // }else{
    //    _percent = numm*100/numx;
    //
    // }

    // genderModelList = [
    //   GenderModel('001', "ของใช้อื่นๆ"),
    //   GenderModel('002', "ข้าวสาร/เครื่องปรุง/อาหารแห้ง"),
    //   GenderModel('004', "เครื่องดื่ม/นม"),
    //   GenderModel('005', "แอลกอฮอล"),
    //   GenderModel('006', "บุหรี่"),
    //   GenderModel('007', "สินค้า แลกเปลี่ยน"),
    // ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text('เพิ่มรายการสินค้า /อัพเดท แบบที่ละรายการ'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 40,
            ),

            loading ? Container() : buildUser(),
            // Row(mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 50,
            //       child: TextField(
            //         controller: productCtrl,
            //         decoration: InputDecoration(
            //           hintText: "พิมพ์รหัสสินค้า",
            //           border: InputBorder.none,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(
              height: 10,
            ),

            //start
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (productCtrl.text.isNotEmpty) {
                      setState(() {
                        loading = true;
                      });
                      saveData(productCtrl.text.trim());
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: const Color(0xffa5a9aa),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      'บันทึก',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )

            //end
          ],
        )

        // Form(
        //     key: _formKey,
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           SizedBox(height: 30,),

// Start
//       Column(
//       //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           _AnimatedLiquidCircularProgressIndicator(percentUpload: uploadPer),
//           SizedBox(height: 30,),
//
//           Row(mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('${myFormat.format(_percent)}%',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700,color: Colors.red),),
//             ],
//           ),
//
//           SizedBox(height: 50,),
//
//           ElevatedButton.icon(color: Colors.grey,
//
//               onPressed: () async {
//             Navigator.of(context).pop();
//             await helper.setStorage('numm', numm.toString());
//           }, icon: Icon(Icons.close,size: 32,color: Colors.white,), label: Text('จบการทำงาน',style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w700),)),
//
//           SizedBox(height: 50,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               SizedBox(
//                 width: 75,
//                 height: 75,
//                 child: LiquidCircularProgressIndicator(
//                   backgroundColor: Colors.black,
//                   valueColor: AlwaysStoppedAnimation(Colors.red),
//                 ),
//               ),
//               SizedBox(
//                 width: 75,
//                 height: 75,
//                 child: LiquidCircularProgressIndicator(
//                   backgroundColor: Colors.white,
//                   valueColor: AlwaysStoppedAnimation(Colors.pink),
//                   borderColor: Colors.red,
//                   borderWidth: 5.0,
//                   direction: Axis.horizontal,
//                 ),
//               ),
//               SizedBox(
//                 width: 75,
//                 height: 75,
//                 child: LiquidCircularProgressIndicator(
//                   backgroundColor: Colors.white,
//                   valueColor: AlwaysStoppedAnimation(Colors.grey),
//                   borderColor: Colors.blue,
//                   borderWidth: 5.0,
//                   center: Text(
//                     "Loading...",
//                     style: TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 75,
//                 height: 75,
//                 child: LiquidCircularProgressIndicator(
//                   backgroundColor: Colors.lightGreen,
//                   valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
//                   direction: Axis.horizontal,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
        );
  }

  Future<void> deleteApi(String item, String _name, String _image,
      bool isHoldSale, bool isHoldPurchase) async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    Response response;
    var dio = Dio();
    response = await dio.post('https://smartappdesigns.com:8083/delete',
        options: Options(headers: headers),
        data: {
          'code': item,
        });

    print('####action = deleted MySQL seardDB>>>>$response');

    //Insert search in MySQL DB***
    insertDataApi(item, "null", 0, _name, _image, isHoldSale, isHoldPurchase);
  }

  Future<void> insertDataApi(String item, String unitCode, int price,
      String name, String image, bool isHoldSale, bool isHoldPurchase) async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    Response response;
    var dio = Dio();
    response = await dio.post('https://smartappdesigns.com:8083/create',
        options: Options(headers: headers),
        data: {
          'code': item,
          'unit': unitCode,
          'price': price,
          'productname': name,
          'urlImage': image,
          'isholdsale': isHoldSale,
          'isholdpurchase': isHoldPurchase
        });

    print('####action = Inserted MySQL searchDB>>>>$response');
  }

  Future saveData(String txt) async {
    QuerySnapshot qsText = await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('wawaproduct04')
        .where('productId', isEqualTo: txt)
        .get();
    if (qsText.docs.isNotEmpty) {
      //มีแล้ว ให้ update
      // updateProduct(txt);
      updateByCode(txt);
      Fluttertoast.showToast(msg: "ระบบได้อัพเดทรายการสินค้าแล้วครับ");
      setState(() {
        loading = false;
      });
    } else {
      //ไม่มี  insert then update
      // insertProduct(txt);
      String urlAPI =
          'http://43.229.149.11:8086/SMLJavaRESTService/v3/api/product/$txt';
      Map<String, String> headers = Map();
      headers['GUID'] = 'smlx';
      headers['provider'] = 'DATA';
      headers['databasename'] = 'wawa2';
      headers['configFileName'] = 'SMLConfigDATA.xml';
      await Dio()
          .get(urlAPI, options: Options(headers: headers))
          .then((value2) async {

        print('####images===${value2.data['images']}');
        // print('####value2==>${value2.toString()}');
        // //print('####value2.statusCode${value2.statusCode}');
        // print('####value2.data[\'success\']>>>>${value2.data['success']}');
        // insertProduct(txt);

        if (value2.data['success'] == false) {
          // Fluttertoast.showToast(msg: "รหัสสินค้านี้ error นะครับ ต้องแก้ไขก่อน!!!",fontSize: 22,textColor: Colors.red);
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'รหัสสินค้านี้ error!!! ไม่พบข้อมูลบน sml*1 ต้องแก้ไขก่อนครับ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            // color: Colors.brown[600]
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 32,
                                color: Colors.red[400],
                              ),
                              label: Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[400]),
                              ),
                            ),
                            // ElevatedButton.icon(
                            //   onPressed: () async {
                            //     Navigator.pop(context);
                            //
                            //     await FirebaseFirestore.instance
                            //         .collection('wawastore')
                            //         .doc('wawastore')
                            //         .collection('addcart')
                            //         .doc(index)
                            //         .delete().then((value) {
                            //       readCart();
                            //       widget.onAdItem();
                            //
                            //     });
                            //
                            //
                            //
                            //
                            //     // await SQLiteHelper()
                            //     //     .deleteDataById(sqliteModels[index].id!)
                            //     //     .then((value) {
                            //     //   readCart();
                            //     //   // widget.onAdItem();
                            //     // });
                            //   },
                            //   icon: Icon(Icons.check,
                            //       size: 32, color: Colors.green[500]),
                            //   label: Text(
                            //     'ยืนยัน',
                            //     style: TextStyle(
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.green[500]),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ));
        } else if (value2.data['data'] == null ||
            value2.data['data'] == "null") {
          // Fluttertoast.showToast(msg: "รหัสสินค้านี้ error นะครับ ต้องแก้ไขก่อน!!!",fontSize: 22,textColor: Colors.red);
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'รหัสสินค้านี้ error!!! ไม่พบข้อมูลในฐานข้อมูล sml*2 ต้องแก้ไขก่อนครับ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            // color: Colors.brown[600]
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 32,
                                color: Colors.red[400],
                              ),
                              label: Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[400]),
                              ),
                            ),
                            // ElevatedButton.icon(
                            //   onPressed: () async {
                            //     Navigator.pop(context);
                            //
                            //     await FirebaseFirestore.instance
                            //         .collection('wawastore')
                            //         .doc('wawastore')
                            //         .collection('addcart')
                            //         .doc(index)
                            //         .delete().then((value) {
                            //       readCart();
                            //       widget.onAdItem();
                            //
                            //     });
                            //
                            //
                            //
                            //
                            //     // await SQLiteHelper()
                            //     //     .deleteDataById(sqliteModels[index].id!)
                            //     //     .then((value) {
                            //     //   readCart();
                            //     //   // widget.onAdItem();
                            //     // });
                            //   },
                            //   icon: Icon(Icons.check,
                            //       size: 32, color: Colors.green[500]),
                            //   label: Text(
                            //     'ยืนยัน',
                            //     style: TextStyle(
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.green[500]),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ));
        }
        // else if (value2.data['images'] == []) {
        //   // Fluttertoast.showToast(msg: "รหัสสินค้านี้ error นะครับ ต้องแก้ไขก่อน!!!",fontSize: 22,textColor: Colors.red);
        //   showDialog(
        //       context: context,
        //       builder: (context) => SimpleDialog(
        //             title: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: const [
        //                 Text(
        //                   'รหัสสินค้านี้ ไม่มีรูปภาพ !!! ต้องแก้ไขก่อนครับ',
        //                   style: TextStyle(
        //                     fontSize: 22,
        //                     fontWeight: FontWeight.bold,
        //                     // color: Colors.brown[600]
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(left: 20, right: 20),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
        //                     ElevatedButton.icon(
        //                       onPressed: () {
        //                         setState(() {
        //                           loading = false;
        //                         });
        //                         Navigator.pop(context);
        //                       },
        //                       icon: Icon(
        //                         Icons.clear,
        //                         size: 32,
        //                         color: Colors.red[400],
        //                       ),
        //                       label: Text(
        //                         'OK',
        //                         style: TextStyle(
        //                             fontSize: 20,
        //                             fontWeight: FontWeight.bold,
        //                             color: Colors.red[400]),
        //                       ),
        //                     ),
        //                     // ElevatedButton.icon(
        //                     //   onPressed: () async {
        //                     //     Navigator.pop(context);
        //                     //
        //                     //     await FirebaseFirestore.instance
        //                     //         .collection('wawastore')
        //                     //         .doc('wawastore')
        //                     //         .collection('addcart')
        //                     //         .doc(index)
        //                     //         .delete().then((value) {
        //                     //       readCart();
        //                     //       widget.onAdItem();
        //                     //
        //                     //     });
        //                     //
        //                     //
        //                     //
        //                     //
        //                     //     // await SQLiteHelper()
        //                     //     //     .deleteDataById(sqliteModels[index].id!)
        //                     //     //     .then((value) {
        //                     //     //   readCart();
        //                     //     //   // widget.onAdItem();
        //                     //     // });
        //                     //   },
        //                     //   icon: Icon(Icons.check,
        //                     //       size: 32, color: Colors.green[500]),
        //                     //   label: Text(
        //                     //     'ยืนยัน',
        //                     //     style: TextStyle(
        //                     //         fontSize: 20,
        //                     //         fontWeight: FontWeight.bold,
        //                     //         color: Colors.green[500]),
        //                     //   ),
        //                     // ),
        //                   ],
        //                 ),
        //               )
        //             ],
        //           ));
        // }
        else if (value2.data['price_formulas'] == [] ) {
          // Fluttertoast.showToast(msg: "รหัสสินค้านี้ error นะครับ ต้องแก้ไขก่อน!!!",fontSize: 22,textColor: Colors.red);
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'รหัสสินค้านี้ error!!! ไม่พบข้อมูลราคาจ้า ต้องแก้ไขก่อนครับ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            // color: Colors.brown[600]
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 32,
                                color: Colors.red[400],
                              ),
                              label: Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[400]),
                              ),
                            ),
                            // ElevatedButton.icon(
                            //   onPressed: () async {
                            //     Navigator.pop(context);
                            //
                            //     await FirebaseFirestore.instance
                            //         .collection('wawastore')
                            //         .doc('wawastore')
                            //         .collection('addcart')
                            //         .doc(index)
                            //         .delete().then((value) {
                            //       readCart();
                            //       widget.onAdItem();
                            //
                            //     });
                            //
                            //
                            //
                            //
                            //     // await SQLiteHelper()
                            //     //     .deleteDataById(sqliteModels[index].id!)
                            //     //     .then((value) {
                            //     //   readCart();
                            //     //   // widget.onAdItem();
                            //     // });
                            //   },
                            //   icon: Icon(Icons.check,
                            //       size: 32, color: Colors.green[500]),
                            //   label: Text(
                            //     'ยืนยัน',
                            //     style: TextStyle(
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.green[500]),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ));
        } else {
          insertProduct(txt);
        }
      });
    }
  }

  void updateProduct(String productCode) {
    Fluttertoast.showToast(
        msg: "ระบบได้อัพเดทรายการสินค้าแล้วครับ",
        fontSize: 20,
        textColor: Colors.green);
  }

  Future<void> insertProduct(String txt) async {
    int _i = 0;
    try {
      QuerySnapshot qsDashboard = await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('wawaproduct04')
          .orderBy('no', descending: true)
          .limit(5)
          // .where('orderId', isEqualTo: _uId)
          .get();
      if (qsDashboard.docs.length != 0) {
        setState(() {
          _i = qsDashboard.docs[0]['no'];
        });

        await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('wawaproduct04')
            .add({"no": _i + 1, "productId": txt}).then((_) {
          updateByCode(txt);
          Fluttertoast.showToast(
              msg: "ระบบได้อัพเดทรายการสินค้าแล้วครับ",
              fontSize: 20,
              textColor: Colors.green);
          setState(() {
            loading = false;
          });
        });
      }
      print('_i>>>$_i');
    } catch (e) {
      print('error==>>${e.toString()}');
    }
  }
}
