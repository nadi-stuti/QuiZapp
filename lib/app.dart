import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/helpers/classes.dart';

import 'pages/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return MaterialApp(
      title: 'QuiZapp',
      theme: ThemeData(
          fontFamily: GoogleFonts.afacad().fontFamily,
          brightness: Brightness.light,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.afacad().fontFamily,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
      ),
      themeMode: appState.theme,
      home: const MyHomePage(),
    );
  }
}

enum Screen { menu, quiz, custom, result, favorite }

class MyAppState extends ChangeNotifier {
  var theme = ThemeMode.dark;
  QuizData customQuiz =
      QuizData(category: 0, categoryName: '', difficulty: '', amount: 5);

  QuizResult quizResult =
      QuizResult(userAnswers: [], totalQuestions: 0, userScore: 0);

  Screen currentScreen = Screen.menu;

  void createCustomQuiz(QuizData selection) {
    currentScreen = Screen.quiz;
    customQuiz = selection;
    notifyListeners();
  }

  void onQuizAnswer(QuizModel quiz, String answer) {
    bool correct = quiz.correctAnswer == answer;

    quizResult.userAnswers.add(UserAnswer(
        question: quiz.question,
        answer: answer,
        correctAnswer: quiz.correctAnswer));

    if (correct) {
      quizResult.userScore++;
    }

    quizResult.totalQuestions++;
  }

  void changeScreen(Screen newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }

  void resetToHome() {
    customQuiz =
        QuizData(category: 0, categoryName: '', difficulty: '', amount: 5);
    quizResult = QuizResult(userAnswers: [], totalQuestions: 0, userScore: 0);

    currentScreen = Screen.menu;

    notifyListeners();
  }

  void toggleTheme() {
    theme = theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
