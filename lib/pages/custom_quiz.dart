import 'package:flutter/material.dart';
import 'package:quiz_app/app.dart';
import 'package:quiz_app/helpers/classes.dart';
import 'package:quiz_app/helpers/functions.dart';
import 'package:provider/provider.dart';

const quizCategories = [
  {"value": 9, "label": "General Knowledge"},
  {"value": 10, "label": "Books"},
  {"value": 11, "label": "Film"},
  {"value": 12, "label": "Music"},
  {"value": 13, "label": "Musicals & Theatres"},
  {"value": 14, "label": "Television"},
  {"value": 15, "label": "Video Games"},
  {"value": 16, "label": "Board Games"},
  {"value": 17, "label": "Science & Nature"},
  {"value": 18, "label": "Computers"},
  {"value": 19, "label": "Mathematics"},
  {"value": 20, "label": "Mythology"},
  {"value": 21, "label": "Sports"},
  {"value": 22, "label": "Geography"},
  {"value": 23, "label": "History"},
  {"value": 24, "label": "Politics"},
  {"value": 25, "label": "Art"},
  {"value": 26, "label": "Celebrities"},
  {"value": 27, "label": "Animals"},
  {"value": 28, "label": "Vehicles"},
  {"value": 29, "label": "Comics"},
  {"value": 30, "label": "Gadgets"},
  {"value": 31, "label": "Anime & Manga"},
  {"value": 32, "label": "Cartoon"}
];

const quizDifficulties = ['easy', 'medium', 'hard'];

const quizAmount = 5;

class Customize extends StatefulWidget {
  const Customize({super.key});

  @override
  State<Customize> createState() => _CustomizeState();
}

class _CustomizeState extends State<Customize> {
  int screenNumber = 1;
  Map<String, dynamic> customQuizData = {
    'cat': 21,
    'cat-label': 'Sports',
    'diff': 'easy',
    'amount': 5
  };

  void switchScreen(Map<String, dynamic> selection) {
    replaceIfSame(customQuizData, selection);

    if (screenNumber < 3) {
      setState(() {
        screenNumber++;
      });
    }
  }

  Widget getScreen() {
    switch (screenNumber) {
      case 1:
        return SelectCategory(onScreenChange: switchScreen);
      case 2:
        return SelectDiff(onScreenChange: switchScreen);
      case 3:
        return SelectAmount(
          onScreenChange: switchScreen,
          selectionData: customQuizData,
        );
      default:
        return SelectCategory(onScreenChange: switchScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getScreen();
  }
}

class SelectCategory extends StatelessWidget {
  final void Function(Map<String, dynamic>) onScreenChange;
  const SelectCategory({super.key, required this.onScreenChange});

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.0085,
        squeeze: 0.95,
        children: [
          ...quizCategories.map((cat) => SizedBox(
                width: 175,
                child: ElevatedButton(
                    onPressed: () {
                      onScreenChange(
                          {'cat': cat['value'], 'cat-label': cat['label']});
                    },
                    child: Text(cat['label'].toString())),
              ))
        ]);
  }
}

class SelectDiff extends StatelessWidget {
  final void Function(Map<String, dynamic>) onScreenChange;
  const SelectDiff({super.key, required this.onScreenChange});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(30),
        itemBuilder: (context, index) => ElevatedButton(
            onPressed: () {
              onScreenChange({'diff': quizDifficulties[index]});
            },
            child: Text(quizDifficulties[index])),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 2),
        itemCount: quizDifficulties.length);
  }
}

class SelectAmount extends StatefulWidget {
  final void Function(Map<String, dynamic>) onScreenChange;
  final Map<String, dynamic> selectionData;
  const SelectAmount(
      {super.key, required this.onScreenChange, required this.selectionData});

  @override
  State<SelectAmount> createState() => _SelectAmountState();
}

class _SelectAmountState extends State<SelectAmount> {
  int amount = 5;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Quiz questions'),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (amount > 5) {
                          amount--;
                        }
                      });
                    },
                    icon: const Icon(Icons.exposure_minus_1)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    amount.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (amount < 45) {
                          amount++;
                        }
                      });
                    },
                    icon: const Icon(Icons.plus_one)),
              ],
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final newCustomQuiz = QuizData(
                category: widget.selectionData['cat'],
                categoryName: widget.selectionData['cat-label'],
                difficulty: widget.selectionData['diff'],
                amount: amount);

            appState.createCustomQuiz(newCustomQuiz);
          },
          label: const Text('Done'),
          icon: const Icon(Icons.done),
        )
      ],
    );
  }
}
