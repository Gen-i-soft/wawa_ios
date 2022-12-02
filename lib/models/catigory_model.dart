import 'dart:convert';

class CatigoryModel {
  final String name;
  final String detail;
  CatigoryModel({
    required this.name,
    required this.detail,
  });
  

  CatigoryModel copyWith({
    String? name,
    String? detail,
  }) {
    return CatigoryModel(
      name: name ?? this.name,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
    };
  }

  factory CatigoryModel.fromMap(Map<String, dynamic> map) {
    return CatigoryModel(
      name: map['name'] ?? '',
      detail: map['detail'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CatigoryModel.fromJson(String source) => CatigoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CatigoryModel(name: $name, detail: $detail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CatigoryModel &&
      other.name == name &&
      other.detail == detail;
  }

  @override
  int get hashCode => name.hashCode ^ detail.hashCode;
}
