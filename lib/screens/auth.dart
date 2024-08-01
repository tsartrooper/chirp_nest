import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../widgets/UserImagePicker.dart';
final _firebase = FirebaseAuth.instance;


final _imagePicker = ImagePicker();

class AuthScreen extends StatefulWidget{

  const AuthScreen({super.key});

  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  final _formKey = GlobalKey<FormState>();

  String _enteredEmail = " ";
  String _enteredUserName = " ";
  String _enteredPassword = " ";
  bool _isLogin = true;
  bool _isAuthenticating = false;
  File? _selectedImage;


  Future<bool> isAvailable(String username) async{
    final querySnapShot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();

    return querySnapShot.docs.isEmpty;
  } // for checking availability of username across database


  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if(!isValid){
      return;
    }

    _formKey.currentState!.save();

    try{
      setState((){
        _isAuthenticating = true;
      });
      if(!_isLogin){
        final userCredentials = await _firebase.signInWithEmailAndPassword(
                                    email: _enteredEmail,
                                    password: _enteredPassword
                                );
      }
      else {
        bool available = await isAvailable(_enteredUserName);
        if(!available){
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("username already in use")
              ));
          setState(() {
            _isAuthenticating = false;
          });
          return;
        }
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection("users")
            .doc(userCredentials.user!.uid)
            .set({
          "userId": userCredentials.user!.uid,
          "username": _enteredUserName,
          "email": _enteredEmail,
          "followers": [],
          "following": [],
          "userProfileImageUrl": imageUrl,
        });
      }
    } on FirebaseAuthException catch (error){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message ?? 'Authentication failed')
          ));
    }
    finally {
      if(mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
    return;
  }


  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
          margin: EdgeInsets.only(top: 300, right: 30, left: 30),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(_isLogin)
                      UserImagePicker(onPickImage: (pickedImage){
                        _selectedImage = pickedImage;
                      }),
                    if(_isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "username"
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty || value.trim().length < 4){
                            return "please  enter a valid username";
                          }
                          return null;
                        },
                        onSaved: (value){
                          _enteredUserName = value!;
                        },
                      ),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email Address"
                        ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value){
                          if(value == null || value.isEmpty || !value.contains("@")){
                            return "please enter a valid email address";
                          }
                          return null;
                      },
                      onSaved: (value){
                          _enteredEmail = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Password"
                      ),
                      obscureText: true,
                      validator: (value){
                        if(value == null || value.isEmpty || value.trim().length < 6){
                          return "please  enter a valid password";
                        }
                        return null;
                      },
                      onSaved: (value){
                        _enteredPassword = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    if(!_isAuthenticating)
                      ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin? "Signup" : "Login")
                      ),
                    if(_isAuthenticating)
                      const CircularProgressIndicator(),
        
                    TextButton(onPressed: (){
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                    },
                        child: Text(
                            _isLogin
                            ? "already have an account"
                            : "create an account"))
                  ],
                ),
              ),
            ),
          ),
        ),
            ]),
      )
    );
  }
}