import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/screens/user_profile_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/widgets/SearchWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';




class TweetCard extends StatefulWidget {
  final Map<String, dynamic> tweetData;

  TweetCard({required this.tweetData});

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  bool isLiked = false;
  int likeCount = 0;
  String defaultProfileImageUrl = "https://yt3.ggpht.com/DPboK53wY7N3TFVJTEQpFrIBhPvpTcSaxbN2z2xnu7WpPx9d7X6fBfRtFcisV0jkzQPWa0aUeg=s88-c-k-c0x00ffffff-no-rj";
  @override
  void initState() {
    super.initState();
    // Initialize like state and count here if needed
  }

  String getDurationDifference(DateTime eventDateTime) {
    final now = DateTime.now();
    final difference = now.difference(eventDateTime);

    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes == 1) {
      return '1 minute ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chirp"),
        actions: [SearchWidget()],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("tweets")
            .doc(widget.tweetData["tweetId"])
            .snapshots(),
        builder: (ctx, tweetSnapshot) {
          if (tweetSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!tweetSnapshot.hasData || tweetSnapshot.data == null) {
            return Center(child: Text("Tweet not found"));
          }

          final tweetData = tweetSnapshot.data!;
          final username = tweetData["username"] ?? "Unknown";
          final tweetContent = tweetData["text"] ?? "";
          final containsMedia = tweetData.data()!.containsKey("imageUrls");
          final List<String> mediaUrls = containsMedia ? List<String>.from(tweetData["imageUrls"]) : [];
          final createdAt = tweetData["createdAt"].toDate();
          final durationDifference = getDurationDifference(createdAt);
          String userProfileImageUrl = defaultProfileImageUrl;
          int likeCount = tweetData.data()!.keys.contains("likes")?  tweetData["likes"].length : 0;
          final  likesList = tweetData.data()!.keys.contains("likes")?  tweetSnapshot.data!["likes"] : [];
          isLiked = likesList.contains(currentUserId);
          if(tweetData.data()!.containsKey("userProfileImageUrl")){
            userProfileImageUrl = tweetData["userProfileImageUrl"];
          };

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UserProfile(username: username)));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userProfileImageUrl),
                          radius: 24,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(durationDifference),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    tweetContent,
                    style: TextStyle(fontSize: 16),
                  ),
                  if (mediaUrls.isNotEmpty)
                    SizedBox(height: 8.0),
                  if (mediaUrls.isNotEmpty)
                    CarouselSlider(
                      items: mediaUrls.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 200.0,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        autoPlay: false,
                      ),
                    ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                final batch = _firestore.batch();
                                isLiked = !isLiked;
                                likeCount += isLiked ? 1 : -1;
                                isLiked? batch.update(
                                     tweetData.reference, {"likes": FieldValue.arrayUnion([currentUserId])})
                                :  batch.update(tweetData.reference, {"likes": FieldValue.arrayRemove([currentUserId])});
                                batch.commit();
                              });
                            },
                          ),
                          Text('$likeCount')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
