import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
import 'package:my_app/api.dart';

AppBar buildAppBar(BuildContext context){
  final icon = CupertinoIcons.gear_alt;
  return AppBar(
    leading: const BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed:(){},
      )
    ],
  );
}