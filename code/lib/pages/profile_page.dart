import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/logic/database.dart';
import 'package:spotify/spotify.dart';
import 'package:my_app/api.dart';
import 'package:my_app/user_profile/app_bar.dart';
import 'package:my_app/user_profile/profile_widget.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:my_app/user_profile/open_spotify_button.dart';
import 'package:my_app/user_profile/recent_songs.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget{
  final String userID;
  const ProfilePage({Key? key, required this.userID}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState(userID: userID);
}


class _ProfilePageState extends State<ProfilePage>{

  // var user;
  // var id;
  String userID;
  _ProfilePageState({required this.userID});

  // API? userAPI;
  // Future<String> LinkUser() async{
  //   var lst = ['0','1'];
  //   // var credentials = await spotify.getCredentials();
  //   // userID = credentials.clientId;
  //   debugPrint("THE ID IS: $userID");
  //   return userID;
  //   // UserPublic user = await spotify.users.get(userID);
  //   // userAPI = API();
  //   // debugPrint('2');
  //   // debugPrint(userID);
  //   // // var displayName = await userAPI!.getUserDisplayName(userID);
  //   // var displayName = user.displayName;
  //   // // var profileURI = await userAPI!.getProfileImage(userID);
  //   // var profileURI = user.images!.first.url;
  //   // debugPrint("display name: $displayName");
  //   // lst[0] = displayName!;
  //   // lst[1] = profileURI!;
  //   // return lst;
  // }

  Future<List> getInfo(String id) async{
    var apiInstance = API();
    apiInstance.authenticate();
    // apiInstance.spotify = spotify;
    var lst = ['0','1'];
    var name = await apiInstance.getUserDisplayName(id);
    var img = await apiInstance.getProfileImage(id);
    lst[0] = name;
    lst[1] = img;
    return lst;
  }

  @override
  Widget build(BuildContext context){
    // final user = UserPreferences.myUser;
    // final argumentSpotify = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: buildAppBar(context),
        body: FutureBuilder<dynamic>(
          future: getInfo(userID),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              debugPrint("IMAGE:");
              debugPrint(snapshot.data[1]);
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  ProfileWidget(
                    // imagePath: user.imagePath,
                    imagePath: snapshot.data[1],
                    onClicked: () async {},
                  ),
                  const SizedBox(height: 26),
                  buildName(snapshot.data[0]),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(child: buildOpenSpotifyButton(userID)),
                  const SizedBox(
                    height: 18,
                  ),
                  /*
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: const Text(
                      'Recently Played Songs',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),

                  Center(child: buildRecentSongs("yes")),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(child: buildRecentSongs("no")),

                   */
                ],
              );
            }
            else if (snapshot.hasError) {
              //debugPrint(snapshot.data);
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
              //debugPrint(snapshot.data);
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
          }
        ),


    );
  }

  Widget buildName(String id) => Column(
    children: [
      Text(
        id,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      ),
    ],
  );
/*
  Widget buildName(String snapshot) {
    List<Widget> children;
    return FutureBuilder<dynamic>(
        future: getName(snapshot),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
          if(snap.hasData) {
            return Text(
              snap.data,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 26),
            );
          }
          else if (snap.hasError) {
            debugPrint(snapshot);
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Text('Error: ${snap.error}'),
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          } else {
            debugPrint(snap.data);
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
        }
    );
  }
*/
  Widget buildOpenSpotifyButton(String id) => OpenSpotify(
    text: 'Open Profile in Spotify',
    onClicked: () {
      // add open spotify profile link stuff
      _launchURL(id);
    },
  );

  _launchURL(String id) async {
    var url = 'https://open.spotify.com/user/$id';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildRecentSongs(String id) => RecentSongs(
    // text: user.recentSong,
    // cover: user.recentSongImage,
    cover: 'https://cdn.britannica.com/w:400,h:300,c:crop/89/164789-050-D6B5E2C7/Barack-Obama-2012.jpg',
    text: id,
  );

}
