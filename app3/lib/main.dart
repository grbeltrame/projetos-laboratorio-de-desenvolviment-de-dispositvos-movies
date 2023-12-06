import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart' as english_words;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class Favorite {
  int? id;
  late String name;

  Favorite({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      name: map['name'],
    );
  }
}

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'favorite';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'favorites.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertFavorite(Favorite favorite) async {
    final Database db = await database;
    return await db.insert(tableName, favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Favorite>> getFavorites() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Favorite.fromMap(maps[i]);
    });
  }

  Future<void> deleteFavorite(int id) async {
    final Database db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = english_words.WordPair.random();
  var favorites = <Favorite>[];

  final DatabaseHelper dbHelper = DatabaseHelper();

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void getNext() {
    current = english_words.WordPair.random();
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    if (favorites.any((favorite) => favorite.name == current.asPascalCase)) {
      final existingFavorite = favorites
          .firstWhere((favorite) => favorite.name == current.asPascalCase);
      await dbHelper.deleteFavorite(existingFavorite.id!);
      favorites.remove(existingFavorite);
    } else {
      final newFavorite = Favorite(name: current.asPascalCase);
      final id = await dbHelper.insertFavorite(newFavorite);
      newFavorite.id = id;
      favorites.add(newFavorite);
    }

    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final favoriteList = await dbHelper.getFavorites();
    favorites = favoriteList;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.loadFavorites();

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
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
              selectedIndex: appState.selectedIndex,
              onDestinationSelected: (value) {
                appState.loadFavorites();
                appState.setSelectedIndex(value);
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: appState.selectedIndex,
              children: [
                GeneratorPage(),
                FavoritesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites
        .any((favorite) => favorite.name == pair.asPascalCase)) {
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
                onPressed: () async {
                  await appState.toggleFavorite();
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final favorites = appState.favorites;

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(favorites[index].name),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await appState.dbHelper.deleteFavorite(favorites[index].id!);
              appState.loadFavorites();
            },
          ),
        );
      },
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final english_words.WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headline6!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
