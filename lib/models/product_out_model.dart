import 'dart:convert';

class ProductOutModel {
  String urlImage;
  String name;
  String categoryName;
  ProductOutModel({
    required this.urlImage,
    required this.name,
    required this.categoryName,
  });
  

  ProductOutModel copyWith({
    String? urlImage,
    String? name,
    String? categoryName,
  }) {
    return ProductOutModel(
      urlImage: urlImage ?? this.urlImage,
      name: name ?? this.name,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urlImage': urlImage,
      'name': name,
      'categoryName': categoryName,
    };
  }

  factory ProductOutModel.fromMap(Map<String, dynamic> map) {
    return ProductOutModel(
      urlImage: map['urlImage'] ?? '',
      name: map['name'] ?? '',
      categoryName: map['categoryName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOutModel.fromJson(String source) => ProductOutModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductOutModel(urlImage: $urlImage, name: $name, categoryName: $categoryName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductOutModel &&
      other.urlImage == urlImage &&
      other.name == name &&
      other.categoryName == categoryName;
  }

  @override
  int get hashCode => urlImage.hashCode ^ name.hashCode ^ categoryName.hashCode;
}
