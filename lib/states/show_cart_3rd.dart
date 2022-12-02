import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:wawa/authen.dart';
import 'package:wawa/models/sqlite_model.dart';
import 'package:wawa/states/home.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/widget/progress_dialog.dart';
import 'package:http/http.dart' as http;


class ShowCart extends StatefulWidget {
  final Function onAdItem;
  ShowCart({required this.onAdItem});
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  final dbRef = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMsg = TextEditingController();
  TextEditingController ctrlMsg2 = TextEditingController();
  TextEditingController ctrlDatetime = TextEditingController();
  List<SQLiteModel> sqliteModels = [];
  List<String> delID = [];
  SQLiteModel? sqLiteModel;
  // List<SQLiteModel<Map, dynamic>> sqliteModels = List();
  bool statusLoad = false;

  //String codeSML = 'AR00075';
  String codeSML = 'AR00006';
  String codeSale = '1056';
  List<List<String>> listunitcodes = [];
  List<List<String>> listPrices = [];
  List<String> models = [];
  List<Map<String, dynamic>> modelss = [];
  int no = 1;
  double total = 0;
  int index2 = 0;
  String? dateTimeStr, timeStr ;
 String pathAPI = 'http://43.229.149.11:8086/SMLJavaRESTService/restapi/sales/quotation';

  String emName = 'none';
  String emmail = 'none';
  String emCode = 'none';
  String emTel = '0000';
  String emNote = 'none';
  bool nodelivery = false;
  bool delivery = false;
  bool btnSave = true;
  bool showBtnSave = true;

  double lat2 = 17.1284055;
  double lng2 = 102.9624795;
  Helper helper = Helper();
  DateTime? dateTime;
  String? _way;
  List<DropdownMenuItem<String>> listDrop = [];
  String hint = 'เลือกพนักงานขาย';
  var myFormat = NumberFormat('##0.0', 'en_US');

  Future<void> loadData() async {


    if (listDrop.isNotEmpty) {
    } else {
      QuerySnapshot querySale = await dbRef  //ยังดึงข้อมูลได้อยู่นะ web***
          .collection('wawastore')
          .doc('wawastore')
          .collection('saleMans')
          .orderBy('saleName', descending: false)
          .get();

      if (querySale.docs.isNotEmpty) {
        for (var item in querySale.docs) {
          setState(() {
            listDrop.add(
              DropdownMenuItem(
                child: Text(
                  'ชื่อ:${item['saleName']}, รหัสพนักงาน: ${item['code']}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                value: '${item['code']}',
              ),
            );
          });
        }
      }
    }
  }

  // Future<LocationData> findLocationData() async {
  //   Location location = Location();
  //   try {
  //     return location.getLocation();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<void> confirmDelete(SQLiteModel sqLiteModelDelete) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'ยืนยันการลบรายการ',
                    style: TextStyle(
                      fontSize: 18,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.black,
                        ),

                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 32,
                          color: Colors.white,
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          await FirebaseFirestore.instance
                              .collection('wawastore')
                              .doc('wawastore')
                              .collection('addcart')
                          .where('name', isEqualTo: sqLiteModelDelete.name)
                          .where('units', isEqualTo: sqLiteModelDelete.units)
                              .where('uid', isEqualTo: sqLiteModelDelete.uid)
                          .get().then((value) async {

                            await FirebaseFirestore.instance
                                .collection('wawastore')
                                .doc('wawastore')
                                .collection('addcart')
                                .doc(value.docs[0].id)
                                .delete().then((value) {
                              readCart();
                              widget.onAdItem();

                            });

                          });






                          // await SQLiteHelper()
                          //     .deleteDataById(sqliteModels[index].id!)
                          //     .then((value) {
                          //   readCart();
                          //   // widget.onAdItem();
                          // });
                        },
                        icon: Icon(Icons.check,
                            size: 32, color: Colors.white),
                        label: Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future<void> confirmOrder() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'ยืนยันการสั่งซื้อ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      // color: Colors.brown[700]
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.black,
                        ),

                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 32,
                          color: Colors.white,
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          setState(() {
                            btnSave = !btnSave;
                          });

                          sendDataToSML(context);
                          // if (lat1 == 0) {
                          //   normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                          //       'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสั่งซื้อครับ');
                          // } else {
                          //   // normalDialog(
                          //   //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                          // }
                        },
                        icon: Icon(Icons.check,
                            size: 32, color: Colors.white),
                        label: Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future<void> getDataUser() async {
    // String _uid = await helper.getStorage('uid');
    String? _uid =  FirebaseAuth.instance.currentUser!.uid;
    print('####_uid/show_cart.dart>>>$_uid');

    if (_uid.isEmpty) {
      Navigator.of(context).pushNamed('/authen');
    } else {
       await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('backend')
          .where('uid', isEqualTo: _uid)
          .get().then((value) {
            if (value.docs.isNotEmpty) {

                setState(() {
                  emName = value.docs[0]['displayName'];
                  emmail = value.docs[0]['email'];
                  // emCode = snapshot.docs[0]['employeeCode'];
                  codeSML = value.docs[0]['employeeCode'].toString().toUpperCase();
                  emTel = value.docs[0]['tel'];
                });

                // print('####emName>>>$emName, emmail>>>$emmail, codeSML>>>$codeSML, emTel>>>$emTel');




            }
       });


    }
  }

  // getData() async{
  //   Map<String, String> headers = {};
  //
  //   headers['GUID'] = 'smlx';
  //   headers['provider'] = 'DATA';
  //   headers['configFileName'] = 'SMLConfigDATA.xml';
  //   headers['databasename'] = 'wawa2';
  //   // headers['Content-Type'] = 'application/json';
  //
  //
  //   Dio dio = Dio();
  //
  //   try {
  //  Response response =   await dio.get('http://43.229.149.11:8086/SMLJavaRESTService/v3/api/product/17-0102', options: Options(headers: headers));
  //  print('####response start' );
  //  print(response.data);
  //  print(response.headers);
  //  print(response.requestOptions);
  //  print(response.statusCode);
  //  print('####response end' );
  //
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       print('####DioError catch (e) start' );
  //       print(e.response!.data);
  //       print(e.response!.headers);
  //       print(e.response!.requestOptions);
  //       print('####DioError catch (e) end' );
  //     } else {
  //       // Something happened in setting up or sending the request that triggered an Error
  //       print('####DioError catch (e) start' );
  //       print(e.requestOptions);
  //       print(e.message);
  //       print('####DioError catch (e) end' );
  //     }
  //     // TODO
  //   }
  //
  //
  //
  //
  // }


  checkShowButton() async{
    await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('showAndHide')
    .doc('showAndHide')

        .get().then((value) {
          if (value.exists) {
            bool _btnSave = value['showButtonOne'];
            print('####_btnSave>>>>$_btnSave');
            setState(() {
              showBtnSave = _btnSave;
            });


          }

    });

  }

 // Future<void> checkLogin()  async{
 //   String _uid = FirebaseAuth.instance.currentUser!.uid;
 //    if (_uid.isEmpty) {
 //      Navigator.of(context).push(MaterialPageRoute(
 //        builder: (context) => Authen(),
 //      ));
 //      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=> Authen()), (route) => false);
 //
 //    }
 //  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    //checkLogin();

    getDataUser();
    readCart();
    loadData();
    checkShowButton();

    // getData();

    //findLat1Lng1();
    dateTime = DateTime.now();
    // findLatLng();
    print('#####you in show_cart.dart');
  }

  // Future<Null> insertMySQL(
  //     String docno, String doctime, String uid, double total) async {}

  // Future<String> networkImageToBase64(String imageUrl) async {
  //   http.Response response = await http.get(imageUrl);
  //   final bytes = response?.bodyBytes;
  //   return (bytes != null ? base64Encode(bytes) : null);
  // }

  Future<void> sendDataToSML(BuildContext context) async {
    //await  getDataUser();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            message: "กรุณารอระบบกำลังบันทึกข้อมูลครับ...",
          );
        });

    String? _uid =  FirebaseAuth.instance.currentUser!.uid;
    //await helper.getStorage('uid');
    setState(() {
      // statusLoad = true;
    //   // sqliteModels.clear();
    //   // models.clear();
    //   // total = 0;
    });

    // QuerySnapshot qsUser = await dbRef
    //     .collection('wawastore')
    //     .doc('wawastore')
    //     .collection('backend')
    //     .where('uid', isEqualTo: _uid)
    //     .get();

    // if (qsUser.docs.isNotEmpty) {
      // setState(() {
      //   emName = qsUser.docs[0]['displayName'];
      //   emmail = qsUser.docs[0]['email'];
      //   // emCode = snapshot.docs[0]['employeeCode'];
      //   codeSML = qsUser.docs[0]['employeeCode'].toString().toUpperCase();
      //   emTel = qsUser.docs[0]['tel'];
      // });

      //
      // helper.setStorage('emTel', emTel);
    // }

    // try {

      //
      // await SQLiteHelper().readSQLite().then((value) async {
      //   for (var string in value) {
      //     // print('string.barcodes>>>${string.barcodes}');
      //
      //     String sumString = string.subtotals;
      //     double sumDouble = double.parse(sumString);
      //     setState(() {
      //       total = total + sumDouble;
      //       sqliteModels.add(string);
      //       // var _jso = jsonEncode(string.toJsonzz());
      //       // print('_jso==>>$_jso');
      //       // models.add(_jso);
      //       var _jso = (string.toJsonzz());
      //       modelss.add(string.toJsonzz());
      //       //add data to modelss list()
      //
      //       // models.add(string.toJsonzz().toString());
      //     });
      //   } //end >for
      // });
    // } catch (e) {
    //   print('error SQlite===>${e.toString()}');
    // }

    // for (var page = 8; page <= maxPage; page++) {

    Map<String, String> headers = {};

    headers['provider'] = 'DATA';
    headers['guid'] = 'smlx';
    headers['configFileName'] = 'SMLConfigDATA.xml';
    headers['databaseName'] = 'wawa2';
    // headers['Content-Type'] = 'application/json';

    // headers['Access-Control-Allow-Origin'] = "*";




    Map<String, dynamic> datas = {};
    DateTime dateTime = DateTime.now();
    setState(() {
      dateTimeStr = DateFormat('yyyy-MM-dd').format(dateTime);
      timeStr = DateFormat('HH:mm').format(dateTime);
    });
    Random random = Random();
    int ran = random.nextInt(100);
    int _i = 0;
    try {
      QuerySnapshot qsDashboard = await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('genNo2')
          .orderBy('getno', descending: true)
          .limit(5)
          // .where('orderId', isEqualTo: _uId)
          .get();
      if (qsDashboard.docs.isNotEmpty) {
        setState(() {
          _i = qsDashboard.docs[0]['getno'];
        });

        await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('genNo2')
            .add({
          "getno": _i + 1,
        });
        //     .doc(qsDashboard.docs[0].id)
        //     .update({
        //   "getno": _i + 1,
        // });
      }
      print('_i>>>$_i');
    } catch (e) {
      print('error==>>${e.toString()}');
    }
    String docNo = 'WAWA-${dateTime.millisecondsSinceEpoch}';
    // print('docNo>>>$docNo');

    // datas['doc_no'] = docNo;
    // datas['doc_format_code'] = 'QT';

    // datas['doc_date'] = dateTimeStr; //now()
    // datas['doc_time'] = timeStr; //now()
    // datas['cust_code'] = 'AR00075'; //Gen
    // datas['sale_code'] = '1056';
    // datas['sale_type'] = 0;
    // datas['vat_type'] = 1;
    // datas['vat_rate'] = 7;
    // datas['total_value'] = total;
    // datas['total_discount'] = 0;
    // datas['total_before_vat'] = total / 1.07;
    // datas['total_vat_value'] = total - (total / 1.07);
    // datas['total_except_vat'] = 0;
    // datas['total_after_vat'] = total;
    // datas['total_amount'] = total;
    // datas['cash_amount'] = 0;
    // datas['chq_amount'] = 0;
    // datas['credit_amount'] = 0;
    // datas['tranfer_amount'] = 0;

    // datas['details'] = models;

    // debugPrint('datas>>$datas');
    //  print("LEK###>>>$models");
    // var body2 = {
    //   "doc_no": "$docNo",
    //   "doc_format_code": "QT",
    //   "doc_date": "$dateTimeStr",
    //   "doc_time": "$timeStr",
    //   "cust_code": 'AR00075',
    //   "sale_code": '1056',
    //   "sale_type": 0,
    //   "vat_type": 1,
    //   "vat_rate": 7,
    //   "total_value": total,
    //   "total_discount": 0,
    //   "total_before_vat": total / 1.07,
    //   "total_vat_value": total - (total / 1.07),
    //   "total_except_vat": 0,
    //   "total_after_vat": total,
    //   "total_amount": total,
    //   "details": [
    //     {
    //       "item_code": "01-0152",
    //       "line_number": 0,
    //       "is_permium": 0,
    //       "unit_code": "ลัง12",
    //       "wh_code": "CMI01",
    //       "shelf_code": "CMI420",
    //       "qty": 3,
    //       "price": "2100.0",
    //       "price_exclude_vat": 1962.6168224299065,
    //       "discount_amount": 0,
    //       "sum_amount": "6300.0",
    //       "vat_amount": 137.3831775700935,
    //       "tax_type": 0,
    //       "vat_type": 1,
    //       "sum_amount_exclude_vat": 1962.6168224299065,
    //       "name": "นมผงคาร์เนชั่น1พลัสรสวานิลลา 900กรัม",
    //       "barcode": "08850127058482"
    //     }
    //   ]
    // };

    // String _model = jsonEncode(models);
    // JSONObject obj = new JSONObject(test);
    //
    //
    // try {
    //   QuerySnapshot findSMLCode = await FirebaseFirestore.instance
    //       .collection('wawastore')
    //       .doc('wawastore')
    //       .collection('backend')
    //       .where('uid', isGreaterThanOrEqualTo: uid)
    //       .get();

    //   if (findSMLCode.docs.length > 0) {
    //     for (var item in findSMLCode.docs) {
    //       if (item['employeeCode'] != null) {
    //         setState(() {
    //           codeSML = item['employeeCode'];
    //         });
    //       }
    //     }
    //   }
    // } catch (e) {
    //   print('###error >>>${e.toString()}');
    // }

    var body = {
      "doc_no": docNo,
      "doc_format_code": "QT",
      "doc_date": "$dateTimeStr",
      "doc_time": "$timeStr",
      "cust_code": codeSML,
      "sale_code": codeSale,
      "sale_type": 0,
      "vat_type": 1,
      "vat_rate": 7,

      "total_value": total,
      "total_discount": 0,
      "total_before_vat": total / 1.07,
      "total_vat_value": total - (total / 1.07),
      "total_except_vat": 0,
      "total_after_vat": total,
      "total_amount": total,
      "details": modelss
    };

    //0-test zone
    print('####json===>>>$modelss');

    //1 -test zone

    // var bodyex = jsonEncode(body);

    print('####body>>>$body');

    // FormData formData = new FormData.fromMap({
    //   "doc_no": docNo,
    //   "doc_format_code": "QT",
    //   "doc_date": dateTimeStr,
    //   "doc_time": timeStr,
    //   "cust_code": 'AR00075',
    //   "sale_code": '1056',
    //   "sale_type": 0,
    //   "vat_type": 1,
    //   "vat_rate": 7,
    //   "total_value": total,
    //   "total_discount": 0,
    //   "total_before_vat": total / 1.07,
    //   "total_vat_value": total - (total / 1.07),
    //   "total_except_vat": 0,
    //   "total_after_vat": total,
    //   "total_amount": total,
    //   "details": models
    // });
    // debugPrint('formData==>>$formData.');

    // print(jsonEncode(datas));
    // normalDialog(context, "data", formData);

    // pathAPI =
    //     // '';
    //     'http://43.229.149.11:8080/SMLJavaRESTService/restapi/sales/quotation';
    // http://43.229.149.11:8080/SMLJavaRESTService/restapi/sales/quotation

    // Response response = await Dio().post("http://43.229.149.11:8080/SMLJavaRESTService/restapi/sales/quotation",data: formData,options: Options(headers: headers));
    // print('response==>>>$response');
   //****ปิดไปก่อน ถ้าโอเคที่เหลือค่อย test sml
    print('####headers:>>> $headers');
    print('####data:>>> ${jsonEncode(body)}');
    Dio dio = Dio();
    // try {
    //   // await Dio()
    //   //     .post(pathAPI,
    //   //         options: Options(headers: headers), data: jsonEncode(body))
    //   //     .then((value) async {
    //   //   String _statusCode = value.statusCode.toString();
    //   //   String _statusMessage = value.statusMessage.toString();
    //   //   print('####_statusCode***>>>>$_statusCode');
    //   //   print('####__statusMessage***>>>$_statusMessage');
    //   // });
    //   Response response = await dio.post(pathAPI, options:  Options(headers: headers), data: jsonEncode(body));
    //   print('#####statusCode>>>${response.statusCode.toString()}');
    //   print('#####statusMessage>>>${response.statusMessage.toString()}');
    // } on DioError catch (e) {
    //   print('####e.toString() in erron in process Dio http://43.229.149.11:8080/xxx >>>${e.toString()}');
    // }
    var url = Uri.parse(pathAPI);
    var response = await http.post(url,headers: headers, body: jsonEncode(body));
    print('####Response status: ${response.statusCode}');
    // print('####Response body: ${response.body}');

    // print(await http.read(Uri.parse('https://example.com/foobar.txt')));

    // String uid = await helper.getStorage('uid');
    // print('uid in dio_post>>>$uid');
    // String lineUser = await helper.getStorage('uidLine');

    // await Firebase.initializeApp().then((value) async {
    try {
      // String uid = await helper.getStorage('uid');
      //getDataUser();
      String uid =  FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('Report')
          .add({
        "uid": uid,
        // "way": _way,
        "totalValue": total,
        //
        "time": DateTime.now().millisecondsSinceEpoch,
        "status": "ยืนยันคำสั่งซื้อ",
        "lat": lat2,
        "lng": lng2,
        "docNo": docNo,
        "docTime": timeStr,
        "docDate": dateTimeStr,
        "distance": 0.0,
        "dateRecieve": ctrlDatetime.text,
        "telephone": emTel,
        "displayName": emName,
        "note": ctrlMsg.text.trim(),
        "nodelivery": nodelivery,
        "delivery": delivery,
        "statusCustomer": "รอโทรยืนยันคำสั่งซื้อ",
        "codeSale": codeSale,
        "nameSale": hint
      }).then((value) async {
        //
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
        // try {
        //   notificationToAdmin(docNo, dateTimeStr, total, timeStr);
        // } catch (e) {
        //   print('e.toString() ###Error-notificationToAdmin>>>${e.toString()}');
        // }

        try {
          saveToPdf(docNo, dateTimeStr!, total);
        } catch (e) {
          print('e.toString() #Error-saveToPdf>>>${e.toString()}');
        }

        //  String docno, String docdate, double totolz
        // insertMySQL(docNo, dateTimeStr, uid, total);
        // print('i am passed report!!!');
      });

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => GetGPSPage(docNo: docNo),
      //     ),
      //     (route) => false);
    } catch (e) {
      print('error in insert Report####${e.toString()}');
    }

    // });
    // }).catchError((value) {
    //   print('error in Dio().post method==>>${value.toString()}');
    // });

    // try {
    //   await SQLiteHelper().readSQLite().then((value) async {
    //      String uid = await helper.getStorage('uid');
    //     for (var item in value) {
    //       // item.barcodes
    //       print('item.code>>>${item.code}');

    //       String url =
    //           'http://103.129.14.235/wawastore/addOrder.php?isAdd=true&docno=$docNo&doctime=$dateTimeStr&totals=$total&codes=${item.code}&names=${item.name}&prices=${item.prices}&units=${item.units}&amounts=${item.amounts}&subtotals=${item.subtotals}&picturl=${item.picturl}&uid=$uid';
    //           // 'http://103.129.14.235/wawastore/addOrder.php?isAdd=true&docno=$docNo&doctime=$dateTimeStr&totals=$total&codes=${item.code}&names=${item.name}&prices=${item.prices}&units=${item.units}&amounts=${item.amounts}&subtotals=${item.subtotals}&picturl=${item.picturl}&uid=$uid';
    //       try {
    //         Response response = await Dio().get(url);
    //          print('res>>$response');
    //       } catch (e) {
    //         print('error>> ${e.toString()}');
    //       }

    //             await SQLiteHelper().deleteAllData().then((value) {
    //           Navigator.pop(context);
    //       readCart();
    //     });
    //       // String sumString = string.subtotals;
    //       // double sumDouble = double.parse(sumString);
    //       // setState(() {
    //       //   total = total + sumDouble;
    //       //   sqliteModels.add(string);
    //       //   // var _jso = jsonEncode(string.toJsonzz());
    //       //   // print('_jso==>>$_jso');
    //       //   // models.add(_jso);

    //       //   //add data to modelss list()

    //       //   // models.add(string.toJsonzz().toString());
    //       // });
    //     } //end >for
    //   });
    // } catch (e) {
    //   print('error SQlite===>${e.toString()}');
    // }
    // print(response.data);
    // print(response.headers);
    // print(response.request);
    // print(response.statusCode);

    // } on DioError catch (e) {
    //   print(e.response.data);
    //   print(e.response.headers);
    //   print(e.response.request);

    //   print(e.request.data);
    //   print(e.request);
    //   print(e.message);
    // }
  }

  Future<void> saveToPdf(String docNo, String dateTimeStr, double total) async {

      // await SQLiteHelper().readSQLite().then((value) async {
        // String _uid = await helper.getStorage('uid');
        // String _uId = await helper.getStorage('uid');
    String _uId = FirebaseAuth.instance.currentUser!.uid;
        String _uid = FirebaseAuth.instance.currentUser!.uid;
        // print('####_uId>>>>$_uId');
        int _index = 0;

        await FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('addcart')
            .where('uid', isEqualTo: _uid)
            .get()
            .then((value) async {
          for (var item in value.docs) {
            // final imgBase64Str = await networkImageToBase64(item.picturl);
            // print('imgBase64Str>>>$_index.$imgBase64Str'); //work jaa
            await FirebaseFirestore.instance
                .collection('wawastore')
                .doc('wawastore')
                .collection('product2')
                .doc(item['code'])
                .collection('unit_codes')
                .doc(item['units'])
                .get().then((value) async {
              if (value.exists) {
                num _price0 = value['price0'];

                //have data
                // String sumString = string.subtotals;
                // double sumDouble = double.parse(sumString);
                num sumDouble = item['amounts'] * _price0;
                String _subtotals = myFormat.format(sumDouble);


                // setState(() {
                //   total = total + sumDouble;
                // });


                try {
                  await dbRef
                      .collection('wawastore')
                      .doc('wawastore')
                      .collection('purchase')
                      .add({
                    "docNo": docNo,
                    "dateTimeStr": dateTimeStr,
                    "total": total,//global ไม่บวกเพิ่ม
                    "code": item['code'],
                    "price": _price0.toString(), //item['prices'],
                    "name": item['name'],
                    // "bacode": item.barcodes,
                    "unit": item['units'],
                    "amounts": item['amounts'],
                    "subtotal": _subtotals, //item['subtotals'],
                    "picturl": item['picturl'],
                    // "strpict": imgBase64Str,
                    "time": DateTime
                        .now()
                        .millisecondsSinceEpoch,
                    "uid": _uId,
                    "codeSale": codeSale,
                    "nameSale": hint
                  });

                  //purchase-dashboard

                  QuerySnapshot qsDasboard = await dbRef //worked***
                      .collection('wawastore')
                      .doc('wawastore')
                      .collection('purchase-dashboard')
                      .where('uId', isEqualTo: _uId)
                      .where('docNo', isEqualTo: docNo)
                      .get();

                  if (qsDasboard.docs.isEmpty) {
                    //create
                    await dbRef
                        .collection('wawastore')
                        .doc('wawastore')
                        .collection('purchase-dashboard')
                        .add({
                      "status": 'ยืนยันคำสั่งซื้อ',
                      "docNo": docNo,
                      "dateTimeStr": dateTimeStr,
                      "total": total,//global
                      "uId": _uId,
                      "time": DateTime
                          .now()
                          .millisecondsSinceEpoch,
                    });
                  } else {
                    //update
                    // await dbRef
                    //     .collection('wawastore')
                    //     .doc('wawastore')
                    //     .collection('purchase-dashboard')
                    //     .doc(qsDasboard.docs[0].id)
                    //     .update({
                    //   "time": new DateTime.now().millisecondsSinceEpoch,
                    // });
                  }
                } catch (e) {
                  print('error>>${e.toString()}');
                }
              }
            });
            _index++;
          }
      //  });

          // String url =
          //     // 'http://103.129.14.235/wawastore/addOrder.php?isAdd=true&docno="aa"&doctime="bb"&totals=300.00&codes=${item.code}&names=${item.name}&prices="aa"&units=${item.units}&amounts=1&subtotals="bb"&picturl=${item.picturl}&uid=$uid';
          //     'http://103.129.14.235/wawastore/addOrder.php?isAdd=true&docno=$docNo&docdate=$dateTimeStr&totals=$total&codes=${item.code}&names=${item.name}&prices=${item.prices}&units=${item.units}&amounts=${item.amounts}&subtotals=${item.subtotals}&picturl="image"&uid=$uid';
          // try {
          //   Response response = await Dio().get(url);
          //   print('res>>$response');
          // } catch (e) {
          //   print('error>> ${e.toString()}');
          // }
          // print('url>>>$url');

       // } //end >for
      }).then((_) async {


        await FirebaseFirestore.instance
            .collection('wawastore')
            .doc('wawastore')
            .collection('addcart')
            .where('uid', isEqualTo: _uId)
            .get()
            .then((valueDel) async {
              for(var item in valueDel.docs){
                await FirebaseFirestore.instance
                    .collection('wawastore')
                    .doc('wawastore')
                    .collection('addcart')
                    .doc(item.id)
                    .delete();


              }
        }).then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        onAdItem: () {
                          widget.onAdItem();
                        },
                      ),
                    ),
                    (route) => false);


       });


        });
        //
    //     await SQLiteHelper().deleteAllData().then((value) {
    //       // readCart();
    //       // Navigator.of(context).pop(true);
    //       Navigator.of(context).pushAndRemoveUntil(
    //           MaterialPageRoute(
    //             builder: (context) => HomePage(
    //               onAdItem: () {},
    //             ),
    //           ),
    //           (route) => false);
    //     });
    //   });
    // } catch (e) {
    //   print('error SQlite===>${e.toString()}');
    // }
  }

  Future<void> readCart() async {
    // print('##############>>>>readCart work ');
    // if (total > 0) {
    //   setState(() {
    //     total = 0;
    //   });
    // }
    String _uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      sqliteModels.clear();
      delID.clear();
      models.clear();
      total = 0;
    });

    // await SQLiteHelper().readSQLite().then((value) {
    // print('value==>>>${value.toString()}');
    //  String _value =;
    // print('_value===>>>$_value');

    await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('addcart')
        .where('uid', isEqualTo: _uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) async {
      //new trick var > then copy
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {

          await FirebaseFirestore.instance
              .collection('wawastore')
              .doc('wawastore')
              .collection('product2')
              .doc(item['code'])
              .collection('unit_codes')
              .doc(item['units'])
              .get().then((value) {
            if (value.exists) {
              num _price0 = value['price0'];

              //have data
              // String sumString = string.subtotals;
              // double sumDouble = double.parse(sumString);
              num sumDouble = item['amounts'] * _price0;
              String _subtotals = myFormat.format(sumDouble);
              // setState(() {
              setState(() {
                total = total + sumDouble;
              });
              // sqliteModels.add(string); //this***



              SQLiteModel model = SQLiteModel.fromMap({

                "code" : item['code'],
                "name" : item['name'],
                "prices" : _price0.toString(),
                "units" : item['units'],
                "amounts" : item['amounts'],
                "subtotals" : _subtotals,
                "picturl" : item['picturl'],
                "uid" : item['uid'],


              });
              setState(() {
                sqliteModels.add(model);
              });
              // var _jso = jsonEncode(string.toJsonzz());
              // print('_jso==>>$_jso');
              // models.add(_jso);
              var _jso = (model.toJsonzz());
              setState(() {
                modelss.add(model.toJsonzz());
              });
              //add data to modelss list()

              // models.add(string.toJsonzz().toString());
              // });


            }
          });



          //<<<new0




          // String sumString =
          //     item['subtotals']; //***ถ้าปรับ string to num จะเสียเวลาจ้า
          // double sumDouble = double.parse(sumString);
          //
          // setState(() {
          //   total = total + sumDouble;
          // });
          //
          // SQLiteModel model =
          //     SQLiteModel.fromMap(item.data()); //***must setState????
          // print('####model>>>$model');
          //
          // setState(() {
          //   sqliteModels.add(model);
          //   delID.add(item.id);
          // });
          //
          // var _jso = jsonEncode(model.toJsonzz());
          // print('####_jso>>>$_jso');
          //
          // setState(() {
          //   modelss.add(model.toJsonzz());
          // });
          //
          // print('####modelss.length>>>${modelss.length}');
          //
          //
          // //       // var _jso = jsonEncode(string.toJsonzz());
          // //       // print('_jso==>>$_jso');
          // //       // models.add(_jso);
          // //       var _jso = (string.toJsonzz());
          // //       modelss.add(string.toJsonzz());
        }

        // setState(() {
        //   statusLoad = false;
        // });
      }
    });

    //  QuerySnapshot qsModel = await FirebaseFirestore.instance //ถ้าใช้ได้ก็ใช้เลยจ้า
    //   .collection('wawastore')
    //   .doc('wawastore')
    //       .collection('addcart')
    //      .where('uid', isEqualTo: _uid)
    //   .get();

    //   if (qsModel.docs.isNotEmpty) {
    //     for (var item in qsModel.docs) {
    //          String sumString = item['subtotals']; //***ถ้าปรับ string to num จะเสียเวลาจ้า
    //     double sumDouble = double.parse(sumString);
    //     setState(() {
    //       total = total + sumDouble;

    //       sqliteModels.add(item.);
    //       var _jso = jsonEncode(item.toJsonzz());
    //       models.add(_jso);
    //     });

    //     }

    //   }

    // setState(() {
    //   statusLoad = false;
    // });

    // if (value.length != 0) {
    //   // total = double.parse(value[index2].subtotals);
    //   setState(() {
    //     sqliteModels = value;
    //    // statusHaveData = true;
    //   });
    // } else {
    //   setState(() {
    //   //  statusHaveData = false;
    //   });
    // }

    //     } else {
    //     }

    //   });

    // models.add(sqliteModels);
    // print('models===>>$models');

    // var _value = SQLiteModel.fromMap(sqliteModels);
    //  var _value = jsonDecode(sqliteModels.toString());

    //     });
    //   } catch (e) {
    //     // print('########### status in SQLite ===>>> ${e.toString()}');
    //   }
    //   widget.onAdItem();
  }

  @override
  Widget build(BuildContext context) {
    //loadData();
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('ตะกร้าของฉัน'),
        // ),
        body: Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'ตะกร้าของฉัน',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              buildListView(),
              buildRowTotal(),
              const SizedBox(
                height: 10,
              ),
              // buildRowMap(),

              buildSelectSaleName(),
              const SizedBox(
                height: 10,
              ),

              ListTile(
                leading: nodelivery
                    ? Icon(
                        Icons.check_box_outlined,
                        color: Colors.green[600],
                      )
                    : const Icon(Icons.check_box_outline_blank),
                title: const Text('ลูกค้าสะดวกรับสินค้าเองที่ร้าน',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                onTap: () {
                  setState(() {
                    nodelivery = !nodelivery;
                  });
                  if (nodelivery == true) {
                    setState(() {
                      delivery = false;
                    });
                  } else {}
                },
              ),

              ListTile(
                leading: delivery
                    ? Icon(
                        Icons.check_box_outlined,
                        color: Colors.green[600],
                      )
                    : const Icon(Icons.check_box_outline_blank),
                title: const Text('ต้องการให้ทางร้านไปส่งสินค้า',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                onTap: () {
                  setState(() {
                    delivery = !delivery;
                  });
                  if (delivery == true) {
                    setState(() {
                      nodelivery = false;
                    });
                  } else {}
                },
              ),

              buildRowMessage(),
              const SizedBox(
                height: 10,
              ),
              showDate(),

              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text('ร้าน: $emName',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text('อีเมล์: $emmail',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text('SML code: $codeSML',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                ],
              ),
              const SizedBox(
                height: 30,
              ),

           showBtnSave ?   btnSave
                  ? buildCloudButton()
                  : ProgressButton(
                      stateWidgets: const {
                        ButtonState.loading: Text(
                          "ระบบกำลังบันทึกข้อมูล...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ButtonState.fail: Text(
                          "ระบบกำลังบันทึกข้อมูล...",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        ButtonState.idle: Text(
                          "ระบบกำลังบันทึกข้อมูล กรุณารอสักครู่...",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        ButtonState.success: Text(
                          "ระบบกำลังบันทึกข้อมูล...",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      },
                      stateColors: {
                        ButtonState.loading: Colors.blue.shade300,
                        ButtonState.fail: Colors.red.shade300,
                        ButtonState.idle: Colors.grey.shade400,
                        ButtonState.success: Colors.green.shade400,
                      },
                    ): Container(),

              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // Future<void> notificationToAdmin(
  //     String docno, String docdate, double totolz, String timer) async {
  //   //find token. //น่าจะค้างตรงนี้ล่ะ
  //   String _uId = await helper.getStorage('uid');
  //   print('##_uId >>>$_uId');
  //   try {
  //     QuerySnapshot qsDasboard = await dbRef
  //         .collection('wawastore')
  //         .doc('wawastore')
  //         .collection('backend')
  //         .where('typeUser', isEqualTo: 'admin')
  //         .get();
  //     int index = 0;
  //     for (var item in qsDasboard.docs) {
  //       String _token = item['token'];
  //
  //       // print('_token>>>>$_token');
  //       String title = 'WAWA Store มี order ใหม่ครับ';
  //       String body =
  //           'คำสั่งซื้อที่ $docno วันที่ $docdate  เวลา $timer มูลค่ารวม $totolz บาท ';
  //       String url =
  //           'http://103.129.14.34/wawastore/apiNotification.php?isAdd=true&token=$_token&title=$title&body=$body';
  //       sendNotificationToMe(url);
  //
  //       index++;
  //     }
  //     print('จำนวนที่ส่งเท่ากับ $index');
  //   } catch (e) {
  //     print('error>>${e.toString()}');
  //   }
  // }
  //
  // Future<void> sendNotificationToMe(String urltoken) async {
  //   await Dio().get(urltoken).then((value) {
  //     print('ส่งข้อความสำเร็จแล้วครับ...');
  //   });
  // }

  // Widget showMap() {
  //   LatLng latLng = LatLng(14.8777294, 103.4895756);
  //   CameraPosition cameraPosition = CameraPosition(
  //     target: latLng,
  //     zoom: 16.0,
  //   );

  //   //14.8777294,103.4895756,
  //   return Container(
  //     height: 300.0,
  //     child: GoogleMap(
  //       initialCameraPosition: cameraPosition,
  //       mapType: MapType.hybrid,
  //       onMapCreated: (controller) {},
  //     ),
  //   );
  // }

  Row buildCloudButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            // height: 60,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)
                // topLeft: Radius.circular(20),
                // bottomLeft: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.red[600],
          ),

          onPressed: () {
            confirmOrder();
          },
          icon: const Icon(
            Icons.cloud_upload,
            color: Colors.white,
            size: 32,
          ),
          label: const Text(
            'สร้างใบเสนอราคา',
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

  // Widget buildRowMap() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 15),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Icon(
  //           Icons.location_on,
  //           size: 32,
  //         ),
  //         Text(
  //           'ที่อยู่:...........................',
  //           style: TextStyle(
  //             fontSize: 28,
  //           ),
  //         ),
  //         // Icon(Icons.create,size: 32,),
  //       ],
  //     ),
  //   );
  // }

  Widget buildRowMessage() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          TextField(
            controller: ctrlMsg,
            // onChanged: (value) => user = value.trim(),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
                color: MyStyle().darkColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              // hintStyle: TextStyle(color: MyStyle().darkColor),
              // hintText: 'อีเมล์ :',
              labelText: 'หมายเหตุ:',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color(0xff980700),
                  fontWeight: FontWeight.bold),

              prefixIcon: Icon(
                Icons.description_outlined,
                color: MyStyle().darkColor,
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
          const SizedBox(
            height: 20,
          ),

          // Container(width: 300,
          //   child: TextFormField(
          //     controller: ctrlMsg,
          //     style: TextStyle(
          //         fontSize: 28,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.orange[700]),
          //   ),
          // ),
        ],
      ),
    );
  }

  Row buildRowTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            'รวมทั้งสิ้น',
            style: TextStyle(
              fontSize: 32,
              color: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange[300]),
            child: Text(
              MyStyle().myFormat.format(total),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget showDate() {
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'เลือกวันที่รับสินค้า',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        ListTile(
          leading: const Icon(
            Icons.date_range,
            size: 32,
          ),
          title: TextFormField(
            onTap: () {
              chooseDate();
            },
            controller: ctrlDatetime,
            style: TextStyle(
                color: MyStyle().darkColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          // Text(
          //   '${dateTime.day} - ${dateTime.month} - ${dateTime.year+543}',
          //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          // ),
          trailing: const Icon(Icons.keyboard_arrow_down, size: 32),
          onTap: () {
            chooseDate();
          },
        ),
      ],
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${index + 1}. ${sqliteModels[index].name}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {

                    // print('####you delete id= ${delID[index]}');
                   
                    confirmDelete(sqliteModels[index] );
                    // 
                  })
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: sqliteModels[index].picturl,
                  errorWidget: (context, url, error) =>
                      Image.asset('images/image.png'),
                  placeholder: (context, url) => MyStyle().showProgress(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(sqliteModels[index].barcodes),
                    // Text(sqliteModels[index].name),
                    Row(
                      children: [
                        const Text(
                          'ราคา:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                          MyStyle()
                              .myFormat
                              .format(double.parse(sqliteModels[index].prices)),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const Text(
                          ' บาท',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Text(
                          'จำนวน:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                            '${sqliteModels[index].amounts} x ${sqliteModels[index].units}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),

                    Row(
                      children: [
                        const Text(
                          'ราคารวม:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Text(
                          MyStyle().myFormat.format(
                              double.parse(sqliteModels[index].subtotals)),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.red),
                        ),
                        const Text(
                          ' บาท',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 0.8,
          )
        ],
      ),
    );
  }

  Future<void> chooseDate() async {
    DateTime? chooseDateTime = await showDatePicker(
      context: context,
      initialDate: dateTime!,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: Colors.black,
                accentColor: Colors.orange[600],
                colorScheme: const ColorScheme.light(primary: Colors.black),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
            child: child!);
      },
    );
    if (chooseDateTime != null) {
      String strDate = DateFormat.MMMMd('th_TH').format(chooseDateTime);
      String _strDate = '$strDate ${chooseDateTime.year + 543}';

      setState(() {
        ctrlDatetime.text = _strDate;
      });
    }
  }

  Column buildSelectSaleName() {
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'รหัสพนักงานขาย',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              height: 65.0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton(
                  hint: Text(
                    hint,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  items: listDrop,
                  onChanged: (value) {
                    codeSale = value.toString();

                    setState(() {
                      hint = value.toString();
                    });

                    // print('codeSale>>>$codeSale');
                  },
                ),
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.refresh),
            //   onPressed: () {

            //       loadData();

            //   },
            // )
          ],
        )
      ],
    );
  }
}
