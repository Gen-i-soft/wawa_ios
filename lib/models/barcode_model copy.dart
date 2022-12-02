import 'dart:convert';

class BarcodeModel {
  final String barcode;
  final num price;
  final String unit_code;
  BarcodeModel({
    required this.barcode,
    required this.price,
    required this.unit_code,
  });
  

  BarcodeModel copyWith({
    String? barcode,
    num? price,
    String? unit_code,
  }) {
    return BarcodeModel(
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      unit_code: unit_code ?? this.unit_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'price': price,
      'unit_code': unit_code,
    };
  }

  factory BarcodeModel.fromMap(Map<String, dynamic> map) {
    return BarcodeModel(
      barcode: map['barcode'] ?? '',
      price: map['price'] ?? 0,
      unit_code: map['unit_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeModel.fromJson(String source) => BarcodeModel.fromMap(json.decode(source));

  @override
  String toString() => 'BarcodeModel(barcode: $barcode, price: $price, unit_code: $unit_code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BarcodeModel &&
      other.barcode == barcode &&
      other.price == price &&
      other.unit_code == unit_code;
  }

  @override
  int get hashCode => barcode.hashCode ^ price.hashCode ^ unit_code.hashCode;
}
