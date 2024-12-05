import 'package:exercise_flutter_acs/data.dart' as data;
import 'package:flutter/material.dart';

class ScreenGroupActions extends StatefulWidget {
  final data.UserGroup userGroup;
  const ScreenGroupActions({super.key, required this.userGroup});

  @override
  State<ScreenGroupActions> createState() => _ScreenGroupActionsState();
}

class _ScreenGroupActionsState extends State<ScreenGroupActions> {
  static final Map<String, String> actionDescription = {
    data.Actions.open : "Opens an unlocked doors",
    data.Actions.close: "Closes an open door",
    data.Actions.lock : "Locks a door or all doors in a room or group of rooms, if closed",
    data.Actions.unlock: "Unlocks a locked door or all the locked doors in a room",
    data.Actions.unlockShortly: "Unlocks a door during 10 seconds and then locks it if it is closed"
  };

  late List<bool> buttonsState;

  @override
  void initState() {
    super.initState();
    buttonsState = data.Actions.all.map((element) => (widget.userGroup.actions.contains(element))).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text('${widget.userGroup.name}\' actions' ),
      ),
      body: Column(
        children: [...List.generate( data.Actions.all.length, (index) {
          return Column(
            children: [
              CheckboxListTile(
                onChanged: (bool? value) {
                  setState(() {
                    buttonsState[index] = value!;
                  });
                },
                value: buttonsState[index],
                title: Text(
                  style: const TextStyle(
                    fontSize: 20
                ),
                  data.Actions.all[index],),
                subtitle: Text(
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    actionDescription[data.Actions.all[index]]!)),
              const Divider(),
            ]
          );}
        ),
        ElevatedButton(
          child: Text("Save"),
          onPressed: () {
          setState(() {
            List<String> newActions = [];
            for (var i = 0; i < buttonsState.length; i++){
              if(buttonsState[i]){
                newActions.add(data.Actions.all[i]);
              }
            }
            widget.userGroup.actions = newActions;
          });
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved')),
        );
          },
          )
        ]
      )
    );
  }
}
