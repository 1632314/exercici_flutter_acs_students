import 'dart:io';

import 'package:exercise_flutter_acs/screen_group.dart';
import 'package:exercise_flutter_acs/screen_user_info.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'the_drawer.dart';

class ScreenGroupUsers extends StatefulWidget {
  UserGroup userGroup;

  ScreenGroupUsers({super.key, required this.userGroup});

  @override
  State<ScreenGroupUsers> createState() => _ScreenGroupUsers();
}

class _ScreenGroupUsers extends State<ScreenGroupUsers> {
  late UserGroup userGroup;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup; // the userGroups of ScreenListGroups
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: assign names like New group 1, New group 2...
          User newUser = User("new user", "111111");
          userGroup.users.add(newUser);
          setState(() {});
        },
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("${userGroup.name} users"),
      ),
      body: ListView.separated(
        // it's like ListView.builder() but better
        // because it includes a separator between items
        padding: const EdgeInsets.all(16.0),
        itemCount: userGroup.users.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildRow(userGroup.users[index], index),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _buildRow(User user, int index) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: FileImage(File(Data.images[user.name.toLowerCase()]!)),
      ),
      title: Text(user.name),
      trailing: Text(user.credential),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(
          builder: (context) => ScreenUserInfo(user: user)),
      )
          .then((var v) => setState(() {})),
    );
  }
}
