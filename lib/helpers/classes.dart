import 'package:html/parser.dart';

class QuizData {
  final int category;
  final String categoryName;
  final String difficulty;
  final int amount;

  QuizData(
      {required this.category,
      required this.categoryName,
      required this.difficulty,
      required this.amount});
}

class QuizModel {
  String type;
  String difficulty;
  String category;
  String question;
  String correctAnswer;
  List<dynamic> incorrectAnswers;

  QuizModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        type: json["type"],
        difficulty: json["difficulty"],
        category: json["category"],
        question: parse(json["question"]).documentElement?.text ??
            'Question Fetch Error',
        correctAnswer: parse(json["correct_answer"]).documentElement?.text ??
            'Answer Fetch Error',
        incorrectAnswers: List<dynamic>.from(json["incorrect_answers"].map((x) {
          return parse(x).documentElement?.text ?? 'Answer fetch Error';
        })),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "difficulty": difficulty,
        "category": category,
        "question": question,
        "correct_answer": correctAnswer,
        "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
      };
}

class UserAnswer {
  final String question;
  final String answer;
  final String correctAnswer;

  UserAnswer(
      {required this.question,
      required this.answer,
      required this.correctAnswer});
}

class QuizResult {
  List<UserAnswer> userAnswers;
  int totalQuestions;
  int userScore;

  QuizResult(
      {required this.userAnswers,
      required this.totalQuestions,
      required this.userScore});
}
