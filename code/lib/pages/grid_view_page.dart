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
        title: Text(
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
        future: MongoDatabase.getNearbySongsForLoc(34.06892, -118.445183, 20),
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
                      return SongWidget(trackID: data[index][0]);
                    }),
              );
            } else {
              // DISPLAY LIST VIEW
              return Center(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SongWidget(trackID: data[index][0]);
                      // return ListTile(
                      //     leading: Icon(Icons.list),
                      //     trailing: const Text(
                      //       "GFG",
                      //       style: TextStyle(color: Colors.green, fontSize: 15),
                      //     ),
                      //     title: Text("List item $index"));
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
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: const Icon(Icons.library_music),
      ),
    );
  }
}
