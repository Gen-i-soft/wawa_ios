import 'dart:convert';

class DocObjModel {
  final String name;
  final String url;
  final String id;
  final bool isHoldPurchase;
  final bool inCart;
  final String qtyInCart;
  DocObjModel({
    required this.name,
    required this.url,
    required this.id,
    required this.isHoldPurchase,
    required this.inCart,
    required this.qtyInCart,
  });

  DocObjModel copyWith({
    String? name,
    String? url,
    String? id,
    bool? isHoldPurchase,
    bool? inCart,
    String? qtyInCart,
  }) {
    return DocObjModel(
      name: name ?? this.name,
      url: url ?? this.url,
      id: id ?? this.id,
      isHoldPurchase: isHoldPurchase ?? this.isHoldPurchase,
      inCart: inCart ?? this.inCart,
      qtyInCart: qtyInCart ?? this.qtyInCart,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'id': id,
      'isHoldPurchase': isHoldPurchase,
      'inCart': inCart,
      'qtyInCart': qtyInCart,
    };
  }

  factory DocObjModel.fromMap(Map<String, dynamic> map) {
    return DocObjModel(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      id: map['id'] ?? '',
      isHoldPurchase: map['isHoldPurchase'] ?? false,
      inCart: map['inCart'] ?? false,
      qtyInCart: map['qtyInCart'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocObjModel.fromJson(String source) => DocObjModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DocObjModel(name: $name, url: $url, id: $id, isHoldPurchase: $isHoldPurchase, inCart: $inCart, qtyInCart: $qtyInCart)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DocObjModel &&
        other.name == name &&
        other.url == url &&
        other.id == id &&
        other.isHoldPurchase == isHoldPurchase &&
        other.inCart == inCart &&
        other.qtyInCart == qtyInCart;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    url.hashCode ^
    id.hashCode ^
    isHoldPurchase.hashCode ^
    inCart.hashCode ^
    qtyInCart.hashCode;
  }
}
