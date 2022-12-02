// import 'dart:convert';

// class LineModels {
//   final String displayName;
//   final String pictureUrl;
//   final String userId;
//   LineModels({
//      this.displayName,
//     this.pictureUrl,
//      this.userId,
//   });

//   LineModels copyWith({
//     String displayName,
//     String pictureUrl,
//     String userId,
//   }) {
//     return LineModels(
//       displayName: displayName ?? this.displayName,
//       pictureUrl: pictureUrl ?? this.pictureUrl,
//       userId: userId ?? this.userId,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'displayName': displayName,
//       'pictureUrl': pictureUrl,
//       'userId': userId,
//     };
//   }

//   factory LineModels.fromMap(Map<String, dynamic> map) {
//     return LineModels(
//       displayName: map['displayName'],
//       pictureUrl: map['pictureUrl'],
//       userId: map['userId'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory LineModels.fromJson(String source) => LineModels.fromMap(json.decode(source));

//   @override
//   String toString() => 'LineModels(displayName: $displayName, pictureUrl: $pictureUrl, userId: $userId)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
  
//     return other is LineModels &&
//       other.displayName == displayName &&
//       other.pictureUrl == pictureUrl &&
//       other.userId == userId;
//   }

//   @override
//   int get hashCode => displayName.hashCode ^ pictureUrl.hashCode ^ userId.hashCode;
// }
