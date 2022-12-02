import 'dart:convert';

class ProductNullModels {
  final String code;
  final String cell;
  ProductNullModels({
    required this.code,
    required this.cell,
  });
  

  ProductNullModels copyWith({
    String? code,
    String? cell,
  }) {
    return ProductNullModels(
      code: code ?? this.code,
      cell: cell ?? this.cell,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'cell': cell,
    };
  }

  factory ProductNullModels.fromMap(Map<String, dynamic> map) {
    return ProductNullModels(
      code: map['code'] ?? '',
      cell: map['cell'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductNullModels.fromJson(String source) => ProductNullModels.fromMap(json.decode(source));

  @override
  String toString() => 'ProductNullModels(code: $code, cell: $cell)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductNullModels &&
      other.code == code &&
      other.cell == cell;
  }

  @override
  int get hashCode => code.hashCode ^ cell.hashCode;
}
