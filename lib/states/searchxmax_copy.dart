import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wawa/models/search_model.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/helper.dart';

class SearchXMax extends StatefulWidget {
  const SearchXMax({Key? key, required this.onAdItem}) : super(key: key);
  final Function onAdItem;

  @override
  State<SearchXMax> createState() => _SearchXMaxState();
}

class _SearchXMaxState extends State<SearchXMax> {

  TextEditingController searchTxt = TextEditingController();
  List<SearchModels> models = [];
  late double screen;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  Helper helper = new Helper();
  bool moreModellength = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: AutoSizeText(
        'ค้นหารายการสินค้า',
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 32),
          maxLines: 1,
      ),centerTitle: true,),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(

                  // width: double.infinity,
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 80,
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    controller: searchTxt,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกชื่อสินค้าด้วยคะ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 24,fontWeight: FontWeight.bold
                      ),
                      labelText: '',

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //
                //     width: 250,
                //     height: 60,
                //     margin: const EdgeInsets.only(top: 16),
                //     child: TextFormField(
                //       controller: manufactController,
                //       validator: (value) {
                //         if (value!.isEmpty) {
                //           return 'กรุณาระบุชื่อบริษัทยาอย่างน้อย 3 พยางค์';
                //         } else {
                //           return null;
                //         }
                //       },
                //       decoration: InputDecoration(
                //         labelStyle: MyConstant().h3Style(),
                //         labelText: 'ชื่อบริษัทยา',
                //         prefixIcon: Icon(
                //           Icons.home_work_outlined,
                //           color: MyConstant.dark,
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: MyConstant.dark),
                //           borderRadius: BorderRadius.circular(30),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: MyConstant.light),
                //           borderRadius: BorderRadius.circular(30),
                //         ),
                //         errorBorder: OutlineInputBorder(
                //           borderSide: const BorderSide(color: Colors.red),
                //           borderRadius: BorderRadius.circular(30),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // Expanded(child: Container(
                //   width: 130,
                //   height: 50,
                //   child: ElevatedButton(
                //
                //     style: MyConstant().myButtonStyleBrown(),
                //     onPressed: () {
                //
                //       if (formKey.currentState!.validate()) {
                //         sendApi();
                //
                //       }
                //
                //     },
                //     child: Row(
                //       children: const [
                //         Icon(Icons.search_outlined),SizedBox(width: 3,),
                //          Text('ค้นหา'),
                //       ],
                //     ),
                //   ),
                // ),)
              ],
            ),
            // const SizedBox(height: 8,),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Wrap(
            //     children: const [
            //       SizedBox(width: 15,),
            //       Text('***ชื่อการค้ายาแผนปัจจุบัน (ภาษาอังกฤษ)',style: TextStyle(color: Colors.redAccent),)
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16,),

            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: 55,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      String _uid = await helper.getStorage('uid') ?? 'no';
                      print('####uid get in searchxmax >>> $_uid');
                      if (_uid == 'no') {
                        Navigator.of(context).pushNamed('/authen');
                      }else{
                        if (formKey.currentState!.validate()) {
                          getAPI(searchTxt.text.trim()); //ตัดหัว+ท้าย

                        }
                      }




                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.search_outlined,size: 32,),
                        Text('ค้นหา', style: TextStyle(fontSize: 32),),
                      ],
                    ),
                  ),
                ),
              ],),

            const SizedBox(height: 8,),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 AutoSizeText('ผลการค้นหา ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),maxLines: 1,),
                AutoSizeText(models.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.redAccent,fontSize: 30),maxLines: 1,),
                const AutoSizeText(' รายการ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30), maxLines: 1,),
                const SizedBox(width: 30,)
              ],),
            isLoading?
            const Center(child: CircularProgressIndicator(color: Colors.grey,backgroundColor: Colors.red,),)  :  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:  models.length,
                    itemBuilder: (context, index){
                      // print('####imageUrl>>${models[index].urlImage}');
                      return
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50, top: 20.0, bottom: 20, right: 50),
                            child: Row(

                              children: [
                              Image.network(models[index].urlImage,width: MediaQuery.of(context).size.width*0.15,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(


                                  children: [
                                    AutoSizeText(models[index].productname, style: TextStyle(
                                        fontSize: 40, fontWeight: FontWeight.bold
                                    ), maxLines: 3,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.13,
                                        height: MediaQuery.of(context).size.height * 0.08,
                                        child: ElevatedButton(

                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () async {
                                            // String? _uid = await helper.getStorage('uid');
                                            // //helper.setStorage('uid', event.uid);
                                            //
                                            // if (_uid!.isNotEmpty) {
                                            await FirebaseFirestore.instance
                                                .collection('wawastore')
                                                .doc('wawastore')
                                                .collection('product2')
                                                .where('name', isEqualTo: models[index].productname)

                                                .get().then((value) {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ChooseProduct(
                                                  products: value.docs[0],
                                                  onAdItem: () => widget.onAdItem(),
                                                ),
                                              ),);
                                            });
                                            // } else{
                                            //
                                            // }


                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check_box,size: 24,),SizedBox(width: 3,),
                                              AutoSizeText('เลือกรายการ', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),maxLines: 1,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Row(
                                    //
                                    //   children: [
                                    //     AutoSizeText('หน่วย: ', style: TextStyle(
                                    //       fontSize: 35, fontWeight: FontWeight.bold,
                                    //
                                    //
                                    //   ),maxLines: 1, ),
                                    //     AutoSizeText(models[index].unit, style: TextStyle(
                                    //         fontSize: 35, fontWeight: FontWeight.bold,
                                    //         color: Colors.blue.shade600
                                    //     ),maxLines: 1,),
                                    //   ],
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     AutoSizeText('ราคา: ', style: TextStyle(
                                    //         fontSize: 35, fontWeight: FontWeight.bold,
                                    //
                                    //     ),maxLines: 1,),
                                    //     AutoSizeText(models[index].price.toString(), style: TextStyle(
                                    //         fontSize: 35, fontWeight: FontWeight.bold,
                                    //         color: Colors.red.shade500
                                    //     ),maxLines: 1,),
                                    //     AutoSizeText(' บาท', style: TextStyle(
                                    //         fontSize: 35, fontWeight: FontWeight.bold,
                                    //
                                    //     ),maxLines: 1,),
                                    //   ],
                                    // ),

                                    // Text(models[index].unit, style: TextStyle(
                                    //     fontSize: 16, fontWeight: FontWeight.w300
                                    // ),),
                                  ],
                                ),
                              ),
                              // Expanded(
                              //     child: Row(
                              //       children: [
                              //         Text(models[index].unit, style: TextStyle(
                              //             fontSize: 18, fontWeight: FontWeight.w500,
                              //             color: Colors.green.shade600
                              //         ),),
                              //
                              //       ],
                              //     )),
                              // Expanded(
                              //     child: Row(
                              //       children: [
                              //         Text(models[index].price.toString(), style: TextStyle(
                              //             fontSize: 18, fontWeight: FontWeight.w500,
                              //             color: Colors.red.shade500
                              //         ),),
                              //
                              //       ],
                              //     )),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //
                              //   child: Wrap(
                              //     children: [
                              //       Text('${index+1} .TMTID: ${yaPanPaJuPanModel[index].tmtid}' ,
                              //         style: MyConstant().h3Style(),),
                              //
                              //     ],
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //
                              //   child: Wrap(
                              //     children: [
                              //       Text('     ชื่อยา: ${yaPanPaJuPanModel[index].fsn}' ,
                              //         style: MyConstant().h3Style(),),
                              //
                              //     ],
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //
                              //   child: Wrap(
                              //     children: [
                              //       Text('    บริษัทผู้ผลิต: ${yaPanPaJuPanModel[index].manufacturer}' ,
                              //         style: MyConstant().h3Style(),),
                              //
                              //     ],
                              //   ),
                              // ),


                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Container(
                              //       width: 160,
                              //       height: 50,
                              //       child: ElevatedButton(
                              //
                              //         style: MyConstant().myButtonStyle(),
                              //         onPressed: () async {
                              //
                              //           // var _message = await showTextDialog(context, title: "ระบุจำนวนที่พบ", value: 0);
                              //           // if (int.parse(_message)> 0) {
                              //           //saveData >>> pop กลับ  >> อัพเดท
                              //           await  FirebaseFirestore.instance
                              //               .collection('ranChamDB')
                              //               .doc('ranChamDB')
                              //               .collection('yaPanPaJuBan')
                              //               .add({
                              //             "time" : DateTime.now().millisecondsSinceEpoch,
                              //             "docID" : widget.doc.id,
                              //             "doc2ID" : widget.id,
                              //             "tmtid" : yaPanPaJuPanModel[index].tmtid,
                              //             "fsn" : yaPanPaJuPanModel[index].fsn,
                              //             "manufacturer" : yaPanPaJuPanModel[index].manufacturer,
                              //             "isShow" : true,
                              //
                              //
                              //
                              //
                              //
                              //
                              //           }).then((value) => Navigator.pop(context));
                              //
                              //           // }
                              //
                              //         },
                              //         child:  Text('เลือกรายการ', style: MyConstant().h3WhiteStyle(),),
                              //       ),
                              //     ),
                              //   ],),
                              const SizedBox(height: 30,),

                              //  Divider(
                              //   thickness: 2,
                              //   height: 2,
                              //   color: Colors.grey,
                              //   // indent: 1,
                              // )

                            ],),
                          ),
                      ),
                        );
                    }),
              ),
            ),

          ],
        ),),
      )
    );
  }

  Future<void> getAPI(String searchText) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }


    models.clear();
    setState(() {
      isLoading = true;
    });

    String _searchTxt =  searchText.replaceAll(RegExp(r"\s+"), ' ');
    //searchText.replaceAll('  ', ''); // ***solution '  ' มากกว่า 1 ครั้ง

    List<String> xdata = _searchTxt.split(' ') ;
    print('####xdata===$xdata');

    if (xdata.length == 3) {
      //0
      String urlAPI = 'https://smartappdesigns.com:8083/searchthree/${xdata[0].trim()}/${xdata[1].trim()}/${xdata[2].trim()}';
      await Dio().get(urlAPI).then((value) {
        if (value.statusCode == 200) { //*มีข้อมูล
          print('####value>>>${value.data}');

          for (var item in value.data) { //**เราทำเองไม่ได้ encode
            SearchModels model = SearchModels.fromMap(item);

            setState(() {
              models.add(model);
            });
          }

          if (models.length < 10) {
            setState(() {
              moreModellength = false;
            });

          }


          setState(() {
            isLoading = false;
            // showButton = true;
          });
        }
      });


      //1


    } else if (xdata.length == 2) {
      //0
      String urlAPI = 'https://smartappdesigns.com:8083/search/${xdata[0].trim()}/${xdata[1].trim()}';
      await Dio().get(urlAPI).then((value) {
        if (value.statusCode == 200) { //*มีข้อมูล
          print('####value>>>${value.data}');

          for (var item in value.data) { //**เราทำเองไม่ได้ encode
            SearchModels model = SearchModels.fromMap(item);

            setState(() {
              models.add(model);
            });
          }

          if (models.length < 10) {
            setState(() {
              moreModellength = false;
            });

          }


          setState(() {
            isLoading = false;
          });
        }
      });


          //1


    } else if (xdata.length == 1){
      //0
      String urlAPI = 'https://smartappdesigns.com:8083/searchone/${xdata[0].trim()}';
      await Dio().get(urlAPI).then((value) {
        if (value.statusCode == 200) { //*มีข้อมูล
          print('####value>>>${value.data}');

          for (var item in value.data) { //**เราทำเองไม่ได้ encode
            SearchModels model = SearchModels.fromMap(item);

            setState(() {
              models.add(model);
            });
          }

          if (models.length < 10) {
            setState(() {
              moreModellength = false;
            });

          }


          setState(() {
            isLoading = false;
          });
        }
      });


      //1

    }else{
      setState(() {
        isLoading = false;
      });

    }




  }
}
