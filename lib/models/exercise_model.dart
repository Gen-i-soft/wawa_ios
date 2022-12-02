// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// class ExerciseModel {
//   final int answer;
//   final List<String> choice;
//   final int item;
//   final String question;
//   ExerciseModel({
//      this.answer,
//     this.choice,
//     this.item,
//      this.question,
//   });

//   ExerciseModel copyWith({
//     int answer,
//     List<String> choice,
//     int item,
//     String question,
//   }) {
//     return ExerciseModel(
//       answer: answer ?? this.answer,
//       choice: choice ?? this.choice,
//       item: item ?? this.item,
//       question: question ?? this.question,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'answer': answer,
//       'choice': choice,
//       'item': item,
//       'question': question,
//     };
//   }

//   factory ExerciseModel.fromMap(Map<String, dynamic> map) {
//     return ExerciseModel(
//       answer: map['answer'],
//       choice: List<String>.from(map['choice']),
//       item: map['item'],
//       question: map['question'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ExerciseModel.fromJson(String source) => ExerciseModel.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'ExerciseModel(answer: $answer, choice: $choice, item: $item, question: $question)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
  
//     return other is ExerciseModel &&
//       other.answer == answer &&
//       listEquals(other.choice, choice) &&
//       other.item == item &&
//       other.question == question;
//   }

//   @override
//   int get hashCode {
//     return answer.hashCode ^
//       choice.hashCode ^
//       item.hashCode ^
//       question.hashCode;
//   }
// }
