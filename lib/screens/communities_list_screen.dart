



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final currentUser = FirebaseAuth.instance.currentUser!.uid;

class CommunitiesList extends StatelessWidget{
  Widget build(BuildContext context){
    return Text("dljfb");
  }
  // Widget build(BuildContext context){
  //   return Scaffold(
  //   appBar: AppBar(title: Text("Communities"),
  //   actions: [
  //     IconButton(
  //       tooltip: "search communities",
  //         onPressed: (){}, icon: Icon(Icons.group_add)),
  //   ]
  //   ),
  //       body:
  //           StreamBuilder(
  //             stream: FirebaseFirestore.instance.collection("communities").snapshots(),
  //             builder: (ctx, communitiesSnapShot){
  //
  //             },
  //           )
  //   );
  // }
}