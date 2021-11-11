import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget{
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
  required this.imagePath,
  required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditPhoto(const Color.fromRGBO(93, 176, 117, .5)),
          )
        ],
      ),
    );
  }

  Widget buildImage(){
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditPhoto(Color color) => buildCircle(
      color: const Color.fromRGBO(93, 176, 117, 1),
      all: 8,
      child: const Icon(
        Icons.edit,
        size: 20,
    ),
  );

  Widget buildCircle({
      required Widget child,
      required double all,
      required Color color,
  }) =>
    ClipOval(
      child: Container(
        color: color,
        child: child,
        padding: EdgeInsets.all(all),
      ),
    );
}