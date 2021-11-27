import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/logic/database_entry.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'api.dart';
import 'background.dart';
import 'pages/song.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as widgets;
import 'package:my_app/pages/grid_view_page.dart';
import 'package:my_app/locate.dart';
import 'package:my_app/logic/database.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final Map<int, Color> shadesOfGreen = const {
    50: const Color.fromRGBO(93, 176, 117, .1),
    100: const Color.fromRGBO(93, 176, 117, .2),
    200: const Color.fromRGBO(93, 176, 117, .3),
    300: const Color.fromRGBO(93, 176, 117, .4),
    400: const Color.fromRGBO(93, 176, 117, .5),
    500: const Color.fromRGBO(93, 176, 117, .6),
    600: const Color.fromRGBO(93, 176, 117, .7),
    700: const Color.fromRGBO(93, 176, 117, .8),
    800: const Color.fromRGBO(93, 176, 117, .9),
    900: const Color.fromRGBO(93, 176, 117, 1),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Welcome!'),
        '/grid_view': (context) => GridViewPage(),
        '/profile': (context) => ProfilePage()
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: MaterialColor(0xFF5DB075, shadesOfGreen),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
      ),
      // home: const MyHomePage(title: 'This should be LoginPage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpotifyApi? spotify;
  Track? track;
  API? apiInstance;
  bool trackSet = false;
  TrackChange? trackChange;

  @override
  initState() {
    apiInstance = API();
    trackChange = TrackChange();
  }

  void share() async {
    SpotifyApi spotify = await apiInstance!.authenticateUser();

    Navigator.pushNamed(context, '/grid_view', arguments: spotify);
    var recentlyPlayed = await apiInstance!.getRecentlyPlayed(5);
    print(recentlyPlayed.map((song) => song.track!.name).join(', '));

    User account = await spotify.me.get();
    for (PlayHistory song in recentlyPlayed) {
      await addSongToDB(account.id, song.track!.id!);
    }
    trackChange!.handleTrackChanges(spotify);
    // example usage of some of the API functions

    // Iterable<dynamic> dbSongs =
    //     await MongoDatabase.getNearbySongsForLoc(34.06892, -118.445183, 20);
    // print(dbSongs);
    // Iterable<String> testSongs = dbSongs.map((song) => song[0] as String);
    // var p = await apiInstance!.createPlaylist(testSongs);
    // String profileURL =
    //     await apiInstance!.getProfileImage("cif5mulm9m0s5jev1kwpmbjz7");
    // print(profileURL);
    // String displayName =
    //     await apiInstance!.getUserDisplayName("cif5mulm9m0s5jev1kwpmbjz7");
    // print(displayName);
  }

  void lurk() {
    SpotifyApi spotify = apiInstance!.authenticate();
    //spotify.me.get().then((value) => print('lurk is $value'),
    //).onError((error, stackTrace) => print('lurk is null'));
    Navigator.pushNamed(context, '/grid_view', arguments: spotify);
  }

  void profile() async {
    SpotifyApi spotify = await apiInstance!.authenticate();
    Navigator.pushNamed(context, '/profile', arguments: spotify);
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfilePage();
        },
      ),
     */
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontSize: 35),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(15),
                color: Color.fromRGBO(169, 209, 142, 1),
                child: widgets.Image.asset(
                  "assets/nearby_logo.png",
                  alignment: Alignment.center,
                  scale: 1,
                ),
              ),

            Expanded(
              child: ElevatedButton(
                onPressed: share,
                child: Text("Share!",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  fixedSize: const Size(330, 50),
                ),
              ),
            ),
            const SizedBox(
              height: 10
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: lurk,
                child: Text("Lurk",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  fixedSize: const Size(330, 50),
                ),
              ),
            ),
            const SizedBox(
                height: 10
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: profile,
                child: Text("Profile",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  fixedSize: const Size(330, 50),
                ),
              ),
            ),
            const SizedBox(
                height: 10
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  print("locating!");
                  var pleaseWork = locate();
                  // waits until location service is enabled
                  var serviceStatus = await pleaseWork.checkLocationService();
                  print("checked: service status is $serviceStatus");
                  // waits until user gives their permission to share location
                  var permissionStatus = await pleaseWork.checkPermission();
                  print("permission: permission status is $permissionStatus");
                  var backgroundPermission =
                  await pleaseWork.backgroundPermission();
                  print("background permission status is $backgroundPermission");
                  // finding user location
                  LocationData loc = await pleaseWork.findLocation();

                  // can push back loc.latitude and loc.longitude onto latLon object
                  print(loc);
                },
                child: const Text('print location'),
              ),
            ),
            const SizedBox(
                height: 10
            ),
          ],
        ),
      ),
    );
  }
}
