import 'dart:convert';

class ReportModels {
  
  final String codeSale;
  final String? dateRecieve;
  final bool delivery;
  final String displayName;
  final String docDate;
  final String docNo;
  final String docTime;
  final num lat;
  final num lng;
  final String nameSale;
  final bool nodelivery;
  final String? note;
  final String status;
  final String statusCustomer;
  final String telephone;
  final num time;
  final num totalValue;
  final String uid;
  ReportModels({
    required this.codeSale,
    this.dateRecieve,
    required this.delivery,
    required this.displayName,
    required this.docDate,
    required this.docNo,
    required this.docTime,
    required this.lat,
    required this.lng,
    required this.nameSale,
    required this.nodelivery,
    this.note,
    required this.status,
    required this.statusCustomer,
    required this.telephone,
    required this.time,
    required this.totalValue,
    required this.uid,
  });

  

  ReportModels copyWith({
    String? codeSale,
    String? dateRecieve,
    bool? delivery,
    String? displayName,
    String? docDate,
    String? docNo,
    String? docTime,
    num? lat,
    num? lng,
    String? nameSale,
    bool? nodelivery,
    String? note,
    String? status,
    String? statusCustomer,
    String? telephone,
    num? time,
    num? totalValue,
    String? uid,
  }) {
    return ReportModels(
      codeSale: codeSale ?? this.codeSale,
      dateRecieve: dateRecieve ?? this.dateRecieve,
      delivery: delivery ?? this.delivery,
      displayName: displayName ?? this.displayName,
      docDate: docDate ?? this.docDate,
      docNo: docNo ?? this.docNo,
      docTime: docTime ?? this.docTime,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      nameSale: nameSale ?? this.nameSale,
      nodelivery: nodelivery ?? this.nodelivery,
      note: note ?? this.note,
      status: status ?? this.status,
      statusCustomer: statusCustomer ?? this.statusCustomer,
      telephone: telephone ?? this.telephone,
      time: time ?? this.time,
      totalValue: totalValue ?? this.totalValue,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codeSale': codeSale,
      'dateRecieve': dateRecieve,
      'delivery': delivery,
      'displayName': displayName,
      'docDate': docDate,
      'docNo': docNo,
      'docTime': docTime,
      'lat': lat,
      'lng': lng,
      'nameSale': nameSale,
      'nodelivery': nodelivery,
      'note': note,
      'status': status,
      'statusCustomer': statusCustomer,
      'telephone': telephone,
      'time': time,
      'totalValue': totalValue,
      'uid': uid,
    };
  }

  factory ReportModels.fromMap(Map<String, dynamic> map) {
    return ReportModels(
      codeSale: map['codeSale'] ?? '',
      dateRecieve: map['dateRecieve'],
      delivery: map['delivery'] ?? false,
      displayName: map['displayName'] ?? '',
      docDate: map['docDate'] ?? '',
      docNo: map['docNo'] ?? '',
      docTime: map['docTime'] ?? '',
      lat: map['lat'] ?? 0,
      lng: map['lng'] ?? 0,
      nameSale: map['nameSale'] ?? '',
      nodelivery: map['nodelivery'] ?? false,
      note: map['note'],
      status: map['status'] ?? '',
      statusCustomer: map['statusCustomer'] ?? '',
      telephone: map['telephone'] ?? '',
      time: map['time'] ?? 0,
      totalValue: map['totalValue'] ?? 0,
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModels.fromJson(String source) => ReportModels.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReportModels(codeSale: $codeSale, dateRecieve: $dateRecieve, delivery: $delivery, displayName: $displayName, docDate: $docDate, docNo: $docNo, docTime: $docTime, lat: $lat, lng: $lng, nameSale: $nameSale, nodelivery: $nodelivery, note: $note, status: $status, statusCustomer: $statusCustomer, telephone: $telephone, time: $time, totalValue: $totalValue, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReportModels &&
      other.codeSale == codeSale &&
      other.dateRecieve == dateRecieve &&
      other.delivery == delivery &&
      other.displayName == displayName &&
      other.docDate == docDate &&
      other.docNo == docNo &&
      other.docTime == docTime &&
      other.lat == lat &&
      other.lng == lng &&
      other.nameSale == nameSale &&
      other.nodelivery == nodelivery &&
      other.note == note &&
      other.status == status &&
      other.statusCustomer == statusCustomer &&
      other.telephone == telephone &&
      other.time == time &&
      other.totalValue == totalValue &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return codeSale.hashCode ^
      dateRecieve.hashCode ^
      delivery.hashCode ^
      displayName.hashCode ^
      docDate.hashCode ^
      docNo.hashCode ^
      docTime.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      nameSale.hashCode ^
      nodelivery.hashCode ^
      note.hashCode ^
      status.hashCode ^
      statusCustomer.hashCode ^
      telephone.hashCode ^
      time.hashCode ^
      totalValue.hashCode ^
      uid.hashCode;
  }
}
