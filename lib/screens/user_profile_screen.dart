import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/widgets/tweet_widget.dart';

import '../providers/followers_provider.dart';

final currentUserIdProvider = Provider<String>((ref) => FirebaseAuth.instance.currentUser!.uid);

class UserProfile extends ConsumerWidget {
  final String username;

  UserProfile({required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users").where("username", isEqualTo: username).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("User data not available.");
                  }

                  final userData = snapshot.data!.docs[0];
                  final userId = userData["userId"];
                  final isFollowing = ref.watch(followersProvider).contains(userId);

                  return Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.pink],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        bottom: 0,
                        top: 70,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userData["userProfileImageUrl"] != null
                                      ? NetworkImage(userData["userProfileImageUrl"])
                                      : AssetImage('assets/placeholder.png') as ImageProvider,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  userData["username"],
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 30,),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(userData["followers"].length.toString()),
                                        Text("followers")
                                      ],
                                    ),
                                    SizedBox(width: 30,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(userData["following"].length.toString()),
                                        Text("following")
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            if (currentUserId != userId)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                                  foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                ),
                                onPressed: () async {
                                  if (isFollowing) {
                                    await ref.read(followersProvider.notifier).removeFollower(userId);
                                  } else {
                                    await ref.read(followersProvider.notifier).addFollower(userId);
                                  }
                                },
                                child: Text(isFollowing ? "Unfollow" : "Follow"),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tweets")
                    .where("username", isEqualTo: username)
                    .snapshots(),
                builder: (ctx, tweetSnapshot) {
                  if (tweetSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!tweetSnapshot.hasData || tweetSnapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No tweets available"));
                  }

                  final tweetsList = tweetSnapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tweetsList.length,
                    itemBuilder: (ctx, index) {
                      return TweetWidget.first(
                        tweetData: tweetsList[index].data() as Map<String, dynamic>,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
