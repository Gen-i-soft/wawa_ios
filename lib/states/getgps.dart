import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wawa/utility/helper.dart';
import 'package:wawa/utility/my_style.dart';

class GetGPSPage extends StatefulWidget {
  final String docNo;
  GetGPSPage({required this.docNo});
  @override
  _GetGPSPageState createState() => _GetGPSPageState();
}

class _GetGPSPageState extends State<GetGPSPage> {
  // Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  //final Location location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  Helper helper = Helper();
  final dbRef = FirebaseFirestore.instance;

  double lat = 0;
  double lng = 0;

  double lat2 = 17.1284055;
  double lng2 = 102.9624795;
  double distance =0;
  LatLng? latLng;
  double screen =0;
  bool onoff = true;
  //
  // Future<Null> findLatLng() async {
  //   // LocationData locationData = await findLocationData();
  //   Location location = new Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   locationData = await location.getLocation();
  //   setState(() {
  //     lat = locationData.latitude;
  //     lng = locationData.longitude;
  //   });
  //   LatLng _latLng = LatLng(lat, lng);
  //   setState(() {
  //     latLng = _latLng;
  //   });
  //   // print('lat####=$lat, lng####=$lng');
  // }
  // Widget slideLeft() {
  //   return IconButton(
  //     icon: Icon(Icons.menu),
  //     onPressed: () {
  //       _scaffoldKey.currentState.openDrawer();
  //     },
  //   );
  // }

  // Widget showDrawer() {
  //   return Drawer(child:

  //   ,);
  // }

   calDistance(double lat, double lng) async {
    // print('distance==>>>$distance');

    // return distance;
  }

  Future saveDataTwo() async {
    // String _uId = await helper.getStorage('uid');
    String _uId = FirebaseAuth.instance.currentUser!.uid;
//update ordered
    QuerySnapshot querys = await dbRef
        .collection('wawastore')
        .doc('wawastore')
        .collection('Report')
        .where('docNo', isEqualTo: widget.docNo)
        .get();

    for (var item in querys.docs) {
      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('Report')
          .doc(item.id)
          .update({
        "lat": lat2,
        "lng": lng2,
        "distance": 0.0,
      });
    }

    //update ordered-dashboard

//user-address

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  Future<void> confirmOrderTwo() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ระบุตำแหน่งที่อยู่',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: Colors.brown[600]
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 24,
                          color: Colors.red[400],
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400]),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Navigator.pop(context);
                          saveDataTwo();

                          // widget.onAdItem();
                        },
                        icon: Icon(Icons.check,
                            size: 20, color: Colors.green[500]),
                        label: Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[500]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future saveDataOne() async {
    // String _uId = await helper.getStorage('uid');
    String _uId = FirebaseAuth.instance.currentUser!.uid;
//update ordered

 double  _distance = await calDistance(lat, lng) ?? 0;

    QuerySnapshot querys = await dbRef
        .collection('wawastore')
        .doc('wawastore')
        .collection('Report')
        .where('docNo', isEqualTo: widget.docNo)
        .get();

    for (var item in querys.docs) {
      await dbRef
          .collection('wawastore')
          .doc('wawastore')
          .collection('Report')
          .doc(item.id)
          .update({
        "lat": lat,
        "lng": lng,
        "distance": distance,
      });
    }
    //update ordered-dashboard

//user-address

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  Future<Null> confirmOrderOne() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ระบุตำแหน่งจัดส่ง',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: Colors.brown[600]
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //ขีดแต่ใช้ได้ก็ ปล่อยผ่านจ้า
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 24,
                          color: Colors.red[400],
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400]),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Navigator.pop(context);
                          saveDataOne();

                          // widget.onAdItem();
                        },
                        icon: Icon(Icons.check,
                            size: 20, color: Colors.green[500]),
                        label: Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[500]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future<Null> gotoCurrentPosition() async {
    // CameraPosition hotel =
    //     CameraPosition(
    //       bearing: 192.8334901395799,
    //       target: LatLng(lat, lng),
    //        zoom: 19);

    CameraPosition _kLake = CameraPosition(
        //bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        // tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    //  final GoogleMapController controller = await _controller.future;
    //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    _add();
  }

  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    // ignore: unused_element
  void  calculateDistance(double lat, double lng, double lat2, double lng2) {
      double distance = 0;

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat) * p) / 2 +
          c(lat * p) * c(lat2 * p) * (1 - c((lng2 - lng) * p)) / 2;
      double _distance = 12742 * asin(sqrt(a));
      setState(() {
        distance = _distance;
      });
    }

    //distance = await calDistance(lat, lng);
    print('######distance===$distance');
    LatLng _latLng = LatLng(lat, lng);
    setState(() {
      latLng = _latLng;
    });
    _add();
    print('###lat>>>$lat, lng>>>$lng, latLng>>>$latLng');
  }

  void _add() {
    final MarkerId markerId = MarkerId('1');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: 'ตำแหน่งปัจจุบัน', snippet: ''),
      onTap: () {},
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  // void _onMarkerTapped(MarkerId markerId) {
  //   final Marker  tappedMarker = markers[markerId];
  //   if (tappedMarker != null) {
  //     setState(() {
  //       final MarkerId previousMarkerId = selectedMarker;
  //       if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
  //         final Marker resetOld = markers[previousMarkerId]
  //             .copyWith(iconParam: BitmapDescriptor.defaultMarker);
  //         markers[previousMarkerId] = resetOld;
  //       }
  //       selectedMarker = markerId;
  //       final Marker newMarker = tappedMarker.copyWith(
  //         iconParam: BitmapDescriptor.defaultMarkerWithHue(
  //           BitmapDescriptor.hueGreen,
  //         ),
  //       );
  //       markers[markerId] = newMarker;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
    //findLatLng();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('Delivery Address'),
      // ),
      body: lat == 0
          ? MyStyle().showProgress()
          : Stack(
              children: [
                GoogleMap(
                  //mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: latLng!,
                    zoom: 16,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (LatLng pos) {
                    setState(() {
                      latLng = pos;
                      lat = pos.latitude;
                      lng = pos.longitude;
                    });
                    _add();
                    print('##latLng>>>$latLng');
                  },
                  onLongPress: (LatLng pos) {
                    setState(() {
                      latLng = pos;
                      lat = pos.latitude;
                      lng = pos.longitude;
                    });
                    _add();
                    print('##latLng>>>$latLng');
                  },
                  markers: Set<Marker>.of(markers.values),
                  // polylines: Set<Polyline>.of(polylines.values),
                ),
                // SizedBox(height: 160),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    // Container(
                    //   height: 80,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //         begin: Alignment.centerLeft,
                    //         end: Alignment.centerRight,
                    //         colors: [
                    //           // Color(0xffAE1F5D),
                    //           // Color(0xffD01E7D),
                    //           Colors.orange[300],
                    //           Colors.orange[800]
                    //         ]),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 30),
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         // Navigator.of(context).pop();
                    //       },
                    //       child: Row(
                    //         children: [
                    //           IconButton(
                    //             icon: Icon(Icons.menu, size: 26),
                    //             onPressed: () {
                    //               // Navigator.of(context).push(MaterialPageRoute(
                    //               //   builder: (context) => ProfilePageEn(),
                    //               // ));
                    //             },
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 30),

                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.orange[200],
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: const Color(0x11000000),
                        //     offset: Offset(0, 3),
                        //     blurRadius: 3,
                        //   ),
                        // ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  'บันทึกตำแหน่งที่อยู่ในการจัดส่ง',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('($lat, $lng)')],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  confirmOrderTwo();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 120,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[200],
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.highlight_off),
                                      Text('ไม่บันทึก')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  confirmOrderOne();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 120,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[800],
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_outline_outlined),
                                      Text('บันทึก')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
