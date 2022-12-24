import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
//import 'package:wawa/models/barcode_model.dart';
import 'package:wawa/models/category_model.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';
//import 'package:wawa/models/product_model.dart';
//import 'package:wawa/utility/my_style.dart';

class SyncDataByRange extends StatefulWidget {
  const SyncDataByRange({Key? key}) : super(key: key);

  @override
  _SyncDataByRangeState createState() => _SyncDataByRangeState();
}

class _SyncDataByRangeState extends State<SyncDataByRange> {
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
  double _percent = 0;
  List<String> listProducts = [];
  List<num> listNo = [];

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

  Future getNumMax() async{
    listProducts.clear();
    listNo.clear();
   QuerySnapshot qsMax =  await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('wawaproduct04')
       .orderBy('no')  //default  0++
       .get();
   int _i = 0;
   for (var item in qsMax.docs){
     listProducts.add(item['productId']);
     listNo.add(item['no']);

     // setState(() {
     //   _i = _i +1;
     // });
     print('####${item['no']} - ${item['productId']}');

   }

   // setState(() {
   //   numx = _i;
   // });
   // print('####numx>>>$numx');
   // getMin();
   print('####total product==${listProducts.length} รหัส');
   freshDataByCategory();


  }

  Future<void> freshDataByCategory() async {//int minNumber, int maxNumber
    // await FirebaseFirestore.instance
    //     .collection('wawastore')
    //     .doc('wawastore')
    //     // .collection('product2')
    //     // .limit(300)
    //
    //     // .where('itemCategory', isEqualTo: syntxt)
    //     .collection('wawaproduct04')
    //     //.orderBy('no')
    //     // .where('no', isGreaterThanOrEqualTo: minNumber)
    //     // .where('no', isLessThanOrEqualTo: maxNumber)
    //     //.limit(10)
    //    // .snapshots()
    //     //.listen((event) async {
    // .get().then((event) async {
      // print('###event>>>${event.docs}');
      int number = 1;
      for (var item in listProducts) {
        // String code = item['productId'];
        // print('####$number code>>>>$code');
        //   number++;
        // }

          String urlAPI =
              'http://43.229.149.11:8086/SMLJavaRESTService/v3/api/product/$item';
          Map<String, String> headers = {};
          headers['GUID'] = 'smlx';
          headers['provider'] = 'DATA';
          headers['databasename'] = 'wawa2';
          headers['configFileName'] = 'SMLConfigDATA.xml';

        try {

          await Dio()
              .get(urlAPI, options: Options(headers: headers))
              .then((value2) async {
            // print('value2==>${value2.toString()}');
            // print('######priceFormulas>>>${priceFormulas.toString()}');
            print('####code==>$item');
            // var _name = '';
            // if (value2.data['data']['name'] != null || value2.data['data']['brand_name'] != "null") {
            //   _name = value2.data['data']['name'];
            // }

            String? _name = value2.data['data']['name'];
            // //off เพื่อรู้ว่าตัวไหน error
            // var _image = 'none';
            // if (value2.data['data']['images'] != null || value2.data['data']['brand_name'] != "null") {
            //   _image = value2.data['data']['images'][0]['uri'];
            // }
            String? _image = value2.data['data']['images'][0]['uri'];

            //var _image = value2.data['data']['images'][0]['uri'];

            // var _categoryName = '';
            // if (value2.data['data']['category_name'] != null || value2.data['data']['brand_name'] != "null") {
            //   _categoryName = value2.data['data']['category_name'];
            // }
            String? _categoryName = value2.data['data']['category_name'];

            // var _itemCategory = '';
            // if (value2.data['data']['item_category'] != null || value2.data['data']['brand_name'] != "null") {
            //   _itemCategory = value2.data['data']['item_category'];
            // }
          String?  _itemCategory = value2.data['data']['item_category'];

            //work แต่ไม่รู้ว่า error ตรงไหน
            // var priceFormulas = [];
            //
            // if (value2.data['data']['price_formulas']
            //     .toString()
            //     .isNotEmpty) {
            //   priceFormulas = value2.data['data']['price_formulas'];
            //   // print('######priceFormulas>>>${priceFormulas.toString()}');
            // }

         var   priceFormulas = value2.data['data']['price_formulas'];

            // if (value2.data['data']['price_formulas'] != null) {
            //var priceFormulas = value2.data['data']['price_formulas'];
            //   priceFormulas = value2.data['data']['price_formulas'];
            // }
            // if (priceFormulas.length != 0) {
            //   priceFormulas = value2.data['data']['price_formulas'];
            // //  print('######priceFormulas>>>${priceFormulas.toString()}');
            // }

            // //error จะดีกว่า จะได้รู้ว่ารหัสอะไร

            // var isPremium = false;
            // // if (value2.data['data']['is_premium'] != null) {
            //   setState(() {
            //     isPremium = value2.data['data']['is_premium'];  //default = false
            //   });
          bool  isPremium = value2.data['data']['is_premium'] ?? false;
            // }
            //add 16-6-2021
            // var isHoldSale = false;
            // // if (value2.data['data']['is_hold_sale'] != null) {
            //   setState(() {
            //     isHoldSale = value2.data['data']['is_hold_sale'];
            //   });
            // }
            bool isHoldSale = value2.data['data']['is_hold_sale'] ?? false;

            // var isHoldPurchase = false;
            // // if (value2.data['data']['is_hold_purchase'] != null) {
            //   setState(() {
            //     isHoldPurchase = value2.data['data']['is_hold_purchase'];
            //   });
            // }
          bool  isHoldPurchase = value2.data['data']['is_hold_purchase'] ?? false;

            // var brandName = 'zzz';
            // if (value2.data['data']['brand_name'] != null || value2.data['data']['brand_name'] != "null") {
            //   brandName = value2.data['data']['brand_name'];
            // }
            //

            String brandName = value2.data['data']['brand_name'] ?? 'zzz';

            // var groupMainName = 'yyy';
            // if (value2.data['data']['group_main_name'] != null || value2.data['data']['brand_name'] != "null") {
            //   groupMainName = value2.data['data']['group_main_name'];
            // }

            String groupMainName = value2.data['data']['group_main_name'] ?? 'yyy';

            Map<String, dynamic> mapName = {};
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


            var collection =   FirebaseFirestore.instance
                .collection('wawastore')
                .doc('wawastore')
                .collection('product2')
                .doc(item)
                .collection('unit_codes');

            var snapshots = await collection.get();
            for (var doc in snapshots.docs){
              await doc.reference.delete(); //for loop delete in firebase
            }

            //clear old code  || delete data by code in searchDB mySQL***
            deleteApi(item, _name!, _image! , isHoldSale, isHoldPurchase );




            try {
              await FirebaseFirestore.instance
                  .collection('wawastore')
                  .doc('wawastore')
                  .collection('product2')
                  .doc(item)
                  .set(mapName);
            } on Exception catch (e) {
              // print('####e.toString() /product2 + .doc(code) +  .set(mapName) >>>===${e.toString()}');
              // TODO
            }
            //clear all if value != 0;

            for (var i = 0; i < priceFormulas.length; i++) {
              // print('########code ==>>> $item');
              // print(
              //     '########priceFormulas#$i-[unit_code] ==>>> ${priceFormulas[i]['unit_code']}');
              // print(
              //     '########priceFormulas#$i-[price_0] ==>>> ${priceFormulas[i]['price_0']}');

              try {
                await FirebaseFirestore.instance
                    .collection('wawastore')
                    .doc('wawastore')
                    .collection('product2')
                    .doc(item)
                    .collection('unit_codes')
                    .doc(priceFormulas[i]['unit_code'])
                    .set({
                  "price0":  num.parse(priceFormulas[i]['price_0'].toString()) ?? 0 ,
                  "price1": num.parse(priceFormulas[i]['price_1'].toString()) ?? 0,
                  "price2": num.parse(priceFormulas[i]['price_2'].toString()) ?? 0,
                  "price3": num.parse(priceFormulas[i]['price_3'].toString()) ?? 0,
                  "price4": num.parse(priceFormulas[i]['price_4'].toString()) ?? 0,
                  "price5": num.parse(priceFormulas[i]['price_5'].toString()) ?? 0,
                  "price6": num.parse(priceFormulas[i]['price_6'].toString()) ?? 0,
                  "price7": num.parse(priceFormulas[i]['price_7'].toString()) ?? 0,
                  "price8": num.parse(priceFormulas[i]['price_8'].toString()) ?? 0,
                  "price9": num.parse(priceFormulas[i]['price_9'].toString()) ?? 0,
                  "unit_code": priceFormulas[i]['unit_code'],
                }).then((value) {
                  // print('####success!!!.collection(\'product2\'+ .doc(code)+ .collection(\'unit_codes\')+ .doc(priceFormulas[i][\'unit_code\'])  inserted Success!!!)/>>>${priceFormulas[i]['unit_code']}');
                });
              } on Exception catch (e) {
                print('####error!!!collection(\'product2\'+ .doc(code)+ .collection(\'unit_codes\')+ .doc(priceFormulas[i][\'unit_code\'])==${e.toString()}');
                // TODO
              }
              // double _v2 = i*100/priceFormulas.length;
              // setState(() {
              //   uploadPer = _v2;
              // });
            } //for
          });
          setState(() {
            number = number +1;
            numm = number;
          });
          double _numm = numm.toDouble();
          num _nummax = listProducts.length;
          // double _nummax = numx.toDouble();
          // double _v = _numm/_nummax;
          double _v = _numm*100/_nummax;
          double _v2 = _numm * 0.5 / _nummax;  //ค่าในวงกลม อนิเมชั่น
          setState(() {
            uploadPer = _v2;
            _percent = _v;
          });

          //  print('######_value>>>$_value'); //


          // number++;
          // print('######number>>>$number'); // end.


        }catch(e){
          print('####e.toString()>>>==${e.toString()}');

        // } on DioError catch (e) {
          // print('####error DioError >>>>${e.toString()} ');
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
          // if (e.response!.statusCode == 404) {
          //   print('#####e.response.statusCode>>>${e.response!.statusCode}');
          // } else {
          //   print('#####e.message>>>${e.message}');
          //  // print('#####e.request>>>${e!.request}');
          // }
        }
        // number++;
        // setState(() {
        //   number = number +1;
        //   numm = number;
        // });
        //   double _numm = numm.toDouble();
        //   num _nummax = listProducts.length;
        //   double _v = _numm*100/_nummax;
        //   // double _v2 = _numm * 100 / _nummax;
        //   setState(() {
        //     // uploadPer = _v2;
        //     _percent = _v;
        //   });




      }// loop for
    // });
    // });
  }

  void calPercent(){



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  await helper.setStorage('numm', numm.toString());

    getNumMax();
   // sleepTime();
   
    //     }
    //
    //   });
    // }


  }
  Future getMin() async{
  String? _numm =  await helper.getStorage('numm');

  if(_numm != null){
    int _no = int.parse(_numm);
    if(_no >= numx-1){
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
  //   Duration duration = const Duration(seconds: 3);
  //   Timer(duration, (){
  //     if(numm <= numx){
  //       freshDataByCategory(numm, numx);
  //     }
  //
  //   });
  // }

  // Future sleepTime20() async{
  //   Duration duration = Duration(seconds: 3);
  //   await Timer(duration, (){
  //     if(numm <= numx){
  //       freshDataByCategory(numm, numx);
  //     }
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Syn Data SML to WAWA APP'),
      ),
      body:
          


      // Form(
      //     key: _formKey,
      //     child: SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           SizedBox(height: 30,),

// Start
      Column(
      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _AnimatedLiquidCircularProgressIndicator(percentUpload: uploadPer),
          const SizedBox(height: 30,),
          
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${myFormat.format(_percent)}%',style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w700,color: Colors.red),),
            ],
          ),

          const SizedBox(height: 50,),
          
          // RaisedButton.icon(color: Colors.grey,
          //
          //     onPressed: () async {
          //   Navigator.of(context).pop();
          //   // await helper.setStorage('numm', numm.toString());
          // }, icon: const Icon(Icons.save_sharp,size: 32,color: Colors.white,), label: const Text('พักการอัพเดทชั่วคราว',style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w700),)),
          //
          // const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 75,
                height: 75,
                child: LiquidCircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: const AlwaysStoppedAnimation(Colors.red),
                ),
              ),
              SizedBox(
                width: 75,
                height: 75,
                child: LiquidCircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation(Colors.pink),
                  borderColor: Colors.red,
                  borderWidth: 5.0,
                  direction: Axis.horizontal,
                ),
              ),
              SizedBox(
                width: 75,
                height: 75,
                child: LiquidCircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation(Colors.grey),
                  borderColor: Colors.blue,
                  borderWidth: 5.0,
                  center: const Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                height: 75,
                child: LiquidCircularProgressIndicator(
                  backgroundColor: Colors.lightGreen,
                  valueColor: const AlwaysStoppedAnimation(Colors.blueGrey),
                  direction: Axis.horizontal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> deleteApi(String item, String _name,String _image, bool isHoldSale, bool isHoldPurchase ) async {
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    Response response;
    var dio = Dio();
    response = await dio.post('https://smartappdesigns.com:8083/delete',options: Options(headers: headers

    ), data: {
      'code' : item,

    });

    print('####action = deleted MySQL seardDB>>>>$response');

    //Insert search in MySQL DB***
    insertDataApi(item, "null",0,_name, _image , isHoldSale, isHoldPurchase  );


  }

  Future<void> insertDataApi(
      String item,
      String unitCode,
      int price,
      String name,
      String image,
      bool isHoldSale,
      bool isHoldPurchase
      ) async {

    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    Response response;
    var dio = Dio();
    response = await dio.post('https://smartappdesigns.com:8083/create',options: Options(headers: headers

    ), data: {
      'code' : item,
      'unit' : unitCode,
      'price' : price,
      'productname' : name,
      'urlImage' : image,
      'isholdsale' : isHoldSale,
      'isholdpurchase' : isHoldPurchase
    });

    print('####action = Inserted MySQL searchDB>>>>$response');

  }
}

class _AnimatedLiquidCircularProgressIndicator extends StatefulWidget {
  final double percentUpload;
  const _AnimatedLiquidCircularProgressIndicator({required this.percentUpload});
  
  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidCircularProgressIndicatorState();
}

class _AnimatedLiquidCircularProgressIndicatorState
    extends State<_AnimatedLiquidCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController!.addListener(() => setState(() {}));
    _animationController!.repeat();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController!.value * 100;
    return Center(
      child: SizedBox(
        width: 150.0,
        height: 150.0,
        child: LiquidCircularProgressIndicator(
          value: widget.percentUpload,
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation(Colors.blue),
          center: Text(
            "${percentage.toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
//end

            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 30),
            //     child: LiquidLinearProgressIndicator(
            //     value: _value, // Defaults to 0.5.
            //     valueColor: AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
            //     backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
            //     borderColor: Colors.red,
            //     borderWidth: 5.0,
            //     borderRadius: 12.0,
            //     direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
            //     center: Text("Loading...$numm/$numx"),
            // ),
            //   )






                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15),
                //   child: TextFormField(
                //     style: TextStyle(
                //         fontSize: 28,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.greenAccent[700]),
                //     validator: (value) {
                //       if (value.isEmpty) {
                //         return 'min value ';
                //       }
                //       return null;
                //     },
                //     controller: ctrlMin,
                //     decoration: InputDecoration(
                //         labelText: 'min value',
                //         labelStyle: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.green[700]),
                //         helperText: 'min value',
                //         helperStyle: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.green[300]),
                //         prefixIcon: Icon(
                //           Icons.edit,
                //           color: Colors.green[700],
                //           size: 32,
                //         )),
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15),
                //   child: TextFormField(
                //     style: TextStyle(
                //         fontSize: 28,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.greenAccent[700]),
                //     validator: (value) {
                //       if (value.isEmpty) {
                //         return 'max value ';
                //       }
                //       return null;
                //     },
                //     controller: ctrlMax,
                //     decoration: InputDecoration(
                //         labelText: 'max value',
                //         labelStyle: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.green[700]),
                //         helperText: 'max value',
                //         helperStyle: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.green[300]),
                //         prefixIcon: Icon(
                //           Icons.edit,
                //           color: Colors.green[700],
                //           size: 32,
                //         )),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: 200,
                //         height: 80,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ElevatedButton(
                //               onPressed: () {
                //                 if (_formKey.currentState.validate()) {
                //                   //valid
                //                   freshDataByCategory(int.parse(ctrlMin.text),
                //                       int.parse(ctrlMax.text));
                //                 } else {
                //                   //invalid
                //                 }
                //               },
                //               child: Text(
                //                 'Sync Data',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold, fontSize: 24),
                //               )),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: 200,
                //         height: 80,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ElevatedButton(
                //               onPressed: () {
                //                 // genNumber();
                //                // getPremium();
                //               },
                //               child: Text(
                //                 'Get top ten',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold, fontSize: 24),
                //               )),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: 200,
                //         height: 80,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ElevatedButton(
                //               onPressed: () {
                //                 checkTure(ctrlMin.text);
                //               },
                //               child: Text(
                //                 'Check True',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold, fontSize: 24),
                //               )),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: 200,
                //         height: 80,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ElevatedButton(
                //               onPressed: () {
                //                 checkFalse(ctrlMin.text);
                //               },
                //               child: Text(
                //                 'Check False',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold, fontSize: 24),
                //               )),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
  //             ],
  //           ),
  //         )),
  //   );
  }

  // Future<Null> getPremium() async {
  //   //double _totalPre = 0;
  //
  //   QuerySnapshot qsPre = await dbRef
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('product2')
  //       .get();
  //
  //   if (qsPre.docs.length > 0) {
  //     double num0 = 0;
  //
  //     for (var item in qsPre.docs) {
  //       // 1 = 1
  //       String _code = item.id;
  //       print('####code>>$_code');
  //       QuerySnapshot qsPurchase = await dbRef
  //           .collection('wawastore')
  //           .doc('wawastore')
  //           .collection('purchase')
  //           .where('_code')
  //           .get();
  //
  //       if (qsPurchase.docs.length > 0) {
  //         double num = 0;
  //
  //         for (var item2 in qsPurchase.docs) {
  //           setState(() {
  //             num = num + double.parse(item2['subtotal']);
  //           });
  //           print('#####num>>>$num');
  //         }
  //       }
  //       await dbRef
  //           .collection('wawastore')
  //           .doc('wawastore')
  //           .collection('priceBuy')
  //           .add({
  //         "code": _code,
  //         "name": qsPurchase.docs[0]['name'],
  //         "picturl": qsPurchase.docs[0]['picturl'],
  //         "subtotal": num,
  //       });
  //     }
  //
  //     //create
  //
  //   }
  // }
}
//
// class GenderModel {
//   String id;
//   String name;
//   @override
//   String toString() {
//     return '$id $name';
//   }
//
//   GenderModel(this.id, this.name);
// }
