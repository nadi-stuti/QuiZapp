import 'package:flutter/material.dart';
import 'package:quiz_app/app.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: IconButton(
                onPressed: appState.toggleTheme,
                icon: Icon(appState.theme == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () => appState.changeScreen(Screen.quiz),
                  icon: const Icon(Icons.question_mark_rounded),
                  label: const Text('Random Quiz')),
              ElevatedButton.icon(
                  onPressed: () => appState.changeScreen(Screen.custom),
                  icon: const Icon(Icons.dashboard_customize),
                  label: const Text('Custom Quiz')),
              ElevatedButton.icon(
                  onPressed: () => appState.changeScreen(Screen.favorite),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Favorite Quiz'))
            ],
          )
        ],
      ),
    );
  }
}
