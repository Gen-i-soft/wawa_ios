
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:wawa/models/product_cloud_model.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/widget/productitembox.dart';

class BestSellerTwoWidget extends StatefulWidget {
  final Function onAdItem;
  BestSellerTwoWidget({required this.onAdItem});
  @override
  _BestSellerTwoWidgetState createState() => _BestSellerTwoWidgetState();
}

class _BestSellerTwoWidgetState extends State<BestSellerTwoWidget> {
  // params
  // final dbRef = Firestore.instance;
  List<String> productImages = [];

  List<dynamic> widgets = [];
  List<String> docts = [];
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  List<DocumentSnapshot> products = [];
  final dbRef = FirebaseFirestore.instance;

  // List<DocumentSnapshot> promotions = [];
  bool loading = false;
  double screen =0;

  //Method

//แบบเผื่อเรียก
  // Future getImages() async {
  //   setState(() {
  //     loading = true;
  //     // productImages.clear();
  //   });
  //   //await Firebase.initializeApp().then((value) async {
  //   QuerySnapshot qsImage = await FirebaseFirestore.instance
  //       .collection('wawastore')
  //       .doc('wawastore')
  //       .collection('priceBuy')
  //       .orderBy('subtotal', descending: true)
  //       .limit(300)
  //      // .where('isPremium', isEqualTo: true)
  //       .get();

  //   if (qsImage.docs.length > 0) {
  //     for (var item in qsImage.docs) {
  //       print('####item[urlImage]>>>${item['urlImage']}');
  //       setState(() {
  //         // productImages.add(item['urlImage']);
  //        // widgets.add(NetworkImage(item['urlImage']));
  //       });
  //     }
  //    // print('####widgets>>$widgets');
  //   }
  //   loading = false;

  //   //     .snapshots()
  //   //     .listen((event) {
  //   //             loading = false;
  //   // int index = 0;
  //   // for (var snapshot in event.docs) {
  //   //   ProductCloudModel model = ProductCloudModel.fromMap(snapshot.data());
  //   // docts.add(snapshot.id);
  //   // print('id===>>${snapshot.id}');
  //   // setState(() {
  //   //  // productModels.add(model);
  //   //  // widgets.add(createWidget(model, index));
  //   // });
  //   // index++;
  // }

  //    });

  // setState(() {
  //   products = snapshot.docs;
  // });

  //   // await FirebaseFirestore.instance
  //   //     .collection('product')

  //   //     .snapshots()
  //   //     .listen((event) {
  //   //   loading = false;
  //   //   int index = 0;
  //   //   for (var snapshot in event.docs) {
  //   //     ProductCloudModel model = ProductCloudModel.fromMap(snapshot.data());
  //   //     docts.add(snapshot.id);
  //   //     // print('id===>>${snapshot.id}');
  //   //     setState(() {
  //   //       productModels.add(model);
  //   //       widgets.add(createWidget(model, index));
  //   //     });
  //   //     index++;
  //   //   }
  //   // });
  //   // });
  Future<Null> getProduct()async{
     setState(() {
       products.clear();
     });
 QuerySnapshot qssnap = await   FirebaseFirestore.instance
                    .collection('wawastore')
                    .doc('wawastore')
                    .collection('product2')
                    .where('isPremium', isEqualTo: true)
                    .get();
                    // .orderBy('subtotal', descending: true)
                    //  .limit(200)
                    //.where('isPremium', isEqualTo: true)
                  setState(() {
                    products = qssnap.docs;
                  });

  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // getImages();
    getProduct();

    //lazy load controll ด้วย scroller

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 2;
      }
    });
  }

  // Widget createWidget(DocumentSnapshot products, int index) => GestureDetector(
  //     onTap: () async {
  //       String res = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChooseProduct(
  //             onAdItem: () => widget.onAdItem(),
  //             products: products,
  //             // doct: docts[index],
  //           ),
  //         ),
  //       );
  //       if (res != null) {
  //         widget.onAdItem();
  //       }
  //     },
  //     child: NetworkImage(productImages[index]),
  // );

  //  Container(
  //   width: 120,
  //   height: 120,
  //   child: Column(
  //     children: [
  //       Stack(
  //         children: [
  //           ProductItemBox(
  //             imageurl: products['urlImage'],
  //             width: 90,
  //             height: 90,
  //           ),
  //           Container(
  //               margin: EdgeInsets.all(5),
  //               // alignment: Alignment.center,
  //               width: 50,
  //               height: 20,
  //               decoration: BoxDecoration(
  //                   color: Colors.pink[100],
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: Center(
  //                   child: Text(
  //                 'ขายดี',
  //                 style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.red[600]),
  //               ))),
  //         ],
  //       ),
  //       Text(
  //         products[index].name,
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //         softWrap: false,
  //         style: TextStyle(fontSize: 18),
  //       )
  //     ],
  //   ),
  // )

  //     // Card(
  //     //   child: Column(
  //     //     mainAxisAlignment: MainAxisAlignment.center,
  //     //     children: [
  //     //       Container(
  //     //         width: 100,
  //     //         height: 100,

  //     //         child: CachedNetworkImage(
  //     //           fit: BoxFit.cover,
  //     //           imageUrl: model.urlImage,
  //     //           errorWidget: (context, url, error) =>
  //     //               Image.asset('images/image.png'),
  //     //           placeholder: (context, url) => MyStyle().showProgress(),
  //     //         ),
  //     //       ),
  //     //       Container(width: sizeWidth * 0.5 - 16, child: Text(model.name,
  //     //       overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 2,
  //     //       style: TextStyle(fontSize: 24, ),))
  //     //     ],
  //     //   ),
  //     // ),
  //     );

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loading
              ? LinearProgressIndicator(
                  backgroundColor: Colors.pink.shade100,
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                )
              : Container(),
          //   Container(
          // child: new Carousel(
          //     images: _listBannerImages(),
          //                     ),

          //                   )

          // SizedBox(
          //     height: 200.0,
          //      width: screen,
          //     child: new Carousel(
          //       boxFit: BoxFit.cover,
          //       images: widgets,

          //       // [
          //       //   NetworkImage('http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/image/2f4ccf05-0451-46f2-9752-a9132d0a0983?p=DATA&d=wawa2')

          //       // ],

          //       //  autoplayDuration: Duration(milliseconds: 1000),
          //       //  animationCurve: Curves.fastOutSlowIn,
          //         dotSize: 4.0,
          //         dotSpacing: 15.0,
          //         dotColor: Colors.lightGreenAccent,
          //         indicatorBgPadding: 6.0,
          //       //  dotBgColor: Colors.grey.withOpacity(0.5),
          //       // borderRadius: true,
          //     )),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'สินค้าแนะนำ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ],
            ),
          ),
          // Expanded(
          //     child: Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: StreamBuilder<QuerySnapshot>(
          //       stream: 
          // FirebaseFirestore.instance
          //           .collection('wawastore')
          //           .doc('wawastore')
          //           .collection('product2')
          //           .where('isPremium', isEqualTo: true)
          //           // .orderBy('subtotal', descending: true)
          //           //  .limit(200)
          //           //.where('isPremium', isEqualTo: true)

          //           .snapshots(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasError) {
          //           return new Text('Error: ${snapshot.error}');
          //         }
          //         switch (snapshot.connectionState) {
          //           case ConnectionState.waiting:
          //             return MyStyle().showProgress();

          //             break;
          //           default:

                     // return 
                      Expanded(
                                              child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: products
                                  .map((DocumentSnapshot document) {
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            // DocumentSnapshot documentSnapshot =
                                            //     await dbRef
                                            //         .collection('wawastore')
                                            //         .doc('wawastore')
                                            //         .collection('product2')
                                            //         .doc(document['code'])
                                            //         .get();
                                            // .where('')
                                            var res = await Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => ChooseProduct(
                                                onAdItem: () => widget.onAdItem(),
                                                products: document,
                                              ),
                                            ));

                                            if (res != null) {
                                              widget.onAdItem();
                                            }
                                          },
                                          child: ProductItemBox(
                                              imageurl: document['urlImage'],
                                              width: 140,
                                              height: 120),
                                        ),
                                        Positioned(
                                          top: 15,
                                          left: 5,
                                          child: Container(
                                            width: 50,
                                            height:20,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'แนะนำ',
                                              style:
                                                  TextStyle(color: Colors.pink),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.pink[50],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
             
          // Expanded(
          //   child: ListView(
          //       controller: scrollController,
          //       scrollDirection: Axis.horizontal,
          //       children: widgets

          //     [
          //       Wrap(
          //         spacing: 8,
          //         runSpacing: 8,
          //         children: productModels.map((item ) {
          //           return Column(
          //             children: [
          //               GestureDetector(

          //                 onTap: ()async{

          //                        var res = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context ) => ChooseProduct(
          //       onAdItem: () => widget.onAdItem(),
          //       productModel: productModels[index],
          //       doct: docts[index],
          //     ),
          //   ),
          // );
          // if (res != null) {
          //   widget.onAdItem();
          // }

          //                 },
          //                                         child: Stack(
          //                   children: [
          //                     ProductItemBox(
          //                       imageurl: item.urlImage,
          //                       width: 100,
          //                       height: 70,
          //                     ),
          //                     Container(
          //                         margin: EdgeInsets.all(5),
          //                         // alignment: Alignment.center,
          //                         width: 50,
          //                         height: 20,
          //                         decoration: BoxDecoration(
          //                             color: Colors.pink[100],
          //                             borderRadius: BorderRadius.circular(10)),
          //                         child: Center(
          //                             child: Text(
          //                           'ขายดี',
          //                           style: TextStyle(
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w600,
          //                               color: Colors.red[600]),
          //                         ))),
          //                   ],
          //                 ),
          //               ),
          //               Text(
          //                 item.name,
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 softWrap: false,
          //                 style: TextStyle(fontSize: 24),
          //               )
          //             ],
          //           );
          //         }).toList(),
          //       )
          //     ],

          // ),
          // )
        ]);
  }

  //                   _listBannerImages() {
  //   var bannerImages = [];
  //   for (var image in banners) {
  //     bannerImages.add(new GestureDetector(
  //       onTap: (){
  //       //  print(image.url);
  //       },
  //       child : Container(
  //         decoration: BoxDecoration(
  //             image: DecorationImage(
  //                 image: NetworkImage(image.image),
  //                 fit: BoxFit.cover)),
  //         height: 220.0,
  //         width: MediaQuery.of(context).size.width,
  //       ),
  //     ));
  //   }
  //   return bannerImages;
  // }
}
