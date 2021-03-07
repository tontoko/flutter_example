import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => AScreen(),
        '/b': (BuildContext context) => BScreen()
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final tiles = _saved.map((WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        });
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
        return Scaffold(
            appBar: AppBar(
              title: Text('saved'),
            ),
            body: ListView(children: divided));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('test header'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.zoom_out_sharp),
              title: Text('a'),
              onTap: () => Navigator.of(context).pushNamed('/a'),
            ),
            ListTile(
              leading: Icon(Icons.zoom_out_sharp),
              title: Text('b'),
              onTap: () => Navigator.of(context).pushNamed('/b'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains((pair));
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
    // return Stack(alignment: const Alignment(0.6, 0.6), children: <Widget>[
    //   ListTile(title: Text(pair.asPascalCase, style: _biggerFont)),
    //   Container(
    //       decoration: BoxDecoration(
    //         color: Colors.black26,
    //       ),
    //       child: Text('aaaaa'))
    // ]);
  }
}

class AScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('a route'),
        actions: [
          IconButton(
              icon: Icon(Icons.add_link),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      title: Text('title'), content: Text('content'))))
        ],
      ),
      body: Text(
        'a route',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class BScreen extends StatefulWidget {
  @override
  _BScreenState createState() => _BScreenState();
}

class _BScreenState extends State<BScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('b route'),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
      body: Text('b route'),
    );
  }
}
