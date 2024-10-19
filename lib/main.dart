import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/app.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(), child: const MyApp());
  }
}
