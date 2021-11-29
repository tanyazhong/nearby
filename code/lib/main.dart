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
      },
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF5DB075, shadesOfGreen),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  }

  void lurk() {
    SpotifyApi spotify = apiInstance!.authenticate();
    Navigator.pushNamed(context, '/grid_view', arguments: spotify);
  }

  void profile() async {
    SpotifyApi spotify = await apiInstance!.authenticateUser();
    var credentials = await spotify.getCredentials();
    String? id = credentials.clientId;
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return ProfilePage(
          userID: '$id',
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: widgets.Image.asset("assets/nearby_logo.png", scale: 1),
            ),
            Container(
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
            Container(
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
            const SizedBox(height: 15),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
