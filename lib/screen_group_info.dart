import 'package:exercise_flutter_acs/data.dart';
import 'package:flutter/material.dart';

class ScreenGroupInfo extends StatefulWidget {
  final UserGroup userGroup;

  const ScreenGroupInfo({super.key, required this.userGroup});

  @override
  State<ScreenGroupInfo> createState() => _ScreenGroupInfoState();
}

class _ScreenGroupInfoState extends State<ScreenGroupInfo> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userGroup.name);
    _descriptionController = TextEditingController(text: widget.userGroup.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text('Info ${widget.userGroup.name}'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: _nameController,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'name group',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 1.0
                      )
                    )),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1.0
                        )
                    )),
              ),
              // Add more fields for schedule, allowed actions, and users
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    setState(() {
                      widget.userGroup.name = _nameController.text;
                      widget.userGroup.description = _descriptionController.text;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          )
        ),
      ),
    );
  }
}
