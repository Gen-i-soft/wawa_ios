import 'dart:convert';

class BarcodeModel {
  final num price0;
  final num price1;
  final num price2;
  final num price3;
  final num price4;
  final num price5;
  final num price6;
  final num price7;
  final num price8;
  final num price9;
  final String unit_code;
  BarcodeModel({
    required this.price0,
    required this.price1,
    required this.price2,
    required this.price3,
    required this.price4,
    required this.price5,
    required this.price6,
    required this.price7,
    required this.price8,
    required this.price9,
    required this.unit_code,
  });


  BarcodeModel copyWith({
    num? price0,
    num? price1,
    num? price2,
    num? price3,
    num? price4,
    num? price5,
    num? price6,
    num? price7,
    num? price8,
    num? price9,
    String? unit_code,
  }) {
    return BarcodeModel(
      price0: price0 ?? this.price0,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      price3: price3 ?? this.price3,
      price4: price4 ?? this.price4,
      price5: price5 ?? this.price5,
      price6: price6 ?? this.price6,
      price7: price7 ?? this.price7,
      price8: price8 ?? this.price8,
      price9: price9 ?? this.price9,
      unit_code: unit_code ?? this.unit_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price0': price0,
      'price1': price1,
      'price2': price2,
      'price3': price3,
      'price4': price4,
      'price5': price5,
      'price6': price6,
      'price7': price7,
      'price8': price8,
      'price9': price9,
      'unit_code': unit_code,
    };
  }

  factory BarcodeModel.fromMap(Map<String, dynamic> map) {
    return BarcodeModel(
      price0: map['price0'] ?? 0,
      price1: map['price1'] ?? 0,
      price2: map['price2'] ?? 0,
      price3: map['price3'] ?? 0,
      price4: map['price4'] ?? 0,
      price5: map['price5'] ?? 0,
      price6: map['price6'] ?? 0,
      price7: map['price7'] ?? 0,
      price8: map['price8'] ?? 0,
      price9: map['price9'] ?? 0,
      unit_code: map['unit_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeModel.fromJson(String source) => BarcodeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BarcodeModel(price0: $price0, price1: $price1, price2: $price2, price3: $price3, price4: $price4, price5: $price5, price6: $price6, price7: $price7, price8: $price8, price9: $price9, unit_code: $unit_code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BarcodeModel &&
        other.price0 == price0 &&
        other.price1 == price1 &&
        other.price2 == price2 &&
        other.price3 == price3 &&
        other.price4 == price4 &&
        other.price5 == price5 &&
        other.price6 == price6 &&
        other.price7 == price7 &&
        other.price8 == price8 &&
        other.price9 == price9 &&
        other.unit_code == unit_code;
  }

  @override
  int get hashCode {
    return price0.hashCode ^
    price1.hashCode ^
    price2.hashCode ^
    price3.hashCode ^
    price4.hashCode ^
    price5.hashCode ^
    price6.hashCode ^
    price7.hashCode ^
    price8.hashCode ^
    price9.hashCode ^
    unit_code.hashCode;
  }
}
