import 'dart:convert';

class SubCatigoryModel {
  final String name;
  SubCatigoryModel({
    required this.name,
  });
  

  SubCatigoryModel copyWith({
    String? name,
  }) {
    return SubCatigoryModel(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory SubCatigoryModel.fromMap(Map<String, dynamic> map) {
    return SubCatigoryModel(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCatigoryModel.fromJson(String source) => SubCatigoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'SubCatigoryModel(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SubCatigoryModel &&
      other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
