import 'package:flutter/material.dart';
import 'package:my_app/logic/UserExample.dart';

class UserCard extends StatelessWidget {
  UserCard({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        leading: Text(
          '${user.age}',
          style: Theme.of(context).textTheme.headline6,
        ),
        title: Text(user.name)
      )
    );
  }
}
