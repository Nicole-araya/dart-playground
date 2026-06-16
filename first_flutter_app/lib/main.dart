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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {  // This class is private (_)
  
  var selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(               // LayoutBuilder's builder callback is called every time the constraints change. 
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(                   // Ensures that its child is not obscured by a hardware notch or a status bar.
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,   // Appears when the screen is wide enough (more o equal 600px). If it true, shows the labels next to the icons. Or else, it only shows the icons. 
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,        // A selected index of zero selects the first destination,
                  onDestinationSelected: (value) {   // this callback is called when the user taps on a destination.
                    setState(() {                     // This is similar to notifyListeners() in MyAppState.
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(                    // Expanded widgets is that they are "greedy". The Expanded widget tells its child to fill the available space.
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
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

class FavoritesPage extends StatelessWidget{  

  @override
  Widget build(BuildContext context) {

      var appState = context.watch<MyAppState>();
      if (appState.favorites.isEmpty) {
        return Center(
          child: Text('No favorites yet.'),
        );
      }

      return ListView(  //When you want a Column that scrolls
        children:[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('You have ${appState.favorites.length} favorites:'),
          ),
          for (var pair in appState.favorites)
            ListTile(                          // ListTile has properties like title (generally for text), leading (for icons or avatars) and onTap (for interactions)
              leading: Icon(Icons.favorite),
              title: Text(pair.asLowerCase),
            ),
          
        ],
      );

  }

}