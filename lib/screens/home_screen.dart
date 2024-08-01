import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:social_app/models/Tweet.dart';
import 'package:social_app/screens/tweet_card.dart';
import 'package:social_app/widgets/MainDrawer.dart';


import '../widgets/SearchWidget.dart';
import '../widgets/tweet_widget.dart';



class HomeScreen extends StatelessWidget{

  Widget build(BuildContext context) {

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text("home"),
      actions: [
        IconButton(
            onPressed:(){},
            icon: Icon(Icons.train_sharp)
        ),
        SearchWidget(), //search button
      ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users")
          .where("userId", isEqualTo: currentUserId)
          .snapshots(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(!snapshot.hasData || snapshot.data == null){
            return Center(
              child: Text("Ran into some issue",
                style: TextStyle(color: Colors.black),),
            );
          }
          if(!snapshot.data!.docs.first.exists){
            return Center(
              child: Text("Ran into some issue",
                style: TextStyle(color: Colors.black),),
            );
          }
          else {
            final userData = snapshot.data!.docs[0];
            final userFollowingData = List<String>.from(
                userData["following"] ?? []);
            if (userFollowingData.isEmpty) {
              return Center(
                child: Text("Your feed is empty, go follow someone!",
                  style: TextStyle(color: Colors.black),),
              );
            } else {
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("tweets").where(
                    "userId", whereIn: userFollowingData).snapshots(),
                builder: (ctx, tweetsSnapShots) {
                  if (tweetsSnapShots.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator()
                    );
                  }
                  if (!tweetsSnapShots.hasData ||
                      tweetsSnapShots.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No Tweets"),
                    );
                  }
                  if (tweetsSnapShots.hasError) {
                    return const Center(
                        child: Text("Oops Ran into some error")
                    );
                  }
                  final loadedTweets = tweetsSnapShots.data!.docs;
                  return ListView.builder(
                      itemCount: loadedTweets.length,
                      itemBuilder: (ctx, index) {
                        final followedTweet = loadedTweets[index].data();
                        print(loadedTweets[index].data()["text"]);
                        return TweetWidget.first(tweetData: followedTweet);
                      }
                  );
                },
              );
            }
          }
        }
    ),
      drawer: MainDrawer(),
    );
  }
}