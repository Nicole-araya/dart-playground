import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {         // It only tells Flutter to run the app defined in MyApp.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {     // Widgets are the elements from which you build every Flutter app. As you can see, even the app itself is a widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // The new getNext() method reassigns current with a new random WordPair. 
  // It also calls notifyListeners()(a method of ChangeNotifier)that ensures that anyone watching MyAppState is notified.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random AWESOME idea:'), 
          Text(appState.current.asLowerCase),
          
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),

          
          ],
      ),
    );
  }
}
