import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
import 'filter_page.dart';
import 'song.dart';
import 'package:my_app/api.dart';

class GridViewPage extends StatefulWidget {
  const GridViewPage({Key? key, required}) : super(key: key);

  @override
  _GridViewPageState createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  // Default placeholder text
  String textToShow = "I Like Flutter";
  double _radius = 5;
  bool _gridView = true;

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  void goToSongPage(SpotifyApi spotify) {
    Track? track;
    spotify.tracks
        .get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f')
        .then((value) {
      track = value;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Song(
            track: track!,
          ),
        ),
      );
    });
  }

  void _onRadiusChanged(FilterValues values) {
    setState(() {
      _radius = values.radius;
      _gridView = values.gridView;
    });
    print('radius is $_radius, grid view is $_gridView');
  }

  @override
  Widget build(BuildContext context) {
    final argumentSpotify =
        ModalRoute.of(context)!.settings.arguments as SpotifyApi;
    FilterValues filterValues = FilterValues();
    Future<List<dynamic>> nearbySongIds =
        MongoDatabase.getNearbySongsForLoc(100, 100, 10);
    print("song ids $nearbySongIds");
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid View"),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20, top: 18),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FilterPage(
                                  filterValues: filterValues,
                                  onChanged: _onRadiusChanged,
                                )));
                  },
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )))
        ],
      ),
      body: Center(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            child: TextButton(
                onPressed: () {
                  goToSongPage(argumentSpotify);
                },
                child: const Text('Heed not the rabble',
                    style: TextStyle(color: Colors.black))),
            color: Colors.teal[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Sound of screams but the'),
            color: Colors.teal[300],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Who scream'),
            color: Colors.teal[400],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution is coming...'),
            color: Colors.teal[500],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution, they...'),
            color: Colors.teal[600],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text("He'd have you all unravel at the"),
            color: Colors.teal[100],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Heed not the rabble'),
            color: Colors.teal[200],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Sound of screams but the'),
            color: Colors.teal[300],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Who scream'),
            color: Colors.teal[400],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution is coming...'),
            color: Colors.teal[500],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution, they...'),
            color: Colors.teal[600],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Who scream'),
            color: Colors.teal[400],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution is coming...'),
            color: Colors.teal[500],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution, they...'),
            color: Colors.teal[600],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution is coming...'),
            color: Colors.teal[500],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution, they...'),
            color: Colors.teal[600],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Who scream'),
            color: Colors.teal[400],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution is coming...'),
            color: Colors.teal[500],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution, they...'),
            color: Colors.teal[600],
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: Icon(Icons.library_music),
      ),
    );
  }
}
