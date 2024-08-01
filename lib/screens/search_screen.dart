import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/screens/search_result.dart';

class SearchScreen extends StatefulWidget{
  // ExploreScreen({this.entered_value = " "});
  @override
  State<SearchScreen> createState() {
    // TODO: implement createState
    return ExploreScreenState();
  }
}

class ExploreScreenState extends State<SearchScreen>{
  final _formKey = GlobalKey<FormState>();
  String entered_value = "";

  void _submit() async {
    _formKey.currentState!.save();
    print(entered_value);
    if(entered_value.trim().isEmpty){
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => SearchResult(
          search_value: entered_value.trim())
    )
    );
}


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 30,
        title: Container(
          width: 300,
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 45.0),
          child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  onSaved: (value){
                    print(value);
                      entered_value = value!;
                  },
                ),
              ]
          ),
                ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Button background color
                      foregroundColor: Colors.white, // Text color
                      ),
            onPressed:_submit,
            child: Text(
              "search",
              style: TextStyle(color: Colors.white),
            ),
                    ),
          ),
        ]
      )
    );
  }
}