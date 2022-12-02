import 'dart:convert';

class SQLiteModel {
  // final int? id;
  final String code;
  final String name;
  // final String? barcodes;
  final String prices;
  final String units;
  final int amounts;
  final String subtotals;
  final String picturl;
  final String uid;
  SQLiteModel({
      // this.id,
     required this.code,
     required this.name,
      // this.barcodes,
     required this.prices,
     required this.units,
     required this.amounts,
    required this.subtotals,
     required this.picturl,
    required this.uid
  });
 

  SQLiteModel copyWith({
    // int? id,
    String? code,
    String? name,
    // String? barcodes,
    String? prices,
    String? units,
    int? amounts,
    String? subtotals,
    String? picturl,
    String? uid,
  }) {
    return SQLiteModel(
      // id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      // barcodes: barcodes ?? this.barcodes,
      prices: prices ?? this.prices,
      units: units ?? this.units,
      amounts: amounts ?? this.amounts,
      subtotals: subtotals ?? this.subtotals,
      picturl: picturl ?? this.picturl,
      uid: uid ?? this.uid,
    );
  }


  Map<String, dynamic> toJsonzz() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_code'] = this.code;
    data['line_number'] = 0;
    data['is_permium'] = 0;
    data['unit_code'] = this.units;
    data['wh_code'] = 'CMI01';
    data['shelf_code'] = 'CMI420';
    data['qty'] = this.amounts;
    data['price'] = this.prices;
    data['price_exclude_vat'] = double.parse(this.prices)/1.07 ;
    data['discount_amount'] = 0 ;
    data['sum_amount'] = this.subtotals;
    data['vat_amount'] = double.parse(this.prices)-double.parse(this.prices)/1.07 ;
    data['tax_type'] = 0;
    data['vat_type'] = 1;
    data['sum_amount_exclude_vat'] = double.parse(this.prices)/1.07 ;
    // data['promotion_code'] = null;


    data['name'] = this.name;
    // data['barcode'] = this.ba;//***









    return data;
  }


  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'code': code,
      'name': name,
      // 'barcodes': barcodes,
      'prices': prices,
      'units': units,
      'amounts': amounts,
      'subtotals': subtotals,
      'picturl': picturl,
      'uid': uid,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      // id: map['id'],
      code: map['code'],
      name: map['name'],
      // barcodes: map['barcodes'],
      prices: map['prices'],
      units: map['units'],
      amounts: map['amounts'],
      subtotals: map['subtotals'],
      picturl: map['picturl'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SQLiteModel( code: $code, name: $name,  prices: $prices, units: $units, amounts: $amounts, subtotals: $subtotals, picturl: $picturl , uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SQLiteModel &&

      other.code == code &&
      other.name == name &&

      other.prices == prices &&
      other.units == units &&
      other.amounts == amounts &&
      other.subtotals == subtotals &&
      other.picturl == picturl &&
    other.uid == uid;
  }

  @override
  int get hashCode {
    return
      code.hashCode ^
      name.hashCode ^

      prices.hashCode ^
      units.hashCode ^
      amounts.hashCode ^
      subtotals.hashCode ^
      picturl.hashCode ^
    uid.hashCode;
  }
}
