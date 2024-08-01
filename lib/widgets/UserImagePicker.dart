
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget{
  final void Function(File pickedImage) onPickImage;
  const UserImagePicker({required this.onPickImage});


  @override
  State<UserImagePicker> createState() {
    return new UserImagePickerState();
  }
}

class UserImagePickerState extends State<UserImagePicker>{
  File? _pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if(pickedImage == null){
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);

  }


  Widget build(BuildContext context){
    return  Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          ),
          ElevatedButton(
              onPressed: pickImage,
              child: Text("Add An Image"))
        ],
    );
  }
}
