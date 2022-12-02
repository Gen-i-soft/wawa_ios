import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:wawa/models/product_cloud_model.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/utility/sqlite_helper.dart';

class Promotion extends StatefulWidget {
  final Function onAdItem;
  Promotion({required this.onAdItem});
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  List<ProductCloudModel> productModels = [];
  List<Widget> widgets = [];
  List<String> docts = [];
  double sizeWidth =0;
  int totalItems = 0;
  double total = 0;
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  double screen =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();
    //lazy load controll ด้วย scroller

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 2;
      }
    });
  }

  Future<Null> readCart() async {
    print('##############>>>>readCart work ');
    try {
      await SQLiteHelper().readSQLite().then((value) {
        int index = 0;
        for (var string in value) {
          String sumString = string.subtotals;
          double sumDouble = double.parse(sumString);
          setState(() {
            total = total + sumDouble;
          });
          index++;
        }

        setState(() {
          totalItems = index;
        });
      });
    } catch (e) {
      print('########### status in SQLite ===>>> ${e.toString()}');
    }
  }

  Future<Null> readProduct() async {
    // await Firebase.initializeApp().then((value) async {
    await FirebaseFirestore.instance
        .collection('wawastore')
        .doc('wawastore')
        .collection('product2')
        .where('isPremium', isEqualTo: true)
        // .collection('product')
        //.where('isPromotion', isEqualTo: true)
        // .orderBy('name', descending: false)
        //  .limit(50)
        .snapshots()
        .listen((event) async {
      int index = 0;
      for (var snapshot in event.docs) {
        ProductCloudModel model = ProductCloudModel.fromMap(snapshot.data());
        docts.add(snapshot.id);

        setState(() {
          productModels.add(model);
          // widgets.add(createWidget(model, index));
        });
        index++;
      }
    });
    // });
  }

  // Widget createWidget(ProductCloudModel model, int index) => GestureDetector(
  //       onTap: () async {
  //         // print(
  //         //     '###################Sentdata url ==>> ${productModels[index].urlImage}');
  //         // var res = await Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => ChooseProduct(
  //         //       onAdItem: () => widget.onAdItem(),
  //         //       productModel: productModels[index],
  //         //       doct: docts[index],
  //         //     ),
  //         //   ),
  //         // );
  //         // if (res != null) {
  //         //   widget.onAdItem();
  //         // }
  //       },
  //       child: Card(
  //         child:
  // Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: screen*0.8,

  //               height: screen*0.6,
  //               child: CachedNetworkImage(
  //                 fit: BoxFit.cover,
  //                 imageUrl: model.urlImage,
  //                 errorWidget: (context, url, error) =>
  //                     Image.asset('images/image.png'),
  //                 placeholder: (context, url) => MyStyle().showProgress(),
  //               ),
  //             ),
  //             Container(
  //                 width: sizeWidth * 0.5 - 16,
  //                 child: Text(
  //                   model.name,
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

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'โปรโมชัน',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: productModels.length == 0
            ? MyStyle().showProgress()
            : buildListView()
        // SafeArea(
        //     child: GridView.extent(
        //       maxCrossAxisExtent: 300,
        //       children: widgets,
        //     ),
        //   ),
        );
  }

  ListView buildListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        elevation: 3,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  DocumentSnapshot product = await FirebaseFirestore.instance
                      .collection('wawastore')
                      .doc('wawastore')
                      .collection('product2')
                      .doc(docts[index])
                      .get();
                  print('####product.id>>>${product.id}');

                  String res =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChooseProduct(
                      products: product,
                      onAdItem: () => widget.onAdItem(),
                    ),
                  ));
                  if (res == "save") {
                    widget.onAdItem();
                  }
                },
                child: Container(
                  // width: sizeWidth * 0.8,
                  // height: sizeWidth * 0.6,
                  child: CachedNetworkImage(
                    //fit: BoxFit.cover,
                    imageUrl: productModels[index].urlImage,
                    errorWidget: (context, url, error) =>
                        Image.asset('images/image.png'),
                    placeholder: (context, url) => MyStyle().showProgress(),
                  ),
                ),
              ),

              // Positioned(left: 30,right:30,bottom:20,
              //   child: Wrap(
              //   children: [
              //     Text(productModels[index].name,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              //   ],
              // ))
            ]
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: MyStyle().titleH2dark(productModels[index].name),
            // ),
            ),
      ),
    );
  }
}
