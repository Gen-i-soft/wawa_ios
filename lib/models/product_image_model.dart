import 'dart:convert';

class ProductImageModel {
  String urlImage;
  String name;
  String id;
  ProductImageModel({
    required this.urlImage,
    required this.name,
    required this.id,
  });
  

  ProductImageModel copyWith({
    String? urlImage,
    String? name,
    String? id,
  }) {
    return ProductImageModel(
      urlImage: urlImage ?? this.urlImage,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urlImage': urlImage,
      'name': name,
      'id': id,
    };
  }

  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      urlImage: map['urlImage'] ?? '',
      name: map['name'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductImageModel.fromJson(String source) => ProductImageModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductImageModel(urlImage: $urlImage, name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductImageModel &&
      other.urlImage == urlImage &&
      other.name == name &&
      other.id == id;
  }

  @override
  int get hashCode => urlImage.hashCode ^ name.hashCode ^ id.hashCode;
}
