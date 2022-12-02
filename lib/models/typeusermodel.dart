import 'dart:convert';

class TypeUserModel {
  final String typeUser;
  TypeUserModel({
    required this.typeUser,
  });
  

  TypeUserModel copyWith({
    String? typeUser,
  }) {
    return TypeUserModel(
      typeUser: typeUser ?? this.typeUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeUser': typeUser,
    };
  }

  factory TypeUserModel.fromMap(Map<String, dynamic> map) {
    return TypeUserModel(
      typeUser: map['typeUser'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeUserModel.fromJson(String source) => TypeUserModel.fromMap(json.decode(source));

  @override
  String toString() => 'TypeUserModel(typeUser: $typeUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TypeUserModel &&
      other.typeUser == typeUser;
  }

  @override
  int get hashCode => typeUser.hashCode;
}
