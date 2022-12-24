import 'dart:convert';

//           print('####code>>>${item['data']['code']}');
//           print('####name>>>${item['data']['name']}');
//           print('####price_level>>>${item

class SyncCustomerModel {
  final String code;
  final String name;
  final String price_level;
  SyncCustomerModel({
    required this.code,
    required this.name,
    required this.price_level,
  });

  SyncCustomerModel copyWith({
    String? code,
    String? name,
    String? price_level,
  }) {
    return SyncCustomerModel(
      code: code ?? this.code,
      name: name ?? this.name,
      price_level: price_level ?? this.price_level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'price_level': price_level,
    };
  }

  factory SyncCustomerModel.fromMap(Map<String, dynamic> map) {
    return SyncCustomerModel(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      price_level: map['price_level'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SyncCustomerModel.fromJson(String source) => SyncCustomerModel.fromMap(json.decode(source));

  @override
  String toString() => 'SyncCustomerModel(code: $code, name: $name, price_level: $price_level)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SyncCustomerModel &&
      other.code == code &&
      other.name == name &&
      other.price_level == price_level;
  }

  @override
  int get hashCode => code.hashCode ^ name.hashCode ^ price_level.hashCode;
}
