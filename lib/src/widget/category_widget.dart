import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wawa/global.dart';

class CategoryWidget extends StatefulWidget {
  final Function(DocumentSnapshot) onChange;
  CategoryWidget({required this.onChange});
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // params
  // final dbRef = Firestore.instance;

  // List<CategoryModel> categoryModels = List();
  bool loading = false;
  String selectedCategory = "004";
  List<DocumentSnapshot> categories = [];

  Future getCategory() async {
    setState(() {
      loading = true;
    });
    // await Firebase.initializeApp().then((value) async {
      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance
            .collection('wawastore')
                            .doc('wawastore')
            .collection('category')
            .orderBy('name')
            .get();

        setState(() {
          categories = snapshot.docs;
          loading = false;
          if (categories.isNotEmpty) {
            selectedCategory = categories[0]['itemcode'];
            widget.onChange(categories[0]);
          }
        });

        // await FirebaseFirestore.instance
        //     .collection('category')
        //     .orderBy('name')
        //     .snapshots()
        //     .listen((event) {
        //   int index = 0;

        //   for (var snapshot in event.docs) {
        //     index++;
        //     CategoryModel model = CategoryModel.fromMap(snapshot.data());
        //     setState(() {
        //       categoryModels.add(model);
        //     });
        //   }
        // });
      } catch (e) {
        print('e>>> ${e.toString()}');
      }
    // });

    // .document('yeRSeBlZRuU9xg0p2CrO')
    // .collection('categories')
    // .where('isPromotion',isEqualTo: true)
    // .getDocuments();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Text(
            'หมวดหมู่สินค้า',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                //จับมา map ใหม่
                children: categories.map((DocumentSnapshot document) {
                  return GestureDetector(
                    onTap: () {
                      // print(document['categoryName']);
                      if (loadingCategory == true) {
                        soldOutAlert('ระบบกำลังโหลดข้อมูล กรุณารอสักครู่ครับ');

                      }  else{
                        widget.onChange(document);
                        setState(() {
                          selectedCategory = document['itemcode'];
                          // selectedCategory = document.reference;  >> work
                          print('####selected==>>$selectedCategory');
                        });

                      }

                    },
                    child: Chip(
                      label: Text(
                        '${document['name']}',
                        style: selectedCategory == document['itemcode']
                            ? const TextStyle(color: Colors.white, fontSize: 24)
                            : const TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      backgroundColor: selectedCategory == document['itemcode']
                          ? Colors.black
                          : Colors.black26,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ))
      ],
    );
  }
}
