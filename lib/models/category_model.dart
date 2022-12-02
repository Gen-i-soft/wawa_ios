import 'dart:convert';

class CategoryModel {
  final String name;

  final String itemcode;
  CategoryModel({
    required this.name,
    required this.itemcode,
  });
  

  CategoryModel copyWith({
    String? name,
    String? itemcode,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      itemcode: itemcode ?? this.itemcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemcode': itemcode,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      itemcode: map['itemcode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryModel(name: $name, itemcode: $itemcode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CategoryModel &&
      other.name == name &&
      other.itemcode == itemcode;
  }

  @override
  int get hashCode => name.hashCode ^ itemcode.hashCode;
}
