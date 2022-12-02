import 'dart:convert';

class SearchModels {
  final String code;
  final String unit;
  final num price;
  final String productname;
  final String urlImage;
  SearchModels({
    required this.code,
    required this.unit,
    required this.price,
    required this.productname,
    required this.urlImage,
  });

  SearchModels copyWith({
    String? code,
    String? unit,
    num? price,
    String? productname,
    String? urlImage,
  }) {
    return SearchModels(
      code: code ?? this.code,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      productname: productname ?? this.productname,
      urlImage: urlImage ?? this.urlImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'unit': unit,
      'price': price,
      'productname': productname,
      'urlImage': urlImage,
    };
  }

  factory SearchModels.fromMap(Map<String, dynamic> map) {
    return SearchModels(
      code: map['code'] ?? '',
      unit: map['unit'] ?? '',
      price: map['price'] ?? 0,
      productname: map['productname'] ?? '',
      urlImage: map['urlImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchModels.fromJson(String source) =>
      SearchModels.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SearchModels(code: $code, unit: $unit, price: $price, productname: $productname, urlImage: $urlImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchModels &&
        other.code == code &&
        other.unit == unit &&
        other.price == price &&
        other.productname == productname &&
        other.urlImage == urlImage;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        unit.hashCode ^
        price.hashCode ^
        productname.hashCode ^
        urlImage.hashCode;
  }
}
