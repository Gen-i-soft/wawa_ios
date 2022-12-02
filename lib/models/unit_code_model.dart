import 'dart:convert';

class UnitCodeModel {
  String unit_code;
  num price0;
  UnitCodeModel({
    required this.unit_code,
    required this.price0,
  });
  

  UnitCodeModel copyWith({
    String? unit_code,
    num? price0,
  }) {
    return UnitCodeModel(
      unit_code: unit_code ?? this.unit_code,
      price0: price0 ?? this.price0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unit_code': unit_code,
      'price0': price0,
    };
  }

  factory UnitCodeModel.fromMap(Map<String, dynamic> map) {
    return UnitCodeModel(
      unit_code: map['unit_code'] ?? '',
      price0: map['price0'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitCodeModel.fromJson(String source) => UnitCodeModel.fromMap(json.decode(source));

  @override
  String toString() => 'UnitCodeModel(unit_code: $unit_code, price0: $price0)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UnitCodeModel &&
      other.unit_code == unit_code &&
      other.price0 == price0;
  }

  @override
  int get hashCode => unit_code.hashCode ^ price0.hashCode;
}
