import 'package:flutter/material.dart';

/// WAS NOT ABLE TO IMPLEMENT THIS FEATURE IN TIME
///
/// Builds recently played songs with their cover image

class RecentSongs extends StatelessWidget{
  final String text;
  final String cover;
  const RecentSongs({
    Key? key,
    required this.text,
    required this.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36,
        margin: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(135, 212, 155, 1),
        ),
      child: Row(
        children: <Widget>[
          Image.network(cover),
          const SizedBox(width: 10),
          Text(
            text,
          )
        ],
      ),
    );
  }
}