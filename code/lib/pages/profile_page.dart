import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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


  String userID;
  _ProfilePageState({required this.userID});



  Future<List> getInfo(String id) async{
    var apiInstance = API();
    apiInstance.authenticate();
    var lst = ['0','1'];
    var name = await apiInstance.getUserDisplayName(id);
    var img = await apiInstance.getProfileImage(id);
    lst[0] = name;
    lst[1] = img;
    return lst;
  }

  @override
  Widget build(BuildContext context){
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
                ],
              );
            }
            else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const Text('Error: User not found')
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

  Widget buildOpenSpotifyButton(String id) => OpenSpotify(
    text: 'Open Profile in Spotify',
    onClicked: () {
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

    cover: 'https://cdn.britannica.com/w:400,h:300,c:crop/89/164789-050-D6B5E2C7/Barack-Obama-2012.jpg',
    text: id,
  );

}
