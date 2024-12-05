import 'dart:io';
import 'dart:math';

import 'package:exercise_flutter_acs/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ScreenUserInfo extends StatefulWidget {
  final User user;

  const ScreenUserInfo({super.key, required this.user});

  @override
  State<ScreenUserInfo> createState() => _ScreenUserInfo();
}

class _ScreenUserInfo extends State<ScreenUserInfo> {
  late TextEditingController _nameController;
  late TextEditingController _credentialController;
  final _formKey = GlobalKey<FormState>();
  late dynamic _imageAvatar;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _credentialController = TextEditingController(text: widget.user.credential);
    _imagePath = Data.images[widget.user.name.toLowerCase()]!;
    _imageAvatar = FileImage(File(Data.images[widget.user.name.toLowerCase()]!));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _credentialController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
        final file = await _saveImage(File(pickedFile.path));
        _imageAvatar = FileImage(file);
        setState(() { });
    }
  }

  Future<File> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(image.path);
    _imagePath = '${directory.path}${Platform.pathSeparator}$name';
    return image.copy(_imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text('Info ${widget.user.name}'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Theme.of(context).primaryColorLight,
                  ),
                  child: CircleAvatar(
                    foregroundImage: _imageAvatar,
                    radius: MediaQuery.of(context).size.shortestSide  * 0.25,
                  )
                ),
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
                  controller: _credentialController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'credential',
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
                        widget.user.name = _nameController.text;
                        widget.user.credential = _credentialController.text;
                        Data.images[widget.user.name.toLowerCase()] = _imagePath;
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
