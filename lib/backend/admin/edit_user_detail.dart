import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wawa/backend/admin/adminhomepage.dart';

class EditUserDetail extends StatefulWidget {
  final DocumentSnapshot document;
  EditUserDetail({required this.document});
  @override
  _EditUserDetailState createState() => _EditUserDetailState();
}

class _EditUserDetailState extends State<EditUserDetail> {
  final dbRef = FirebaseFirestore.instance;
  List<String> status = [
    'user',
    'admin',
    'rider'
  ];

  // List<bool> statusUsed = [
  //   true,
  //   false
  //
  // ];
  String? selectedType;
  bool selectedUsed = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController addrCtrl = TextEditingController();
  TextEditingController displayNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController employeeCodeCtrl = TextEditingController();
  TextEditingController lineIdCtrl = TextEditingController();
  TextEditingController telCtrl = TextEditingController();

  Future<Null> updateUser() async {
    //update table report
    try {
      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('backend')
          .doc(widget.document.id)
          .update({
        // "photoURL": urlPicture,
        "displayName": displayNameCtrl.text.trim(),
        "tel": telCtrl.text.trim(),
        "addr": addrCtrl.text.trim(),
        "lineId": lineIdCtrl.text.trim(),
        "employeeCode": employeeCodeCtrl.text.trim(),

        "typeUser": selectedType,
        "open" : selectedUsed
        //ดัดแปลงเอาจ้า
        
      });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AdminHomePage(),) ,(route) => false);
    } catch (e) {
      print('error>>${e.toString()}');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();

   addrCtrl.text = widget.document['addr'];
    displayNameCtrl.text = widget.document['displayName'];
    emailCtrl.text = widget.document['email'];
  employeeCodeCtrl.text = widget.document['employeeCode'];
  lineIdCtrl.text = widget.document['lineId'];
    telCtrl.text = widget.document['tel'];
    selectedType = widget.document['typeUser'];
    selectedUsed = widget.document['open'];
    

    // img = widget.document['img'];
    //ถ้าไม่กระตุ้นไม่ออกจ้า กรรมจริง
    print('###widget.document[\'email\']>>>${widget.document['email']}');
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลผู้ใช้งาน'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
            Column(
              children: [

                TextFormField(
                  //  initialValue: vacab,
                  controller: displayNameCtrl,

                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      labelText: 'ชื่อ',
                      // helperText: '',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400))),
                ),
                SizedBox(
                  height: 10,
                ),
                //  TextFormField(
                //     //  initialValue: vacab,
                //     controller: emailCtrl,

                //     style: TextStyle(
                //         fontSize: 24,
                //         color: Colors.black,
                //         fontWeight: FontWeight.bold),
                //     decoration: InputDecoration(
                //         prefixIcon: Icon(Icons.perm_identity),
                //         labelText: 'อีเมล์',
                //         // helperText: '',
                //         fillColor: Colors.white,
                //         filled: true,
                //         enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.grey[200]))),
                // ),
                // SizedBox(
                //     height: 10,
                // ),
                TextFormField(
                  //  initialValue: vacab,
                  controller: addrCtrl,

                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.home),
                      labelText: 'ที่อยู่ในการจัดส่ง',
                      // helperText: '',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  //  initialValue: vacab,
                  controller: telCtrl,

                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      labelText: 'เบอร์โทร',
                      // helperText: '',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  //  initialValue: vacab,
                  controller: employeeCodeCtrl,

                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      labelText: 'รหัสสมาชิก SML',
                      // helperText: '',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  //  initialValue: vacab,
                  controller: lineIdCtrl,

                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.perm_identity),
                      labelText: 'Line ID',
                      // helperText: '',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200))),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('ประเภทผู้ใช้งาน',style: TextStyle(fontSize: 18),),
                Column(
                  children: status.map((item) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          selectedType = item;
                        });
                      },
                      leading: selectedType == item
                          ? Icon(
                              Icons.check_box,
                              color: Colors.green[700],
                            )
                          : Icon(Icons.check_box_outline_blank),
                      title: Text(item,style: TextStyle(fontSize: 16),),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10,),
                Text('ลบผู้ใช้งาน (สีฟ้า = ใช้งาน, สีเทา= ลบ***)',style: TextStyle(fontSize: 18),),
                Switch(value: selectedUsed, onChanged:(value){
                  setState(() {
                    selectedUsed = value;
                  });

                }),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    backgroundColor: Colors.grey[500],
                    textStyle: TextStyle(
                      color: Colors.white,
                    )
                  ),


                  onPressed: () {
                    updateUser();
                  //   Navigator.of(context).pop(true);
                  },
                  icon: Icon(
                    Icons.save,
                    size: 24,
                  ),
                  label: Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
