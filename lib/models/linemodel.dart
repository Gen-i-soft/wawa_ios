// import 'dart:convert';

// class LineLoginModel {
//   final String displayname;
//   final String lineid;
//   final String picturl;
//   final String uid;
//   LineLoginModel({
//     this.displayname,
//     this.lineid,
//     this.picturl,
//     this.uid,
//   });

//   LineLoginModel copyWith({
//     String displayname,
//     String lineid,
//     String picturl,
//     String uid,
//   }) {
//     return LineLoginModel(
//       displayname: displayname ?? this.displayname,
//       lineid: lineid ?? this.lineid,
//       picturl: picturl ?? this.picturl,
//       uid: uid ?? this.uid,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'displayname': displayname,
//       'lineid': lineid,
//       'picturl': picturl,
//       'uid': uid,
//     };
//   }

//   factory LineLoginModel.fromMap(Map<String, dynamic> map) {
//     return LineLoginModel(
//       displayname: map['displayname'],
//       lineid: map['lineid'],
//       picturl: map['picturl'],
//       uid: map['uid'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory LineLoginModel.fromJson(String source) => LineLoginModel.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'LineLoginModel(displayname: $displayname, lineid: $lineid, picturl: $picturl, uid: $uid)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
  
//     return other is LineLoginModel &&
//       other.displayname == displayname &&
//       other.lineid == lineid &&
//       other.picturl == picturl &&
//       other.uid == uid;
//   }

//   @override
//   int get hashCode {
//     return displayname.hashCode ^
//       lineid.hashCode ^
//       picturl.hashCode ^
//       uid.hashCode;
//   }
// }
