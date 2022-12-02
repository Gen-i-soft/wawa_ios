import 'dart:convert';

class ProductCloudModel {
  final String name;
  final String urlImage;
  final String id;
  ProductCloudModel({
    required this.name,
    required this.urlImage,
    required this.id,
  });
 

  ProductCloudModel copyWith({
    String? name,
    String? urlImage,
    String? id,
  }) {
    return ProductCloudModel(
      name: name ?? this.name,
      urlImage: urlImage ?? this.urlImage,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'urlImage': urlImage,
      'id': id,
    };
  }

  factory ProductCloudModel.fromMap(Map<String, dynamic> map) {
    return ProductCloudModel(
      name: map['name'] ?? '',
      urlImage: map['urlImage'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCloudModel.fromJson(String source) => ProductCloudModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductCloudModel(name: $name, urlImage: $urlImage, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductCloudModel &&
      other.name == name &&
      other.urlImage == urlImage &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ urlImage.hashCode ^ id.hashCode;
}
