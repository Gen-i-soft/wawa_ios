import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:wawa/global.dart';
import 'package:wawa/models/docobj_model.dart';

import 'package:wawa/models/product_cloud_model.dart';
import 'package:wawa/src/widget/best_seller_two.dart';
//import 'package:wawa/src/widget/best_seller.dart';
import 'package:wawa/src/widget/category_widget.dart';
import 'package:wawa/src/widget/product_list_widget.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/widget/productitembox.dart';

class ProductPage extends StatefulWidget {
  final Function onAdItem;
  ProductPage({required this.onAdItem});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double screen = 0;
  double screen2 = 0;
  // String categoryId;
  // String uid = 'user';

  double sizeWidth = 0;
  int totalItems = 0;
  double total = 0;
  bool showButton = false;
  bool isMaxData = false;


  // ScrollController scrollController = ScrollController();
  int amountListView = 6;
  //List<Widget> widgets = List();
  //อันนีัเตือนแต่ ไม่แดง ปล่อยผ่านจ้า

  bool loading = false;
  String categoryId = 'ขนม';
  List<DocumentSnapshot> products = [];
  List<DocObjModel> listDocument = [];
  List<dynamic> widgets = [];
  List<String> productImages = [];
  Helper helper = Helper();

  var scrollController = ScrollController();
  late QuerySnapshot collectionState;

  Future<void> checkLogin() async {
    // await Firebase.initializeApp().then((value) async {
    //   FirebaseAuth.instance.authStateChanges().listen((event) async {
    //     if (event?.uid != null) {
    //       setState(() {
    //         uid = event!.uid;
    //       });
    //       print('####uid>>${event!.uid}');
    //     } else {}
    //   });
    // });
    String _uid = await helper.getStorage('uid') ?? 'user';
    setState(() {
      uid = _uid;
    });
    print('####uid / checkLogin ==$uid');
  }

  // Future<void> getProduct() async {
  //   setState(() {
  //     products.clear();
  //     loading = true;
  //   });
  //
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('wawastore')
  //         .doc('wawastore')
  //         .collection('product2')
  //         .where('categoryName', isEqualTo: categoryId)
  //         // .where('isHoldSale', isEqualTo: false)
  //         // .where('isHoldPurchase', isEqualTo: false)
  //         .orderBy('brandName')
  //         .orderBy('groupMainName')
  //         .get();
  //
  //     setState(() {
  //       loading = false;
  //       products = snapshot.docs;
  //     });
  //
  //     // if (snapshot.docs.length > 0) {
  //
  //     //   // for (var item in snapshot.docs) {
  //     //   //   print('####item>>>${item['name']}');
  //     //   //   products.add(item);
  //     //   // }
  //     // }
  //   } catch (e) {
  //     print('###error jaa>>>${e.toString()}');
  //     // TODO
  //   }
  //
  //   //  try {
  //   //   await FirebaseFirestore.instance
  //   //       .collection('wawastore')
  //   //       .doc('wawastore')
  //   //       .collection('product2')
  //   //       .where('categoryName', isEqualTo: categoryId)
  //   //       .where('isHoldSale', isEqualTo:false)
  //   //       .orderBy('brandName')
  //   //       .orderBy('groupMainName')
  //   //       .snapshots()
  //   //       .listen((event) {
  //   //            setState(() {
  //   //       loading = false;
  //   //       for (var item in event.docs) {
  //   //         products.add(item);
  //   //       }
  //
  //   //     });
  //
  //   //       });
  //   // } catch (e) {
  //   //   print('###error jaa>>>${e.toString()}');
  //   //         // TODO
  //   // }
  //
  //   //.where('isOn', isNotEqualTo: false)
  //   // .where('urlImage', isNotEqualTo: '')
  //   // .limit(200)
  //   // await Firebase.initializeApp().then((value) async {
  //   // if (categoryId == null) {
  //   //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //   //       .collection('wawastore')
  //   //       .doc('wawastore')
  //   //       .collection('product2')
  //   //       //.orderBy('groupMainName')
  //   //       //.orderBy('brandName')
  //   //       //.where('isOn', isNotEqualTo: false)
  //   //       // .where('urlImage', isNotEqualTo: '')
  //   //       // .limit(200)
  //
  //   //       .get();
  //   //   setState(() {
  //   //     loading = false;
  //   //     products = snapshot.docs;
  //   //   });
  //   //   // print('i am null');
  //   // } else {
  //   //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //   //       .collection('wawastore')
  //   //       .doc('wawastore')
  //   //       .collection('product2')
  //
  //   //       // .orderBy('brandName')
  //   //       // .where('urlImage', isNotEqualTo: '')
  //   //       .where('categoryName', isEqualTo: categoryId)
  //   //       //.orderBy('groupMainName', descending: true)
  //   //      // .orderBy('groupMainName', descending: false)
  //   //      // .orderBy('brandName')
  //
  //   //       .get();
  //   //   setState(() {
  //   //     loading = false;
  //   //     products = snapshot.docs;
  //   //   });
  //
  //   //   // print('i am not null');
  //   // }
  //
  //   // print('####products==>>$products');
  //
  //   // try {
  //   //   await FirebaseFirestore.instance
  //   //       .collection('product')
  //   //       .where('urlImage', isNotEqualTo: '')
  //   //       .snapshots()
  //   //       .listen((event) async {
  //   //     int index = 0;
  //   //     for (var snapshot in event.docs) {
  //   //       ProductCloudModel model =
  //   //           ProductCloudModel.fromMap(snapshot.data());
  //   //       docts.add(snapshot.id);
  //
  //   //       setState(() {
  //   //         productModels.add(model);
  //   //         widgets.add(createWidget(model, index));
  //   //       });
  //   //       index++;
  //   //     }
  //   //   });
  //   // } catch (e) {
  //   //   print('e>>>${e.toString()}');
  //   // }
  //   // });
  // }

  // Widget createWidget(DocumentSnapshot products) => GestureDetector(
  //       onTap: () async {
  //         print('###################Sentdata url ==>> ${products['urlImage']}');
  //         var res = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ChooseProduct(
  //               onAdItem: () => widget.onAdItem(),
  //               products: products,
  //               // productModel: products,
  //               // doct: docts[index],
  //             ),
  //           ),
  //         );
  //         if (res != null) {
  //           widget.onAdItem();
  //         }
  //       },
  //       child: Card(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: screen * .4,
  //               height: 120,
  //               child: CachedNetworkImage(
  //                 // fit: BoxFit.cover,
  //                 imageUrl: products['urlImage'],
  //                 errorWidget: (context, url, error) =>
  //                     Image.asset('images/image.png'),
  //                 placeholder: (context, url) => MyStyle().showProgress(),
  //               ),
  //             ),
  //             Container(
  //                 width: sizeWidth * 0.5 - 16,
  //                 child: Text(
  //                   products['name'],
  //                   overflow: TextOverflow.ellipsis,
  //                   softWrap: false,
  //                   maxLines: 2,
  //                   style: TextStyle(
  //                     fontSize: 24,
  //                   ),
  //                 ))
  //           ],
  //         ),
  //       ),
  //     );

  // Future getImages() async {
  //   // setState(() {
  //   //   loading = true;
  //   //   // productImages.clear();
  //   // });
  //   //await Firebase.initializeApp().then((value) async {
  //   QuerySnapshot qsImage = await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('product2')
  //       .where('isPremium', isEqualTo: true)
  //       .get();

  //   if (qsImage.docs.length > 0) {
  //     for (var item in qsImage.docs) {
  //       print('####item[urlImage]>>>${item['urlImage']}');
  //       setState(() {
  //         productImages.add(item['urlImage']);
  //         widgets.add(NetworkImage(item['urlImage']));
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // getProduct();
    // getImages();

    super.initState();
    checkLogin();

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     amountListView = amountListView + 4;
    //   }
    // });
    // listDocument.clear();
    // getDocuments();  //error 10 ชม**  สาดดดด
    scrollController.addListener(() { //continue  , looking
      if (scrollController.position.atEdge) {

        print('####scrollController.position.pixels/outter==>${scrollController.position.pixels}');
        if (scrollController.position.pixels == 0) {
          print('####scrollController.position.pixels/0==>${scrollController.position.pixels}');
          setState(() {
            showButton = false;
          });
          // getDocumentsPrevious(); //work
        // } else if(scrollController.position.maxScrollExtent - scrollController.position.pixels <= 50) {
        //   // print('####Listview scroll at bottom');
        //   print('####scrollController.position.pixels/next==>${scrollController.position.pixels}');
          // setState(() {
          //   showButton = true;
          // });

        }else{

          getDocumentsNext();
          setState(() {
            showButton = true;
          });
          // if(scrollController.position.maxScrollExtent == scrollController.position.pixels ){
          //
          //   setState(() {
          //     isMaxData = true;
          //   });
          //   print('####isMaxData>>>$isMaxData');
          // }else{
          //   setState(() {
          //     isMaxData = false;
          //   });
          //   print('####isMaxData>>>$isMaxData');
          // }


          }
      }
    });
  }

  // ListView buildListView() {
  //   return ListView.builder(
  //     controller: scrollController,
  //     itemCount: products.length,
  //     itemBuilder: (context, index) => Card(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: MyStyle().titleH2dark(products[index]['name']),
  //       ),
  //     ),
  //   );
  // }
  void _onTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    screen2 = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: showButton
          ? FloatingActionButton(
              // foregroundColor: Colors.black,
              backgroundColor: Colors.grey[400],
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _onTop();
              },
            )
          : const SizedBox(),
      // backgroundColor: Color(0xffCBC5C0),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        // scrollDirection: Axis.vertical,

        controller: scrollController,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 3, left: 10),
              child: BestSellerTwoWidget(onAdItem: () => widget.onAdItem()),
              height: 160,
              color: Colors.white,
            ),
            //     Container(
            // height: 190.0,
            // width: double.infinity,
            // child:  Carousel(
            //   boxFit: BoxFit.fill,

            //   // [
            //   //   NetworkImage('http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/image/2f4ccf05-0451-46f2-9752-a9132d0a0983?p=DATA&d=wawa2')

            //   // ],
            //   //autoplay: true,

            //  // autoplayDuration: Duration(milliseconds: 3000),
            //   animationCurve: Curves.fastOutSlowIn,
            //   dotSize: 5.0,
            //   dotIncreasedColor: Colors.purple,
            //   dotBgColor: Colors.grey.withOpacity(0.2),
            //   dotPosition: DotPosition.bottomCenter,
            //   showIndicator: true,
            //   indicatorBgPadding: 5.0,
            //   images: [
            //     NetworkImage(productImages[0]),
            //      NetworkImage(productImages[1])
            //   ]
            //   //widgets,

            //   // dotSpacing: 15.0,
            //   // dotColor: Colors.lightGreenAccent,

            //   // borderRadius: true,
            // )),

            Container(
              // margin: EdgeInsets.only(top: 2),
              padding: const EdgeInsets.only(top: 2, left: 10),
              child: CategoryWidget(
                onChange: (DocumentSnapshot document) {
                   print('####document[\'name\']=>>>${document['name']}');


                  String  _categoryId = document['name'];
                    // พอตัวนี้เปลี่ยนมันจะไปบังคับให้ตัวอื่นเปลี่ยนตาม
                   setState(() {
                     categoryId = _categoryId;
                   });

                  // getProduct();

                   // if (loadingCategory == true) {
                   //   soldOutAlert("ระบบกำลังโหลดข้อมูล กรุณารอสักครู่!");
                   //
                   // } else {
                   //   setState(() {
                   //     listDocument.clear();
                   //     loadingCategory = true;
                   //   });
                   //   getDocuments2(_categoryId);
                   //
                   // }

                  getDocuments();



                  // print('document>>>${document['name']}');
                },
              ),
              height: 90,
              color: Colors.white,
            ),
            // listDocument.isNotEmpty
            //     ? RefreshIndicator(
            //         child:
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // scrollDirection: Axis.vertical,

                      // controller: scrollController,
                      itemCount: 1,
                      //listDocument.length,
                      itemBuilder: (context, index) =>

                          //   ListTile(title: Text('${listDocument[index].documentName}'),
                          // subtitle: Text('${listDocument[index].documentUrl}'),);
                          //   }

                          ResponsiveGridList(
                        scroll: false,
                        desiredItemWidth: 220,
                        minSpacing: 10,
                        children: listDocument.map((DocObjModel doc) {
                          bool _isHoldPurchase = doc.isHoldPurchase ?? false;
                          bool _inCart = doc.inCart ?? false;

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // try {
                                  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
                                  //       .collection('wawastore')
                                  //       .doc('wawastore')
                                  //       .collection('product2')
                                  //       .where('name', isEqualTo: doc.documentName)
                                  //
                                  //       .get();
                                  //   String _id = snapshot.docs[0].id;
                                  //   print('#####doc.documentId/_id>>>$_id');
                                  //
                                  // } on Exception catch (e) {
                                  //   // TODO
                                  // }
                                  // print('#####doc.documentId>>>${doc.documentId}');
                                  if (uid == 'user') {
                                    Navigator.of(context).pushNamed('/authen2');
                                  } else if (_isHoldPurchase == true) {
                                    //show notify
                                    soldOutAlert("สินค้าหมดชั่วคราว!");
                                  } else {
                                    late QuerySnapshot snapshot;
                                    try {
                                      snapshot = await FirebaseFirestore
                                          .instance
                                          .collection('wawastore')
                                          .doc('wawastore')
                                          .collection('product2')
                                          .where('name', isEqualTo: doc.name)
                                          .get();
                                      String _id = snapshot.docs[0].id;
                                      print('#####doc.documentId/_id>>>$_id');
                                    } on Exception catch (e) {
                                      // TODO
                                    }
                                    String? res = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ChooseProduct(
                                        products: snapshot.docs[0],
                                        onAdItem: () => widget.onAdItem(),
                                      ),
                                    ));
                                    if (res == 'save') {
                                      widget.onAdItem();
                                      getDocumentsPrevious();
                                      print('###res>>>${res.toString()}');
                                    }
                                  }
                                },
                                child:
                                    // Image.network('${product['urlImage']}',width: screen * 0.6, height: 150),
                                    _isHoldPurchase
                                        ? Stack(
                                            children: [
                                              ProductItemBox(
                                                  imageurl: doc.url,
                                                  width: screen * 0.6,
                                                  height: 150),
                                              Image.asset(
                                                'images/sold_out.png',
                                                width: screen * 0.6,
                                                height: 150,
                                              )
                                            ],
                                          )
                                        : _inCart
                                            ? Stack(
                                                children: [
                                                  ProductItemBox(
                                                      imageurl: doc.url,
                                                      width: screen * 0.6,
                                                    height: 150,
                                                     ),

                                                  Positioned(
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0,
                                                    child:
                                                    Container(
                                                     padding: const EdgeInsets.all(8),
                                                      decoration:  BoxDecoration(
                                                        color: Colors.orange.shade300,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),

                                                      child: Wrap(
                                                        children: [
                                                          Text(
                                                            '***มีสินค้าในตะกร้าแล้ว!  ${doc.qtyInCart}',
                                                            style:  TextStyle(
                                                                // backgroundColor:
                                                                //     Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color:
                                                                    Colors.red.shade700),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 10,
                                                    right: 10,
                                                    child: Image.asset(
                                                      'images/inCart2.png',
                                                      width: screen * 0.05,
                                                      // height: 60,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ProductItemBox(
                                                imageurl: doc.url,
                                                width: screen * 0.6,
                                                height: 150),
                              ),
                              // SizedBox(height: 10,),
                              AutoSizeText(
                                doc.name,
                                // overflow: TextOverflow.ellipsis,
                                // softWrap: false,
                                maxLines: 3,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      // return
                      // ProductItemBox(
                      //     imageurl: '${listDocument[index]['urlImage']}',
                      //     width: screen * 0.6,
                      //     height: 150);

                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 10, right: 10),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             'รายการในหมวดหมู่',
                      //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      //           ),
                      //           Container(
                      //             height: 30,
                      //             margin: EdgeInsets.only(bottom: 5),
                      //             child: Chip(
                      //               padding: EdgeInsets.only(bottom: 5),
                      //               label: Text(
                      //                 '${listDocument.length} รายการ',
                      //                 style: TextStyle(
                      //                     color: Colors.black,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 20),
                      //               ),
                      //               backgroundColor: Colors.black45,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     ResponsiveGridList(
                      //       scroll: false,
                      //       desiredItemWidth: 160,
                      //       minSpacing: 5,
                      //       children:
                      //       listDocument.map((DocumentSnapshot product) {
                      //         return Column(
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () async {
                      //                 if (uid == 'user') {
                      //                   Navigator.of(context).pushNamed('/authen');
                      //
                      //                 } else {
                      //                   String res = await Navigator.of(context).push(MaterialPageRoute(
                      //                     builder: (context) => ChooseProduct(
                      //                       products: product,
                      //                       onAdItem: () => widget.onAdItem(),
                      //                     ),
                      //                   ));
                      //                   if (res == 'save') {
                      //                     widget.onAdItem();
                      //                     print('###res>>>${res.toString()}');
                      //                   }
                      //                 }
                      //
                      //               },
                      //               child:
                      //               // Image.network('${product['urlImage']}',width: screen * 0.6, height: 150),
                      //               ProductItemBox(
                      //                   imageurl: '${product['urlImage']}',
                      //                   width: screen * 0.6,
                      //                   height: 150),
                      //             ),
                      //             // SizedBox(height: 10,),
                      //             Text(
                      //               '${product['name']}',
                      //               overflow: TextOverflow.ellipsis,
                      //               softWrap: false,
                      //               maxLines: 3,
                      //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      //             ),
                      //           ],
                      //         );
                      //       }).toList(),
                      //    ),
                      //   ],
                      // );

                      //  }
                    ),
                //     onRefresh: getDocuments)
                // : const CircularProgressIndicator(),
            // const SizedBox(
            //   height: 30,
            // ),
            // isMaxData ?  Container() :
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.redAccent,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30))),
            //     onPressed: () {
            //       getDocumentsNext();
            //     },
            //     child: const Text('กำลังโหลดเพิ่ม',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
    //               ),
    // ),
          ],
        ),
      ),
    );
  }

  Future<void> getDocuments() async {
    setState(() {
      listDocument.clear();
      loadingCategory = true;
    });

    Query<Map<String, dynamic>> collection ;

    print('####listDocument/getDocuments() >>${listDocument.length}');
    print('####categoryId/getDocuments() >>$categoryId');
     collection = FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('product2')
        .where('categoryName', isEqualTo: categoryId)
        // .where('isHoldSale', isEqualTo: false)
        // .where('isHoldPurchase', isEqualTo: false)
        .orderBy('brandName')
        .orderBy('groupMainName')
        .limit(30);

    // print('####collection>>>$collection');

    fetchDocuments(collection);
  }
  // Future<void> getDocuments2() async {
  //
  //   Query<Map<String, dynamic>> collection ;
  //
  //   print('####listDocument/getDocuments() >>${listDocument.length}');
  //   print('####categoryId/getDocuments() >>$categoryId');
  //   collection = FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('product2')
  //       .where('categoryName', isEqualTo: categoryId)
  //   // .where('isHoldSale', isEqualTo: false)
  //   // .where('isHoldPurchase', isEqualTo: false)
  //       .orderBy('brandName')
  //       .orderBy('groupMainName')
  //       .limit(50);
  //
  //   // print('####collection>>>$collection');
  //
  //   fetchDocuments3(collection);
  // }

  Future<void> getDocumentsPrevious() async {
    setState(() {
      listDocument.clear();
      loadingCategory = true;
    });

    var lastVisible = collectionState.docs[collectionState.docs.length - 1];
    print('####collectionState legnth/ getDocumentsPrevious is Worked!!! === ${collectionState.size} /endBeforeDocument=== $lastVisible');
    var collection = FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('product2')
        .where('categoryName', isEqualTo: categoryId)
    // .where('isHoldSale', isEqualTo: false)
    // .where('isHoldPurchase', isEqualTo: false)
        .orderBy('brandName')
        .orderBy('groupMainName')
    .endBeforeDocument(lastVisible); //***worked!

        // .startAfterDocument(lastVisible)
        // .limit(20);
    fetchDocuments(collection); //ยัดข้อมูลเข้า models
  }

  Future<void> getDocumentsNext() async {
    setState(() {

      loadingCategory = true;
    });
    var lastVisible = collectionState.docs[collectionState.docs.length - 1];
    print('####collectionState legnth === ${collectionState.size} /startAfterDocument=== $lastVisible');
    var collection = FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('product2')
        .where('categoryName', isEqualTo: categoryId)
        // .where('isHoldSale', isEqualTo: false)
        // .where('isHoldPurchase', isEqualTo: false)
        .orderBy('brandName')
        .orderBy('groupMainName')

        .startAfterDocument(lastVisible)
        .limit(30);
    fetchDocuments(collection); //ยัดข้อมูลเข้า models
    // _onTop();
  }

  Future<void> soldOutAlert(String msg) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text(
                    msg,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        icon: const Icon(Icons.check,
                            size: 32, color: Colors.white),
                        label: const Text(
                          'ตกลง',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  fetchDocuments(Query<Map<String, dynamic>> collection) {
    collection.get().then((value) async {
      collectionState = value;
      // setState(() {
      //   listDocument.clear(); //แก้สะสมได้มั้ย === แก้ได้แต่โหลดใหม่ตลอด // ผลเสียมากกว่าได้
      // });

      // value.docs.forEach((element) {
      //   print('#####element.data()>>>${element.data()}');
      //   setState(() {
      //     listDocument.add(DocObj.setDetails(element.data()));
      //   });
      // });
      //
      for (var item in value.docs) {
        // value.docs.forEach((element) {
        //  // print('#####element.data()>>>${element.data()}');
        //  // setState(() {
        //     // listDocument.add(DocObj.setDetails(element.data()));
        //  // });
        //   listDocument.add({
        //     "documentName" : element.data()["name"],
        //     "documentUrl" : element.data()["name"]
        //
        //
        //   // documentName = doc['name'];
        //   // documentUrl = doc['urlImage'];
        //   // documentId = doc['id'];
        //   // isHoldPurchase = doc['isHoldPurchase'];
        //
        //   });

        // });
        // DocObj model = DocObj.setDetails(item.data());
        // bool valueCart = false;
        // await FirebaseFirestore.instance
        //     .collection('wawastore')
        //     .doc('wawastore')
        //     .collection('inCart')
        //     .where('name',isEqualTo: item['name'])
        //     .get().then((value) {
        //   if (value.docs.isNotEmpty) {
        //
        //     setState(() {
        //       valueCart = true;
        //     });
        //   }else{
        //     setState(() {
        //       valueCart = false;
        //     });
        //   }
        //
        //
        //
        // });
        // await FirebaseFirestore.instance
        //     .collection('wawastore')
        //     .doc('wawastore')
        //     .collection('inCart')
        //     .add({
        // "code" : code,
        // "name" : name,
        // "price" : prices,
        // "unit": unitcodes,
        // "amount": listAmounts,
        // "subtotal": listSubtotals,
        // "uid":uid
        // String uid = 'user';
        bool _inCart = false;
        String _qtyInCart = "";

        if (uid != 'user') {
          await FirebaseFirestore.instance
              .collection('wawastore')
              .doc('wawastore')
              .collection('inCart')
              .where('name', isEqualTo: item['name'])
              .where('uid', isEqualTo: uid)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              setState(() {
                _inCart = true;
              });
              List<String> qtyInCartList = [];
              String _qtyInCartStr = "";
              for (var item1 in value.docs) {
                _qtyInCartStr =
                    'หน่วย: ${item1['unit']} จำนวน:# ${item1['amount']} ';

                qtyInCartList.add(_qtyInCartStr);
              }

              setState(() {
                _qtyInCart = qtyInCartList.toString();
              });
            }
          });
        }
        // print('####item[\'name\']===${item['name']}');
        // print('####_inCart===$_inCart');
        // print('####_qtyInCart===$_qtyInCart');

        DocObjModel model = DocObjModel.fromMap({
          "name": item['name'],
          "url": item['urlImage'],
          "id": item.id,
          "isHoldPurchase": item['isHoldPurchase'],
          "inCart": _inCart, //worked***
          "qtyInCart": _qtyInCart, //worked***
        });
        setState(() {
          listDocument.add(model);
        });
      }

      setState(() {
        loadingCategory = false;
      });

      print('#####listDocument.length===>>>${listDocument.length}');
    });
  }
  // fetchDocuments3(Query<Map<String, dynamic>> collection) {
  //   collection.get().then((value) async {
  //     collectionState = value;
  //     // setState(() {
  //     //   listDocument.clear(); //แก้สะสมได้มั้ย === แก้ได้แต่โหลดใหม่ตลอด // ผลเสียมากกว่าได้
  //     // });
  //
  //     // value.docs.forEach((element) {
  //     //   print('#####element.data()>>>${element.data()}');
  //     //   setState(() {
  //     //     listDocument.add(DocObj.setDetails(element.data()));
  //     //   });
  //     // });
  //     //
  //     for (var item in value.docs) {
  //       // value.docs.forEach((element) {
  //       //  // print('#####element.data()>>>${element.data()}');
  //       //  // setState(() {
  //       //     // listDocument.add(DocObj.setDetails(element.data()));
  //       //  // });
  //       //   listDocument.add({
  //       //     "documentName" : element.data()["name"],
  //       //     "documentUrl" : element.data()["name"]
  //       //
  //       //
  //       //   // documentName = doc['name'];
  //       //   // documentUrl = doc['urlImage'];
  //       //   // documentId = doc['id'];
  //       //   // isHoldPurchase = doc['isHoldPurchase'];
  //       //
  //       //   });
  //
  //       // });
  //       // DocObj model = DocObj.setDetails(item.data());
  //       // bool valueCart = false;
  //       // await FirebaseFirestore.instance
  //       //     .collection('wawastore')
  //       //     .doc('wawastore')
  //       //     .collection('inCart')
  //       //     .where('name',isEqualTo: item['name'])
  //       //     .get().then((value) {
  //       //   if (value.docs.isNotEmpty) {
  //       //
  //       //     setState(() {
  //       //       valueCart = true;
  //       //     });
  //       //   }else{
  //       //     setState(() {
  //       //       valueCart = false;
  //       //     });
  //       //   }
  //       //
  //       //
  //       //
  //       // });
  //       // await FirebaseFirestore.instance
  //       //     .collection('wawastore')
  //       //     .doc('wawastore')
  //       //     .collection('inCart')
  //       //     .add({
  //       // "code" : code,
  //       // "name" : name,
  //       // "price" : prices,
  //       // "unit": unitcodes,
  //       // "amount": listAmounts,
  //       // "subtotal": listSubtotals,
  //       // "uid":uid
  //       // String uid = 'user';
  //       bool _inCart = false;
  //       String _qtyInCart = "";
  //
  //       if (uid != 'user') {
  //         await FirebaseFirestore.instance
  //             .collection('wawastore')
  //             .doc('wawastore')
  //             .collection('inCart')
  //             .where('name', isEqualTo: item['name'])
  //             .where('uid', isEqualTo: uid)
  //             .get()
  //             .then((value) {
  //           if (value.docs.isNotEmpty) {
  //             setState(() {
  //               _inCart = true;
  //             });
  //             List<String> qtyInCartList = [];
  //             String _qtyInCartStr = "";
  //             for (var item1 in value.docs) {
  //               _qtyInCartStr =
  //               'หน่วย: ${item1['unit']} จำนวน:# ${item1['amount']} ';
  //
  //               qtyInCartList.add(_qtyInCartStr);
  //             }
  //
  //             setState(() {
  //               _qtyInCart = qtyInCartList.toString();
  //             });
  //           }
  //         });
  //       }
  //       // print('####item[\'name\']===${item['name']}');
  //       // print('####_inCart===$_inCart');
  //       // print('####_qtyInCart===$_qtyInCart');
  //
  //       DocObjModel model = DocObjModel.fromMap({
  //         "name": item['name'],
  //         "url": item['urlImage'],
  //         "id": item.id,
  //         "isHoldPurchase": item['isHoldPurchase'],
  //         "inCart": _inCart, //worked***
  //         "qtyInCart": _qtyInCart, //worked***
  //       });
  //       setState(() {
  //         listDocument.add(model);
  //       });
  //     }
  //
  //     setState(() {
  //       // listDocument.clear();
  //       loadingCategory = false;
  //     });
  //
  //     print('#####listDocument.length/fetchDocuments3===>>>${listDocument.length}');
  //   });
  // }
  // fetchDocuments2(Query<Map<String, dynamic>> collection) {
  //   collection.get().then((value) async {
  //     collectionState = value;
  //     // setState(() {
  //     //   listDocument.clear(); //แก้สะสมได้มั้ย === แก้ได้แต่โหลดใหม่ตลอด // ผลเสียมากกว่าได้
  //     // });
  //
  //     // value.docs.forEach((element) {
  //     //   print('#####element.data()>>>${element.data()}');
  //     //   setState(() {
  //     //     listDocument.add(DocObj.setDetails(element.data()));
  //     //   });
  //     // });
  //     //
  //     for (var item in value.docs) {
  //       // value.docs.forEach((element) {
  //       //  // print('#####element.data()>>>${element.data()}');
  //       //  // setState(() {
  //       //     // listDocument.add(DocObj.setDetails(element.data()));
  //       //  // });
  //       //   listDocument.add({
  //       //     "documentName" : element.data()["name"],
  //       //     "documentUrl" : element.data()["name"]
  //       //
  //       //
  //       //   // documentName = doc['name'];
  //       //   // documentUrl = doc['urlImage'];
  //       //   // documentId = doc['id'];
  //       //   // isHoldPurchase = doc['isHoldPurchase'];
  //       //
  //       //   });
  //
  //       // });
  //       // DocObj model = DocObj.setDetails(item.data());
  //       // bool valueCart = false;
  //       // await FirebaseFirestore.instance
  //       //     .collection('wawastore')
  //       //     .doc('wawastore')
  //       //     .collection('inCart')
  //       //     .where('name',isEqualTo: item['name'])
  //       //     .get().then((value) {
  //       //   if (value.docs.isNotEmpty) {
  //       //
  //       //     setState(() {
  //       //       valueCart = true;
  //       //     });
  //       //   }else{
  //       //     setState(() {
  //       //       valueCart = false;
  //       //     });
  //       //   }
  //       //
  //       //
  //       //
  //       // });
  //       // await FirebaseFirestore.instance
  //       //     .collection('wawastore')
  //       //     .doc('wawastore')
  //       //     .collection('inCart')
  //       //     .add({
  //       // "code" : code,
  //       // "name" : name,
  //       // "price" : prices,
  //       // "unit": unitcodes,
  //       // "amount": listAmounts,
  //       // "subtotal": listSubtotals,
  //       // "uid":uid
  //       // String uid = 'user';
  //       bool _inCart = false;
  //       String _qtyInCart = "";
  //
  //       if (uid != 'user') {
  //         await FirebaseFirestore.instance
  //             .collection('wawastore')
  //             .doc('wawastore')
  //             .collection('inCart')
  //             .where('name', isEqualTo: item['name'])
  //             .where('uid', isEqualTo: uid)
  //             .get()
  //             .then((value) {
  //           if (value.docs.isNotEmpty) {
  //             setState(() {
  //               _inCart = true;
  //             });
  //             List<String> qtyInCartList = [];
  //             String _qtyInCartStr = "";
  //             for (var item1 in value.docs) {
  //               _qtyInCartStr =
  //               'หน่วย: ${item1['unit']} จำนวน:# ${item1['amount']} ';
  //
  //               qtyInCartList.add(_qtyInCartStr);
  //             }
  //
  //             setState(() {
  //               _qtyInCart = qtyInCartList.toString();
  //             });
  //           }
  //         });
  //       }
  //       // print('####item[\'name\']===${item['name']}');
  //       // print('####_inCart===$_inCart');
  //       // print('####_qtyInCart===$_qtyInCart');
  //
  //       DocObjModel model = DocObjModel.fromMap({
  //         "name": item['name'],
  //         "url": item['urlImage'],
  //         "id": item.id,
  //         "isHoldPurchase": item['isHoldPurchase'],
  //         "inCart": _inCart, //worked***
  //         "qtyInCart": _qtyInCart, //worked***
  //       });
  //       setState(() {
  //         listDocument.add(model);
  //       });
  //     }
  //
  //     print('#####listDocument.length/fetchDocuments2===>>>${listDocument.length}');
  //   });
  // }

  // Widget buildCard(int index) => Container(
  //   width:screen *0.45 ,
  //   height:160 ,
  //   child: Column(children: [
  //                   ProductItemBox(
  //                       imageurl: '${listDocument[index]['urlImage']}',
  //                       width: screen * 0.45-10,
  //                       height: 120),
  //
  //                 Text(
  //                   '${listDocument[index]['name']}',
  //                   overflow: TextOverflow.ellipsis,
  //                   softWrap: false,
  //                   maxLines: 3,
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
  //                 ),
  //
  //   ],),
  // );
}
