import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/app.dart';
import 'package:quiz_app/helpers/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final quizData = appState.customQuiz;
    final res = appState.quizResult;
    final quizName =
        '${quizData.category}-${quizData.categoryName}-${quizData.difficulty}-${quizData.amount}';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(
            'Score: ${res.userScore}/${res.userAnswers.length} ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          if (quizData.category != 0)
            Text(
              quizName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    appState.quizResult = QuizResult(
                        userAnswers: [], totalQuestions: 0, userScore: 0);
                    appState.changeScreen(Screen.quiz);
                  },
                  icon: const Icon(Icons.restart_alt)),
              IconButton(
                  onPressed: appState.resetToHome,
                  icon: const Icon(Icons.home)),
              if (quizData.category != 0) FavoriteButton(quizName: quizName)
            ],
          ),
          ...res.userAnswers.map((ans) => ResultCard(userAnswer: ans))
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final UserAnswer userAnswer;
  const ResultCard({super.key, required this.userAnswer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userAnswer.question,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              userAnswer.correctAnswer,
              style: const TextStyle(color: Colors.green),
              textAlign: TextAlign.center,
            ),
            Text(
              userAnswer.answer,
              style: const TextStyle(color: Colors.blueGrey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.quizName});
  final String quizName;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadSavedFavs();
  }

  Future<void> _loadSavedFavs() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favList.contains(widget.quizName);
    });
  }

  Future<void> _toggleFav() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];

    if (!favList.contains(widget.quizName)) {
      favList.add(widget.quizName);
    } else {
      favList.remove(widget.quizName);
    }

    prefs.setStringList('favorites', favList);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: _toggleFav,
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border));
  }
}
