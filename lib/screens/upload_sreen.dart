import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/widgets/cat_options_button.dart';
import 'dart:io';



final _imagePicker = ImagePicker();

class UploadScreen extends StatefulWidget {

  State<UploadScreen> createState(){
    return _UploadScreenState();
  }
}

class _UploadScreenState extends State<UploadScreen> {
  var _newTweetController = TextEditingController();
  List<String> tags = [];
  List<String> imageUrls = [];
  List<File> selectedImages = [];
  @override
  void dispose(){
    _newTweetController.dispose();
    super.dispose();
  }
  _uploadTweet() async {
    final _enteredTweet = _newTweetController.text;
    if(_enteredTweet.trim().isEmpty){
      return;
    }
    _newTweetController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    final tweet_ref = await FirebaseFirestore.instance.collection("tweets").doc();



    final batch = FirebaseFirestore.instance.batch();
    for(int i = 0; i < selectedImages!.length; i++){
      final storageRef = FirebaseStorage.instance.ref()
          .child("tweet_images")
          .child('${tweet_ref.id}_image${i+1}.jpg');
      await storageRef.putFile(selectedImages![i]);
      final imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }


    final tagCollecRef = FirebaseFirestore.instance.collection("tags");
    for(var tag in tags) {
      DocumentReference tagRef = tagCollecRef.doc(tag);
      DocumentSnapshot tagDoc = await tagRef.get();
      await tagRef.set(
        {'count': FieldValue.increment(1)},
      SetOptions(merge: true));
      batch.set(tweet_ref, {
        "tweetId": tweet_ref.id,
        "text": _enteredTweet,
        "createdAt": Timestamp.now(),
        "userId": user.uid,
        "userProfileImageUrl":userData.data()!["userProfileImageUrl"],
        "username": userData.data()!["username"],
        "imageUrls": imageUrls,
        "tags": tags,
        "likes": [],
        "community": "Programming",
        "public": true,
        "reports":[]
      });
    }

    batch.commit();
    if(mounted) {
      setState(() {
        tags.clear();
      });
    }
    if (mounted) {
      setState(() {
        tags.clear();
        imageUrls = [];
        selectedImages = [];
      });
    }
  }
  void tagChange(String tag){
    setState(() {
      if(tags.contains(tag)){
        tags.remove(tag);
      }
      else{
        tags.add(tag);
      }
      print(tags);
    });
  }

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
      final selectedImage = File(pickedImage.path);
      selectedImages.add(selectedImage);
    });

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Align(
          child: TextButton(
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
              onPressed: _uploadTweet,
              child: Text(
                "post",
                style: TextStyle(color: Colors.black, fontSize: 20),
              )
          ),
        )
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
        child: Column(
          children: [
            Container(
              width: 400,
                height: 300,
                child: Form(
                  child: Column(
                    children: [
                      TextField(
                      controller: _newTweetController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: const InputDecoration(labelText: "make some noise..."),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: pickImage,
                            icon: Icon(Icons.image))),
                    ]
                  ),
                )
              ),
        Container(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: [
                      CategoryOptionWidget(tag: "Sports", tagChange: tagChange),
                      CategoryOptionWidget(tag: "politics", tagChange: tagChange),
                      CategoryOptionWidget(tag: "science", tagChange: tagChange),
                      CategoryOptionWidget(tag: "news", tagChange: tagChange),
                      CategoryOptionWidget(tag: "entertainment", tagChange: tagChange),
                      CategoryOptionWidget(tag: "casual", tagChange: tagChange),
                    ],
                  ),
              ),
            ],
          ),
          ),
    );
  }
}