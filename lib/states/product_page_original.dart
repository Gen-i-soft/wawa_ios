
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:wawa/src/widget/best_seller_two.dart';
//import 'package:wawa/src/widget/best_seller.dart';
import 'package:wawa/src/widget/category_widget.dart';
import 'package:wawa/src/widget/product_list_widget.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/widget/productitembox.dart';

class ProductPageOriginal extends StatefulWidget {
  final Function onAdItem;
  ProductPageOriginal({required this.onAdItem});
  @override
  _ProductPageOriginalState createState() => _ProductPageOriginalState();
}

class _ProductPageOriginalState extends State<ProductPageOriginal> {
  double screen =0;
  double screen2 =0;
  //String categoryId;
  String uid = 'user';

  double sizeWidth =0;
  int totalItems = 0;
  double total = 0;
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  //List<Widget> widgets = List();
  //อันนีัเตือนแต่ ไม่แดง ปล่อยผ่านจ้า

  bool loading = false;
  String categoryId = 'เครื่องดื่ม/นม';
  List<DocumentSnapshot> products = [];
  List<dynamic> widgets = [];
  List<String> productImages = [];

  Future<Null> getProduct() async {
    setState(() {
      //  products.clear();
      loading = true;
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wawastore')
          .doc('wawastore')
          .collection('product2')
          .where('categoryName', isEqualTo: categoryId)
          .where('isHoldSale', isEqualTo: false)
          .orderBy('brandName')
          .orderBy('groupMainName')
          .get();

      setState(() {
        loading = false;
        products = snapshot.docs;
      });

      // if (snapshot.docs.length > 0) {

      //   // for (var item in snapshot.docs) {
      //   //   print('####item>>>${item['name']}');
      //   //   products.add(item);
      //   // }
      // }
    } catch (e) {
      print('###error jaa>>>${e.toString()}');
      // TODO
    }

    //  try {
    //   await FirebaseFirestore.instance
    //       .collection('wawastore')
    //       .doc('wawastore')
    //       .collection('product2')
    //       .where('categoryName', isEqualTo: categoryId)
    //       .where('isHoldSale', isEqualTo:false)
    //       .orderBy('brandName')
    //       .orderBy('groupMainName')
    //       .snapshots()
    //       .listen((event) {
    //            setState(() {
    //       loading = false;
    //       for (var item in event.docs) {
    //         products.add(item);
    //       }

    //     });

    //       });
    // } catch (e) {
    //   print('###error jaa>>>${e.toString()}');
    //         // TODO
    // }

    //.where('isOn', isNotEqualTo: false)
    // .where('urlImage', isNotEqualTo: '')
    // .limit(200)
    // await Firebase.initializeApp().then((value) async {
    // if (categoryId == null) {
    //   QuerySnapshot snapshot = await FirebaseFirestore.instance
    //       .collection('wawastore')
    //       .doc('wawastore')
    //       .collection('product2')
    //       //.orderBy('groupMainName')
    //       //.orderBy('brandName')
    //       //.where('isOn', isNotEqualTo: false)
    //       // .where('urlImage', isNotEqualTo: '')
    //       // .limit(200)

    //       .get();
    //   setState(() {
    //     loading = false;
    //     products = snapshot.docs;
    //   });
    //   // print('i am null');
    // } else {
    //   QuerySnapshot snapshot = await FirebaseFirestore.instance
    //       .collection('wawastore')
    //       .doc('wawastore')
    //       .collection('product2')

    //       // .orderBy('brandName')
    //       // .where('urlImage', isNotEqualTo: '')
    //       .where('categoryName', isEqualTo: categoryId)
    //       //.orderBy('groupMainName', descending: true)
    //      // .orderBy('groupMainName', descending: false)
    //      // .orderBy('brandName')

    //       .get();
    //   setState(() {
    //     loading = false;
    //     products = snapshot.docs;
    //   });

    //   // print('i am not null');
    // }

    // print('####products==>>$products');

    // try {
    //   await FirebaseFirestore.instance
    //       .collection('product')
    //       .where('urlImage', isNotEqualTo: '')
    //       .snapshots()
    //       .listen((event) async {
    //     int index = 0;
    //     for (var snapshot in event.docs) {
    //       ProductCloudModel model =
    //           ProductCloudModel.fromMap(snapshot.data());
    //       docts.add(snapshot.id);

    //       setState(() {
    //         productModels.add(model);
    //         widgets.add(createWidget(model, index));
    //       });
    //       index++;
    //     }
    //   });
    // } catch (e) {
    //   print('e>>>${e.toString()}');
    // }
    // });
  }

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
    getProduct();
    // getImages();
    super.initState();

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     amountListView = amountListView + 4;
    //   }
    // });
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
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    screen2 = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // foregroundColor: Colors.black,
        backgroundColor: Colors.grey[400],
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _onTop();
        },
      ),
      // backgroundColor: Color(0xffCBC5C0),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 3, left: 10),
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
              padding: EdgeInsets.only(top: 2, left: 10),
              child: CategoryWidget(
                onChange: (DocumentSnapshot document) {
                  //  print('onchange=>>>${document['itemcode']}');
                  setState(() {
                    categoryId = document['name'];
                    // พอตัวนี้เปลี่ยนมันจะไปบังคับให้ตัวอื่นเปลี่ยนตาม
                  });
                  getProduct();

                  // print('document>>>${document['name']}');
                },
              ),
              height: 90,
              color: Colors.white,
            ),

            // Container(
            //   alignment: Alignment.topLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: Row(
            //       children: [

            //         Text(
            //           'รายการสินค้าในหมวดหมู่',
            //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //         ),
            //         SizedBox(width: 10),
            //         Container(
            //           padding: EdgeInsets.only(left: 5, right: 5),
            //           width: 120,
            //           height: 40,
            //           decoration: BoxDecoration(
            //               color: Colors.orange[200],
            //               borderRadius: BorderRadius.circular(10)),
            //           child: GestureDetector(
            //             onTap: () {
            //               Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (context) => SearchVersionTwo(
            //                     onAdItem: () => widget.onAdItem()),
            //               ));
            //             },
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   Icons.search,
            //                   size: 28,
            //                   color: Colors.orange[900],
            //                 ),
            //                 Text('ค้นหา',
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         color: Colors.orange[800],
            //                         fontSize: 28)),
            //               ],
            //             ),
            //           ),
            //         ),
            //         Text('5 รายการ')

            //       ],
            //     ),
            //   ),
            // ),BestSellerWidget(onAdItem: () => widget.onAdItem()),
            Container(
              //height: 300,
                margin: EdgeInsets.only(top: 5),
                child: ProductListWidget(
                  onAdItem: () => widget.onAdItem(),
                  products: products,
                )),
            //  Column(
            // children: [
            //       Padding(
            //         padding: const EdgeInsets.only(left: 10, right: 10,top:10),
            //         child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'รายการในหมวดหมู่',
            //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //     ),
            //     Container(
            //       height: 30,
            //       margin: EdgeInsets.only(bottom: 5),
            //       child: Chip(
            //         padding: EdgeInsets.only(bottom: 5),
            //         label: Text(
            //   '${products.length} รายการ',
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 20),
            //         ),
            //         backgroundColor: Colors.black45,
            //       ),
            //     ),
            //   ],
            //         ),
            //       ),
            //       Expanded(
            //           child: ResponsiveGridList(
            //     desiredItemWidth: 160,
            //     minSpacing:5,
            //     children: products.map((DocumentSnapshot product) {
            //   return Column(
            //   children: [
            //     GestureDetector(
            //       onTap: () async {
            //     if (uid == 'user') {
            //    Navigator.of(context).pushNamed('/authen');

            //     } else {
            //    String res = await Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => ChooseProduct(
            //   products: product,
            //   onAdItem: () => widget.onAdItem(),
            //   ),
            //     ));
            //     if (res == 'OK') {
            //   widget.onAdItem();
            //   print('###res>>>${res.toString()}');
            //     }
            //     }

            //       },
            //       child: ProductItemBox(
            //   imageurl: '${product['urlImage']}',
            //   width: screen * 0.6,
            //   height: 150),
            //     ),
            //     // SizedBox(height: 10,),
            //     Text(
            //       '${product['name']}',
            //       overflow: TextOverflow.ellipsis,
            //       softWrap: false,
            //       maxLines: 3,
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            //     ),
            //   ],
            //   );
            //     }).toList(),
            //       ),
            //       ),
            //  // ],
            // )

// Expanded(child: Responsive)

            // Expanded(
            //   child: GridView.extent(
            //     maxCrossAxisExtent: 300,
            //     children: widgets,
            //   ),
            // ),
            // Expanded(
            //     child: Container(
            //   margin: EdgeInsets.only(top: 3),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(child: ListProduct(categoryId: categoryId,onAdItem: () => widget.onAdItem())),
            //     ],
            //   ),
            //   color: Colors.white,
            // )),
          ],
        ),
      ),
    );
  }
}
