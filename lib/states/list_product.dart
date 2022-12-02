import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:wawa/models/product_cloud_model.dart';
import 'package:wawa/states/choose_product.dart';
import 'package:wawa/utility/my_style.dart';
import 'package:wawa/utility/sqlite_helper.dart';

class ListProduct extends StatefulWidget {
  final String categoryId;
  final Function onAdItem;
  ListProduct({required this.onAdItem, required this.categoryId});
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final dbRef = FirebaseFirestore.instance;
  List<ProductCloudModel> productModels = [];
  List<Widget> widgets = [];
  List<String> docts = [];
  double sizeWidth =0;
  int totalItems = 0;
  double total = 0;
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  double screen =0;
  double screen2 =0;
  bool loading = false;
  List<DocumentSnapshot> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();
    //lazy load controll ด้วย scroller

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 4;
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
    setState(() {
      loading = true;
    });
    // await Firebase.initializeApp().then((value) async {
      if (widget.categoryId == null) {
        // QuerySnapshot snapshot = await FirebaseFirestore.instance
        QuerySnapshot snapshot = await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('product')
            // .where('urlImage', isNotEqualTo: '')
            .where('isOn', isEqualTo: true)
            .get();
        setState(() {
          loading = false;
          products = snapshot.docs;
        });
      } else {
        QuerySnapshot snapshot = await dbRef
            .collection('wawastore')
            .doc('wawastore')
            .collection('product')
            // .where('urlImage', isNotEqualTo: '')
            .where('isOn', isEqualTo: true)
            .where('categoryName', isEqualTo: widget.categoryId)
            .get();
        setState(() {
          loading = false;
          products = snapshot.docs;
        });
      }

      print('listproduct==>>$products');

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

  Widget createWidget(DocumentSnapshot products) => GestureDetector(
        onTap: () async {
          print('###################Sentdata url ==>> ${products['urlImage']}');
          var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseProduct(
                onAdItem: () => widget.onAdItem(),
                products: products,
                // productModel: products,
                // doct: docts[index],
              ),
            ),
          );
          if (res != null) {
            widget.onAdItem();
          }
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screen * .4,
                height: 120,
                child: CachedNetworkImage(
                  // fit: BoxFit.cover,
                  imageUrl: products['urlImage'],
                  errorWidget: (context, url, error) =>
                      Image.asset('images/image.png'),
                  placeholder: (context, url) => MyStyle().showProgress(),
                ),
              ),
              Container(
                  width: sizeWidth * 0.5 - 16,
                  child: Text(
                    products['name'],
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ))
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width;
    screen = MediaQuery.of(context).size.width;
    screen2 = MediaQuery.of(context).size.height;

    return Scaffold(
      body: widgets.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 300,
              children: widgets,
            ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      controller: scrollController,
      itemCount: products.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyStyle().titleH2dark(products[index]['name']),
        ),
      ),
    );
  }
}
