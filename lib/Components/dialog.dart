import 'package:flutter/material.dart';
import 'package:quiz_app/helpers/classes.dart';

Future<void> dialogBuilder(
    BuildContext context, QuizModel quiz, String answer, Function action) {
  bool correct = quiz.correctAnswer == answer;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        icon: correct
            ? const Icon(
                Icons.done,
                color: Colors.green,
              )
            : const Icon(Icons.close, color: Colors.red),
        content: Text(
          quiz.correctAnswer,
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(0),
        actions: <Widget>[
          TextButton(
            child: const Text('next'),
            onPressed: () {
              Navigator.of(context).pop();
              action();
            },
          ),
        ],
      );
    },
  );
}
