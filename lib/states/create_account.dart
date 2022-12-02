import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wawa/utility/dialog.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  List<firebase_storage.UploadTask> _uploadTasks = [];
  File? file;
  final picker = ImagePicker();

  final dbRef = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double screen =0;
  String? name, user, password, adrs, tel, imgUrl, employeeCode, lineId;
  Helper helper = new Helper();
  String? urlPicture;

  // Future<firebase_storage.UploadTask> uploadFile(PickedFile file) async {
  //   Random random = Random();
  //   int i = random.nextInt(100000);
  //   if (file == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('No file was selected'),
  //     ));
  //     return null;
  //   }
  //   await firebase_core.Firebase.initializeApp().then((value) async {
  //     firebase_storage.UploadTask uploadTask;

  //     // Create a Reference to the file
  //     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('images')
  //         .child('/user$i.jpg');

  //     final metadata = firebase_storage.SettableMetadata(
  //         contentType: 'image/jpeg',
  //         customMetadata: {'picked-file-path': file.path});

  //     if (kIsWeb) {
  //       uploadTask = ref.putData(await file.readAsBytes(), metadata);
  //     } else {
  //       uploadTask = ref.putFile(io.File(file.path), metadata);
  //     }

  //     return Future.value(uploadTask);
  //   });
  // }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    String nameFile = 'user$i.jpg';

    Reference reference =
        FirebaseStorage.instance.ref().child('member/$nameFile');
    UploadTask uploadTask = reference.putFile(file!);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((value) {
        if (value.isEmpty) {

          
        }
      });
    });

    // FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    // StorageReference storageReference =
    //     firebaseStorage.ref().child('img/user$i.jpg');

    // StorageUploadTask storageUploadTask = storageReference.putFile(file);

    // urlPicture =
    //     await (await storageUploadTask.onComplete).ref.getDownloadURL();
  }

  Future getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.getImage(
          source: imageSource, maxHeight: 800, maxWidth: 800);
      //ให้วาดใหม่อีกรอบ
      setState(() {
        if (pickedFile != null) {
          file = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('e>>>${e.toString()}');
    }
  }

  Widget showImage() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/image.png') : Image.file(file!),
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
        color: Colors.purple[600],
      ),
      onPressed: () {
        getImage(ImageSource.gallery);
      },
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
        color: Colors.purple[600],
      ),
      onPressed: () {
        getImage(ImageSource.camera);
      },
    );
  }

  Container buildLineId() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => lineId = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          labelText: 'Line ID',
          prefixIcon: Icon(
            Icons.qr_code,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildEmployeeCode() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => employeeCode = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          labelText: 'รหัสสมาชิก SML',
          prefixIcon: Icon(
            Icons.group,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildTel() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => tel = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          labelText: 'เบอร์โทรศัพท์',
          prefixIcon: Icon(
            Icons.call,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildAdrs() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (value) => adrs = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          labelText: 'ที่อยู่ในการจัดส่ง',
          prefixIcon: Icon(
            Icons.home,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildName() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 64),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          labelText: 'ชื่อ',
          prefixIcon: Icon(
            Icons.fingerprint,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          // hintStyle: TextStyle(color: MyStyle().darkColor),
          // hintText: 'อีเมล์ :',
          labelText: 'อีเมล์',
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),

          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'รหัสผ่านอย่างน้อย 6 ตัวอักษร',
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          prefixIcon: Icon(
            Icons.lock_open_outlined,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('สร้างบัญชีผู้ใช้ใหม่'),
      ),
      //  resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: false,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x66976997),
                Color(0x99976997),
                Color(0xcc976997),
                Color(0xff976997)
              ]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: MyStyle().showLogo(150, 150),
                ),
                buildName(),
                buildUser(),
                buildPassword(),
                buildAdrs(),
                buildTel(),
                buildEmployeeCode(),
                buildLineId(),
                // Column(
                //   children: [
                //     showImage(),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [cameraButton(), galleryButton()],
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                buildCreateAccount(),
                SizedBox(
                  height: 30,
                ),

                // buildGotoLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateAccount() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff1E6B85),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        //
        onPressed: () {
          if ((name?.isEmpty ?? true) ||
              (user?.isEmpty ?? true) ||
              (password?.isEmpty ?? true)) {
            normalDialog(
                context, 'มีช่องว่าง', 'กรุณากรอกข้อมูลให้ครบทุกช่องครับ');
          } else {
            registerThread();
          }
        },
        child: Text(
          'สร้างบัญชีใหม่',
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildGotoLogin() {
    return GestureDetector(
      onTap: () {
        //  Navigator.pushNamed(context, '/authenn');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ลงชื่อเข้าใช้งาน',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Future<Null> registerThread() async {
    await Firebase.initializeApp().then((value) async {
      // normalDialog(context, "Initial Success", 'Good');

      // print('initialize Success');
      // if (_image != null) {
      // uploadPictureToStorage();

      await _auth
          .createUserWithEmailAndPassword(email: user!, password: password!)
          .then((value) async {
        // UserUpdateInfo updateInfo = UserUpdateInfo();
        // updateInfo.displayName = name;
        // updateInfo.photoUrl = urlPicture;
        try {
          await dbRef
              .collection('wawastore')
              .doc('wawastore')
              .collection('backend')
              .add({
            "uid": value.user!.uid,
            // "photoURL": urlPicture,
            "displayName": name,
            "tel": tel,
            "addr": adrs,
            "lineId": lineId,
            "employeeCode": employeeCode,
            "email": user,
            "typeUser":'user',
            "password" : password,
            "open" : true
            //ดัดแปลงเอาจ้า
          });
        } catch (e) {
          print('error>>>>>${e.toString()}');
        }

        Navigator.of(context).pop();
      });
      // }

      // else {
      //   await _auth
      //       .createUserWithEmailAndPassword(email: user, password: password)
      //       .then((value) async {
      //     // UserUpdateInfo updateInfo = UserUpdateInfo();
      //     // updateInfo.displayName = name;

      //     try {
      //       await dbRef
      //           .collection('wawastore')
      //           .doc('wawastore')
      //           .collection('backend')
      //           .add({
      //         "uid": value.user.uid,
      //         "displayName": name,
      //         "tel": tel,
      //         "addr": adrs,
      //         "lineId": lineId,
      //         "employeeCode": employeeCode,
      //         "email": user
      //       });
      //     } catch (e) {
      //       print('error   create account file !=null>>>>>${e.toString()}');
      //     }

      //     Navigator.of(context).pop();
      //   });
      // }

      //     .then((value) async {
      //   String _pictureUrl = value.user.photoURL;
      //   String _uid = value.user.uid;
      //   String _displayName = value.user.displayName;

      //   helper.setStorage('lineUserID', '');
      //   helper.setStorage('displayName', _displayName);

      //   helper.setStorage('pictureUrl', _pictureUrl);
      //   helper.setStorage('uid', _uid); //ทุกอย่างจะผูกกับ ฟิลด์นี้หมดเลยจ้า

      //   await value.user.updateProfile(displayName: name).then((value) {
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, '/homePage', (route) => false);
      //   });
      // }).catchError((value) {
      //   normalDialog(context, value.code, value.message);
      // });
      // }).catchError((value) {
      //   print('error initial => ${value.message}');
      // });
    });
  }
}
