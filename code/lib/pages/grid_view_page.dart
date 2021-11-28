import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:my_app/logic/database.dart';
import 'package:my_app/logic/database_entry.dart';
import 'package:spotify/spotify.dart';
import '../locate.dart';
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
  double _radius = 20;
  bool _gridView = true;

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  /// When the createPlaylist button is pressed, creates a playlist
  void generatePlaylist(SpotifyApi spotify) async {
    LocationData location = await locate().findLocation();
    dynamic nearbySongs = await MongoDatabase.getNearbySongsForLoc(
        location.latitude!, location.longitude!, _radius);
    List<String> songUIs = [];
    for (dynamic song in nearbySongs) {
      songUIs.add(song[0]);
    }
    Iterable<String> iterableURIs = songUIs;
    API userAPI = API();
    userAPI.spotify = spotify;
    await userAPI.createPlaylist(iterableURIs);
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
        title: const Text(
          'nEARby',
          style: TextStyle(color: Colors.black, fontSize: 35),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 80,
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
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )))
        ],
      ),
      body: FutureBuilder<dynamic>(
        //34.06892, -118.445183, 20
        future:
            MongoDatabase.getNearbySongsForLoc(34.06892, -118.445183, _radius),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[];
            List<dynamic> data = snapshot.data;
            debugPrint("data: ${snapshot.data}");
            if (_gridView) {
              // DISPLAY GRID VIEW
              return Center(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 4 / 6,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0),
                    itemCount: data.length,
                    itemBuilder: (BuildContext ctx, index) {
                      var uid = data[index][1];
                      debugPrint("user id: $uid");
                      return Container(
                          height: 300,
                          child: SongWidget(
                              trackID: data[index][0],
                              userID: data[index][1].toString()));
                    }),
              );
            } else {
              // DISPLAY LIST VIEW
              return Center(
                child: ListView.builder(
                    itemExtent: 70,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          child: ListSongWidget(
                              trackID: data[index][0],
                              userID: data[index][1].toString()));
                    }),
              );
            }
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
                child: Text('Loading...'),
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
      // floatingActionButton: Container(
      //   height: 60,
      //   width: 60,
      //   child: FittedBox(
      //     child: FloatingActionButton(
      //         onPressed: () => generatePlaylist(argumentSpotify),
      //         tooltip: 'Make Playlist',
      //         child: Column(children: <Widget>[
      //           Container(height: 20),
      //           const Icon(Icons.library_music)
      //         ])),
      //   ),
      // )
      floatingActionButton: FloatingActionButton(
        onPressed: () => generatePlaylist(argumentSpotify),
        tooltip: 'Make Playlist',
        child: const Icon(Icons.library_music),
      ),
    );
  }
}

//on press check for currently playing then upload to database

