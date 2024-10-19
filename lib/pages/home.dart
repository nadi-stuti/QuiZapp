import 'package:flutter/material.dart';
import 'package:quiz_app/app.dart';
import 'package:quiz_app/pages/custom_quiz.dart';
import 'package:quiz_app/pages/favorie_quiz.dart';
import 'package:quiz_app/pages/menu.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/pages/quiz.dart';
import 'package:quiz_app/pages/result.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();

    Widget page;
    switch (appState.currentScreen) {
      case Screen.menu:
        page = const Menu();
        break;
      case Screen.custom:
        page = const Customize();
        break;
      case Screen.quiz:
        page = const Quiz();
        break;
      case Screen.result:
        page = const Result();
        break;
      case Screen.favorite:
        page = const FavoriteQuiz();
        break;
      default:
        throw UnimplementedError('no widget for ${appState.currentScreen}');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(body: mainArea);
  }
}
