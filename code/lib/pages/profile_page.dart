import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
import 'package:my_app/api.dart';
import 'package:my_app/user_profile/app_bar.dart';
import 'package:my_app/user_profile/user_preferences.dart';
import 'package:my_app/user_profile/profile_widget.dart';
import 'package:my_app/user_profile/user.dart' as u;

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    final user = UserPreferences.myUser;
    return Scaffold(
      appBar: buildAppBar(context),
      body:ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked:() async{},
          ),
          const SizedBox(height: 26),
          buildName(user),
        ],
      )
    );
  }

  Widget buildName(u.User user) => Column(
    children: [
      Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      ),
      const SizedBox(height: 4),
      Text(
        user.userName,
        style: const TextStyle(color: Colors.grey),
      )
    ],
  );
}

