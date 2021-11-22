import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
import 'package:my_app/api.dart';
import 'package:my_app/user_profile/app_bar.dart';
import 'package:my_app/user_profile/user_preferences.dart';
import 'package:my_app/user_profile/profile_widget.dart';
import 'package:my_app/user_profile/user.dart' as u;
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:my_app/user_profile/open_spotify_button.dart';
import 'package:my_app/user_profile/recent_songs.dart';

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
          const SizedBox(
            height: 10,
          ),
          Center(child: buildOpenSpotifyButton()),
          const SizedBox(
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: const Text(
            'Recently Played Songs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Center(child: buildRecentSongs(user)),
          const SizedBox(
            height: 18,
          ),
          Center(child: buildRecentSongs(user)),
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

  Widget buildOpenSpotifyButton() => OpenSpotify(
    text: 'Open Profile in Spotify',
    onClicked: () {
      // add open spotify profile link stuff
    },
  );

  Widget buildRecentSongs(u.User user) => RecentSongs(
      text: user.recentSong,
      cover: user.recentSongImage,
  );

}

