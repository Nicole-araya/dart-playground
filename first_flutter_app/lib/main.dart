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
          colorScheme: ColorScheme.fromSeed(seedColor:  Color.fromRGBO(225, 76, 255, 1)),
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

  var favorites = <WordPair>[];

  void toggleFavorite(){
    if (favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }


}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)){
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             
            BigCard(pair: pair),
            SizedBox(height: 10), // A SizedBox is a box with a specified size. Space between the BigCard and the button.
            Row(
              mainAxisSize: MainAxisSize.min, // To make the row only as wide as its children
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                
                SizedBox(width: 10), // Space between the two buttons

                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
                
              ],
            ),
            
            ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);     // To get the current theme, we use Theme.of(context). This is a common pattern in Flutter.
    final style = theme.textTheme.displayMedium!.copyWith(  // We can also use the theme to style our text. 
      color: theme.colorScheme.onPrimary,
      
    );  

    return Card(
        color: theme.colorScheme.primary,     // We can use the theme to set the color of the card.
        elevation: 2,   // Shadows
        child: Padding(                                // Flutter uses Composition over Inheritance whenever it can. 
          padding: const EdgeInsets.all(20),         // Here, instead of padding being an attribute of Text, it's a widget!
          child: Text(
            pair.asLowerCase, 
            style: style,
            semanticsLabel: "${pair.first} ${pair.second}", // Using two separate words instead of a compound word makes sure that screen readers identify them appropriately

          ),
        ),
      );
  }
}
