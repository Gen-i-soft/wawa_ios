import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductModel {
  String code;
  String name;
  ProductModel({
    required this.code,
    required this.name,
  });
  

  ProductModel copyWith({
    String? code,
    String? name,
  }) {
    return ProductModel(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductModel(code: $code, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductModel &&
      other.code == code &&
      other.name == name;
  }

  @override
  int get hashCode => code.hashCode ^ name.hashCode;
}
