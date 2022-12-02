import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:wawa/src/widget/product_box.dart';
import 'package:wawa/states/choose_product.dart';

class 


ProductListWidget extends StatefulWidget {
  final Function onAdItem;
  final List<DocumentSnapshot> products;
  ProductListWidget({required this.products, required this.onAdItem});
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  double screen =0;
  double screen2 =0;
  String uid = 'user';

  Future<Null> checkLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event?.uid != null) {
          setState(() {
            uid = event!.uid;
          });
          print('####uid>>${event!.uid}');
        } else {
         
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    screen2 = MediaQuery.of(context).size.height;
    return 
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รายการในหมวดหมู่',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 30,
                margin: EdgeInsets.only(bottom: 5),
                child: Chip(
                  padding: EdgeInsets.only(bottom: 5),
                  label: Text(
                    '${widget.products.length} รายการ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  backgroundColor: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        ResponsiveGridList(
          scroll: false,
            desiredItemWidth: 160,
            minSpacing: 5,
            children: widget.products.map((DocumentSnapshot product) {
              return Column(
                children: [
        GestureDetector(
          onTap: () async {
            if (uid == 'user') {
               Navigator.of(context).pushNamed('/authen');
              
            } else {
               String res = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChooseProduct(
                products: product,
                onAdItem: () => widget.onAdItem(),
              ),
            ));
            if (res == 'save') {
              widget.onAdItem();
              print('###res>>>${res.toString()}');
            }
            }
           
          },
          child:
           // Image.network('${product['urlImage']}',width: screen * 0.6, height: 150),
          ProductItemBox(
              imageurl: '${product['urlImage']}',
              width: screen * 0.6,
              height: 150),
        ),
        // SizedBox(height: 10,),
        Text(
          '${product['name']}',
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 3,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}
