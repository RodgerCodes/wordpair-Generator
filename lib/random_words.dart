import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomwords = <WordPair>[];
  final _savedWord = Set<WordPair>();
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item){
         if(item.isOdd) {
           return Divider();
         }

         final index = item ~/ 2;
         if(index >= _randomwords.length) {
           _randomwords.addAll(generateWordPairs().take(10));
         }

         return _buildRow(_randomwords[index]);
      }
    );
  }
  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _savedWord.contains(pair);
    return ListTile(
      title:Text(pair.asPascalCase, style:TextStyle(
        fontSize:18.0
      )),
      trailing: Icon(_alreadySaved ? Icons.favorite : Icons.favorite_border, color: _alreadySaved ? Colors.red : null),
      onTap:() {
        setState(() {
          if(_alreadySaved) {
            _savedWord.remove(pair);
          }
          else {
            _savedWord.add(pair);
          }
        });
      },
    );
  }
  
  // Save to another activity
  void _pushSaved() {
     Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _savedWord.map((WordPair pair) {
              return ListTile (
                title: Text(pair.asPascalCase, style: TextStyle(
                  fontSize: 16.0
                ),),
              );
            });
            final List<Widget> divided = ListTile.divideTiles(
              context:context,
              tiles:tiles
            ).toList();

            return Scaffold (
              appBar: AppBar(title: Text('Saved WordPairs'),),
              body: ListView(children: divided),
            );
          }
          
          
        )
     );
  }

  Widget build(BuildContext context ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordpair Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
          onPressed: _pushSaved
          ,)
        ],
      ),
      body: _buildList(),
    );
  }
}