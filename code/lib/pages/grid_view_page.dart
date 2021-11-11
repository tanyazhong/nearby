import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
import 'filter_page.dart';
import 'song.dart';
import 'package:flutter/src/widgets/image.dart' as widgets;
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

  void goToSongPage(SpotifyApi spotify, String songID) {
    Track? track;
    spotify.tracks.get(songID).then((value) {
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
    debugPrint('radius is $_radius, grid view is $_gridView');
  }

// https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
  @override
  Widget build(BuildContext context) {
    final argumentSpotify =
        ModalRoute.of(context)!.settings.arguments as SpotifyApi;
    FilterValues filterValues = FilterValues();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid View"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20, top: 18),
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
                  child: const Text(
                    'Filter',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )))
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: MongoDatabase.getNearbySongsForLoc(34.06892, -118.445183, 2),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[];
            List<dynamic> data = snapshot.data[0];
            debugPrint("data: ${snapshot.data}");
            return Center(
              child:
                  // Text(
                  //   'Result: ${snapshot.data}',
                  // ),
                  GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    goToSongPage(argumentSpotify, data[index]);
                                  },
                                  child: widgets.Image.asset(
                                      "assets/nearby_logo.png",
                                      alignment: Alignment.center,
                                      height: 75,
                                      width: 75)),
                              const Text(
                                'Song Title',
                                textAlign: TextAlign.left,
                              ),
                              const Text(
                                'Song Artist',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          color: Colors.white,
                        );
                      }),
            );
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Text('Error: ${snapshot.error}'),
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: const Icon(Icons.library_music),
      ),
    );
  }
}
