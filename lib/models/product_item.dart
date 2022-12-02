import 'dart:convert';

class ProductItemModel {
  String productId;
  ProductItemModel({
    required this.productId,
  });
  

  ProductItemModel copyWith({
    String? productId,
  }) {
    return ProductItemModel(
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
    };
  }

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      productId: map['productId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductItemModel.fromJson(String source) => ProductItemModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductItemModel(productId: $productId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductItemModel &&
      other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}
