import 'dart:convert';

class BarcodeModel {
  final num price0;
  final String unit_code;
  BarcodeModel({
    required this.price0,
    required this.unit_code,
  });
  

  BarcodeModel copyWith({
    num? price0,
    String? unit_code,
  }) {
    return BarcodeModel(
      price0: price0 ?? this.price0,
      unit_code: unit_code ?? this.unit_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price0': price0,
      'unit_code': unit_code,
    };
  }

  factory BarcodeModel.fromMap(Map<String, dynamic> map) {
    return BarcodeModel(
      price0: map['price0'] ?? 0,
      unit_code: map['unit_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeModel.fromJson(String source) => BarcodeModel.fromMap(json.decode(source));

  @override
  String toString() => 'BarcodeModel(price0: $price0, unit_code: $unit_code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BarcodeModel &&
      other.price0 == price0 &&
      other.unit_code == unit_code;
  }

  @override
  int get hashCode => price0.hashCode ^ unit_code.hashCode;
}
