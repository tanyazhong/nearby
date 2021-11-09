import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'api.dart';
import 'pages/song.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as widgets;
import 'package:my_app/pages/MongoDBPage.dart';
import 'package:my_app/pages/grid_view_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:my_app/locate.dart';
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
  int _counter = 0;
  SpotifyApi? spotify;
  Track? track;
  API? apiInstance;
  bool trackSet = false;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  initState() {
    apiInstance = API();
  }

  void share() async {
    SpotifyApi spotify = await apiInstance!.authenticateUser();
    var recentlyPlayed = await apiInstance!.getRecentlyPlayed(10);
    print(recentlyPlayed.map((song) => song.track!.name).join(', '));
    Navigator.pushNamed(context, '/grid_view', arguments: spotify);
  }

  void lurk() {
    SpotifyApi spotify = apiInstance!.authenticate();
    Navigator.pushNamed(context, '/grid_view', arguments: spotify);
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
                scale: .8,
              ),
            ),
            ElevatedButton(
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
            ElevatedButton(
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
            const Text(
              'Click the + to go to the mongodb page',
            ),
            ElevatedButton(
              onPressed: () async {
                var pleaseWork = locate();
                // waits until location service is enabled
                pleaseWork.checkLocationService();

                // waits until user gives their permission to share location
                pleaseWork.checkPermission();

                // finding user location
                LocationData loc = await pleaseWork.findLocation();

                // can push back loc.latitude and loc.longitude onto latLon object
                print(loc);
              },
              child: const Text('print location'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return MongoDBPage();
              },
            ),
          ).then((value) => setState(() {}));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
