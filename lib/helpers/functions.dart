import 'dart:convert';

import 'package:quiz_app/helpers/classes.dart';
import 'package:http/http.dart' as http;

replaceIfSame(Map a, Map b) {
  for (var k in b.keys) {
    if (a.containsKey(k)) {
      if (a[k] is Map && b[k] is Map) {
        replaceIfSame(a[k], b[k]);
      } else {
        a[k] = b[k];
      }
    }
  }
}

convertQuizToURL(QuizData customQuiz) {
  return 'https://opentdb.com/api.php?amount=${customQuiz.amount}&category=${customQuiz.category}&difficulty=${customQuiz.difficulty}';
}

Future<List<QuizModel>> fetchQuiz(String quizUrl) async {
  List<QuizModel> quizes = [];

  final response = await http.get(Uri.parse(quizUrl));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> res = jsonDecode(response.body)['results'];

    for (var quiz in res) {
      quizes.add(QuizModel.fromJson(quiz));
    }

    return quizes;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load quizes');
  }
}
