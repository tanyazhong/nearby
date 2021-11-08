import 'package:flutter/material.dart';
import 'package:my_app/logic/database.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
// @dart=2.9
import 'dart:developer';

import 'package:my_app/logic/response.dart';

void main() {
  log("hi");
  runApp(const MongoDBPage());
}

class MongoDBPage extends StatelessWidget {
  const MongoDBPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //log("building");
    return MaterialApp(
      title: 'MongoDB Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '!'),
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
  Map<dynamic, dynamic> process(Map response) {
    return response;
  }

  @override
  Widget build(BuildContext context) {
    log("building");
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
        future: MongoDatabase.getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          } else {
            if (snapshot.hasError) {
              log("error!!");
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Something went wrong!! $snapshot',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                ),
              );
            } else if (snapshot.data == null ){
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'data is null. $snapshot',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                ),
              );
            } else {
              log("hi");
              var firstName = snapshot.data;
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'data is ok. $firstName',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                ),
              );
            }
          }
        });
  }
}