import 'dart:convert';

class PurchaseModels {
  final int amounts;
  final String bacode;
  final String code;
  final String dateTimeStr;
  final String docNo;
  final String name;
  final String picturl;
  final String price;
  final String subtotal;
  final num total;
  final String unit;
  final String uid;
  final int time;
  PurchaseModels({
    required this.amounts,
    required this.bacode,
    required this.code,
    required this.dateTimeStr,
    required this.docNo,
    required this.name,
    required this.picturl,
    required this.price,
    required this.subtotal,
    required this.total,
    required this.unit,
    required this.uid,
    required this.time,
  });
  

  PurchaseModels copyWith({
    int? amounts,
    String? bacode,
    String? code,
    String? dateTimeStr,
    String? docNo,
    String? name,
    String? picturl,
    String? price,
    String? subtotal,
    num? total,
    String? unit,
    String? uid,
    int? time,
  }) {
    return PurchaseModels(
      amounts: amounts ?? this.amounts,
      bacode: bacode ?? this.bacode,
      code: code ?? this.code,
      dateTimeStr: dateTimeStr ?? this.dateTimeStr,
      docNo: docNo ?? this.docNo,
      name: name ?? this.name,
      picturl: picturl ?? this.picturl,
      price: price ?? this.price,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      unit: unit ?? this.unit,
      uid: uid ?? this.uid,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amounts': amounts,
      'bacode': bacode,
      'code': code,
      'dateTimeStr': dateTimeStr,
      'docNo': docNo,
      'name': name,
      'picturl': picturl,
      'price': price,
      'subtotal': subtotal,
      'total': total,
      'unit': unit,
      'uid': uid,
      'time': time,
    };
  }
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }
  int _index = 0;
  String getIndex(int index) {

    switch (index) {
      case 0:
        return '';

      case 1:
        return name; //_formatCurrency(price);

      case 2:
        return picturl;

      case 3:
        return amounts.toString();
      case 4:
        return unit;
      case 5:
        return price;
          //_formatCurrency(double.parse(price));
      case 6:
        return subtotal;
          //_formatCurrency(double.parse(subtotal));
    }
    return '';
  }

  factory PurchaseModels.fromMap(Map<String, dynamic> map) {
    return PurchaseModels(
      amounts: map['amounts']?.toInt() ?? 0,
      bacode: map['bacode'] ?? '',
      code: map['code'] ?? '',
      dateTimeStr: map['dateTimeStr'] ?? '',
      docNo: map['docNo'] ?? '',
      name: map['name'] ?? '',
      picturl: map['picturl'] ?? '',
      price: map['price'] ?? '',
      subtotal: map['subtotal'] ?? '',
      total: map['total'] ?? 0,
      unit: map['unit'] ?? '',
      uid: map['uid'] ?? '',
      time: map['time']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseModels.fromJson(String source) => PurchaseModels.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PurchaseModels(amounts: $amounts, bacode: $bacode, code: $code, dateTimeStr: $dateTimeStr, docNo: $docNo, name: $name, picturl: $picturl, price: $price, subtotal: $subtotal, total: $total, unit: $unit, uid: $uid, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PurchaseModels &&
      other.amounts == amounts &&
      other.bacode == bacode &&
      other.code == code &&
      other.dateTimeStr == dateTimeStr &&
      other.docNo == docNo &&
      other.name == name &&
      other.picturl == picturl &&
      other.price == price &&
      other.subtotal == subtotal &&
      other.total == total &&
      other.unit == unit &&
      other.uid == uid &&
      other.time == time;
  }

  @override
  int get hashCode {
    return amounts.hashCode ^
      bacode.hashCode ^
      code.hashCode ^
      dateTimeStr.hashCode ^
      docNo.hashCode ^
      name.hashCode ^
      picturl.hashCode ^
      price.hashCode ^
      subtotal.hashCode ^
      total.hashCode ^
      unit.hashCode ^
      uid.hashCode ^
      time.hashCode;
  }
}
