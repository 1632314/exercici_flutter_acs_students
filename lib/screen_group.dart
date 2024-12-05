import 'package:exercise_flutter_acs/data.dart';
import 'package:exercise_flutter_acs/screen_group_actions.dart';
import 'package:exercise_flutter_acs/screen_group_info.dart';
import 'package:exercise_flutter_acs/screen_group_schedule.dart';
import 'package:exercise_flutter_acs/screen_group_users.dart';
import 'package:flutter/material.dart';

class ScreenGroup extends StatefulWidget {
  final UserGroup userGroup;

  const ScreenGroup({super.key, required this.userGroup});

  @override
  State<ScreenGroup> createState() => _ScreenGroupState();
}

class _ScreenGroupState extends State<ScreenGroup> {
  late UserGroup _userGroup;

  final List<IconData> icons = [Icons.description,
    Icons.calendar_month,
    Icons.room_preferences,
    Icons.holiday_village,
    Icons.manage_accounts
  ];

  final List<String> iconTag = ["Info",
    "Schedule",
    "Actions",
    "Places",
    "Users"
  ];

  late final List<Widget Function()> nextScreen;

  @override
  void initState() {
    super.initState();
    _userGroup = widget.userGroup;
    nextScreen = [
        () => ScreenGroupInfo(userGroup: widget.userGroup),
        () => ScreenGroupSchedule(userGroup: widget.userGroup),
        () => ScreenGroupActions(userGroup: widget.userGroup),
        () => widget,
        () => ScreenGroupUsers(userGroup: widget.userGroup)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("Group ${_userGroup.name}"),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(icons.length, (index) {
            return Container(
              color: Theme.of(context).colorScheme.secondary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () =>  Navigator.of(context)
                          .push(MaterialPageRoute<void>(
                          builder: (context) => nextScreen[index]()),
                      )
                          .then((var v) => setState(() {})),
                      icon: Icon(this.icons[index]),
                      iconSize: MediaQuery.of(context).size.width * 0.25,
                      color: Colors.white,
                    ),
                    Text(
                        style: const TextStyle(
                        color: Colors.white
                        ),
                        this.iconTag[index]),
                  ],
                ),
              )
            );
          }),
        ),
      ),
    );
  }
}
