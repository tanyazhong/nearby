import 'package:flutter/material.dart';

class OpenSpotify extends StatelessWidget{
  final String text;
  final VoidCallback onClicked;

  const OpenSpotify({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
    ),

    child: Text(text),
    onPressed: onClicked,
  );

}