import 'dart:convert';

class ProductTwoModel {
  String name;
  String urlImage;
  String itemCategory;
  String categoryName;
  bool isBest;
  bool isOn;
  bool isPromotion;
  ProductTwoModel({
    required this.name,
    required this.urlImage,
    required this.itemCategory,
    required this.categoryName,
    required this.isBest,
    required this.isOn,
    required this.isPromotion,
  });
 

  ProductTwoModel copyWith({
    String? name,
    String? urlImage,
    String? itemCategory,
    String? categoryName,
    bool? isBest,
    bool? isOn,
    bool? isPromotion,
  }) {
    return ProductTwoModel(
      name: name ?? this.name,
      urlImage: urlImage ?? this.urlImage,
      itemCategory: itemCategory ?? this.itemCategory,
      categoryName: categoryName ?? this.categoryName,
      isBest: isBest ?? this.isBest,
      isOn: isOn ?? this.isOn,
      isPromotion: isPromotion ?? this.isPromotion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'urlImage': urlImage,
      'itemCategory': itemCategory,
      'categoryName': categoryName,
      'isBest': isBest,
      'isOn': isOn,
      'isPromotion': isPromotion,
    };
  }

  factory ProductTwoModel.fromMap(Map<String, dynamic> map) {
    return ProductTwoModel(
      name: map['name'] ?? '',
      urlImage: map['urlImage'] ?? '',
      itemCategory: map['itemCategory'] ?? '',
      categoryName: map['categoryName'] ?? '',
      isBest: map['isBest'] ?? false,
      isOn: map['isOn'] ?? false,
      isPromotion: map['isPromotion'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductTwoModel.fromJson(String source) => ProductTwoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductTwoModel(name: $name, urlImage: $urlImage, itemCategory: $itemCategory, categoryName: $categoryName, isBest: $isBest, isOn: $isOn, isPromotion: $isPromotion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductTwoModel &&
      other.name == name &&
      other.urlImage == urlImage &&
      other.itemCategory == itemCategory &&
      other.categoryName == categoryName &&
      other.isBest == isBest &&
      other.isOn == isOn &&
      other.isPromotion == isPromotion;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      urlImage.hashCode ^
      itemCategory.hashCode ^
      categoryName.hashCode ^
      isBest.hashCode ^
      isOn.hashCode ^
      isPromotion.hashCode;
  }
}
