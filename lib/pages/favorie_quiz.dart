import 'package:flutter/material.dart';
import 'package:quiz_app/app.dart';
import 'package:quiz_app/helpers/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class FavoriteQuiz extends StatefulWidget {
  const FavoriteQuiz({super.key});

  @override
  State<FavoriteQuiz> createState() => _FavoriteQuizState();
}

class _FavoriteQuizState extends State<FavoriteQuiz> {
  List<String> savedFavs = [];

  @override
  void initState() {
    super.initState();
    _loadSavedFavs();
  }

  Future<void> _loadSavedFavs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedFavs = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView.separated(
        padding: const EdgeInsets.all(25),
        itemBuilder: (context, index) => ElevatedButton(
            onPressed: () {
              final fav = savedFavs[index];
              final data = fav.split("-");
              QuizData qD = QuizData(
                  category: int.parse(data[0]),
                  categoryName: data[1],
                  difficulty: data[2],
                  amount: int.parse(data[3]));
              appState.createCustomQuiz(qD);
            },
            child: Text(
              savedFavs[index],
              textAlign: TextAlign.center,
            )),
        separatorBuilder: (context, index) => const SizedBox(height: 5),
        itemCount: savedFavs.length);
  }
}
