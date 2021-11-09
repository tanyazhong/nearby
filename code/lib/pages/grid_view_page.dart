import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
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
  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  double degreesToRadians(double degree) {
    return (degree * pi / 180);
  }

  bool withinDistance(double lat1, double lon1, double lat2, double lon2, double distance) {
    // dist = arccos(sin(lat1) · sin(lat2) + cos(lat1) · cos(lat2) · cos(lon1 - lon2)) · R
    final R = 6371; // Earth has radius 6371KM
    double d = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon1 - lon2)) * R;
    if (d < distance) {
      return true;
    }
    return false;
  }
  Future<List<dynamic>> getNearbySongsForLoc(double lat, double lon, double distance) async {
    List<dynamic> results = [];
    Map<dynamic, dynamic> documents = await MongoDatabase.getDocuments();
    debugPrint("hi doc $documents");

    Iterable<dynamic> coordinates = documents.keys;
    for (var coord in coordinates) {
      dynamic cur = coord.split(",");
      double curLat = degreesToRadians(double.parse(cur[0]));
      double curLon = degreesToRadians(double.parse(cur[1]));
      if (withinDistance(degreesToRadians(lat), degreesToRadians(lon), curLat, curLon, distance)) {
        results.add(coord);
      }
    }
    return results;
  }
  void goToSongPage(SpotifyApi spotify){
    Track? track;
    spotify.tracks.get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f').then((value){
      track = value;
      Navigator.push(context, MaterialPageRoute(builder: (_) => Song(track: track!,),),);

    });
  }

  @override
  Widget build(BuildContext context) {
    final argumentSpotify = ModalRoute.of(context)!.settings.arguments as SpotifyApi;
    getNearbySongsForLoc(100, 100, 10);
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid View"),
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
            child:  TextButton(onPressed: () {
              goToSongPage(argumentSpotify);
            },
                child: const Text('Heed not the rabble', style: TextStyle(color: Colors.black))),
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
