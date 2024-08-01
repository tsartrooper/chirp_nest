import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/user_profile_screen.dart';



class MainDrawer extends StatelessWidget{
  Widget build(BuildContext context){
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Drawer(
        child: Column(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // Theme.of(context).colorScheme.primaryContainer,
                          // Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
                          Colors.red,
                          Colors.pink
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                  ),
                  child: Row(
                      children:[
                        Icon(Icons.speaker_group, size: 48,),
                        Text(
                          "ChirpNest",
                          style: TextStyle(color: Colors.black, fontSize: 25),),
                      ]
                  )
              ),
              ListTile(
                title: Text(
                    "profile",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary
                    )
                ),
                trailing: Icon(Icons.account_circle),
                onTap: () async{
                  final userDoc = await FirebaseFirestore.instance.collection("users").doc(currentUserId).get();
                  final username = userDoc.data()!["username"];
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(
                      MaterialPageRoute(
                          builder: (ctx) => UserProfile(username : username)
                      )
                  );
                },
              ),
              ListTile(
                  title: Text(
                      "log out",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,)),
                  trailing: Icon(Icons.logout_rounded),
                  onTap: (){
                    FirebaseAuth.instance.signOut();
                  }
              )
              // IconButton(onPressed: (){
              //   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => FilterScreen()));}, icon: Icon(Icons.settings))
            ]
        )
    );
  }


}