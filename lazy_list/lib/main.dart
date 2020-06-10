import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy List',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: RandomWords(title: 'Wordpair Generator'),
    );
  }
}

class RandomWords extends StatefulWidget {

  RandomWords({this.title});
  final String title;

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  WordPair wordPair = WordPair.random();
  List<WordPair> _words = <WordPair>[];
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  ScrollController sc = new ScrollController();
  Set<WordPair> saved = Set<WordPair>();

  @override
  void initState()
  {
    _words.addAll(generateWordPairs().take(10));
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent){
        setState(() {
          _words.addAll(generateWordPairs().take(10));
        });
    }
    });
    super.initState();
  }
  Widget _buildWordPairs() {

    return ListView.separated(
      controller: sc,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, int index) {
        bool alreadySaved = saved.contains(_words[index]);
        return ListTile(
          title: Text(_words[index].asPascalCase, style: _biggerFont,),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
          onTap: () {
            setState(() {
              if(alreadySaved)
                saved.remove(_words[index]);
              else
                saved.add(_words[index]);
            });
          }
        );
      },
        separatorBuilder: (context, int index) => Divider(),
        itemCount: _words.length);
  }

  void _showSaved(){
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Saved(saved: saved)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _showSaved),
        ],
      ),
      body: _buildWordPairs()
    );
  }
}

class Saved extends StatelessWidget {
  final Set<WordPair> saved;
  Saved({this.saved});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Pairs'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
          itemBuilder: (context, int index) {
            return ListTile(
              title: Text(saved.elementAt(index).asPascalCase, style: TextStyle(fontSize: 18),),
            );
          },
          separatorBuilder: (context, int index) => Divider(),
          itemCount: saved.length),
    );
  }
}






