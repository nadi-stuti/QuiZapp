import 'package:flutter/material.dart';
import 'package:quiz_app/Components/dialog.dart';
import 'package:quiz_app/app.dart';
import 'package:quiz_app/helpers/classes.dart';
import 'package:quiz_app/helpers/functions.dart';
import 'package:provider/provider.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final quizUrl = convertQuizToURL(appState.customQuiz);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchQuiz(quizUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return QuizRounds(
                quizList: snapshot.data!,
                onQuizComplete: () => appState.changeScreen(Screen.result),
              );
            } else if (snapshot.hasError) {
              return Text('error: ${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class QuizRounds extends StatefulWidget {
  final List<QuizModel> quizList;
  final void Function() onQuizComplete;

  const QuizRounds(
      {super.key, required this.quizList, required this.onQuizComplete});

  @override
  State<QuizRounds> createState() => _QuizRoundsState();
}

class _QuizRoundsState extends State<QuizRounds> {
  int round = 0;

  void nextQuestion() {
    if (round < widget.quizList.length - 1) {
      setState(() {
        round++;
      });
    } else {
      widget.onQuizComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Question(quiz: widget.quizList[round], onAnswer: nextQuestion);
  }
}

class Question extends StatelessWidget {
  final QuizModel quiz;
  final void Function() onAnswer;
  const Question({super.key, required this.quiz, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    ScrollController scrollController = ScrollController();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      controller: scrollController,
      child: Column(
        children: [
          Text(
            quiz.question,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Answers(
            quiz: quiz,
            onAnswerSelect: (answer) {
              dialogBuilder(context, quiz, answer, onAnswer);
              appState.onQuizAnswer(quiz, answer);
              scrollController.jumpTo(0.0);
            },
          )
        ],
      ),
    );
  }
}

class Answers extends StatelessWidget {
  final QuizModel quiz;
  final void Function(String answer) onAnswerSelect;
  const Answers({super.key, required this.quiz, required this.onAnswerSelect});

  @override
  Widget build(BuildContext context) {
    final List<String> answerList = [
      ...quiz.incorrectAnswers,
      quiz.correctAnswer
    ];
    answerList.shuffle();

    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: answerList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 2),
        itemBuilder: (context, index) => ElevatedButton(
            onPressed: () {
              onAnswerSelect(answerList[index]);
            },
            child: Text(
              answerList[index],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            )));
  }
}
