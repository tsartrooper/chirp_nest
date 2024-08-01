// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:social_app/models/Tweet.dart';
import 'package:social_app/screens/tweet_card.dart';

class TweetWidget extends StatelessWidget {
  final Map<String, dynamic> tweetData;
  String defaultProfileImageUrl = "https://media.istockphoto.com/id/2032619255/photo/laptop-education-and-a-student-black-woman-on-the-floor-of-a-living-room-to-study-for-a-test.webp?b=1&s=170667a&w=0&k=20&c=bEXCibUOAVHBwGhdq69mCDT3XipZK1TJCCJEOre1YTo=";


  TweetWidget.first({
    required this.tweetData,
  });


  String getDurationDifference(dynamic eventDateTime){
    DateTime now = DateTime.now();
    Duration difference = now.difference(eventDateTime);

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



  Widget build(BuildContext context) {
    final createdAt = tweetData["createdAt"].toDate();
    String durationDifference = getDurationDifference(createdAt);
    if(this.tweetData["tweet_text"] == null) {
      return Card(
          elevation: 10,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => TweetCard(tweetData: tweetData)));
            },
            child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    width: double.infinity,
                    height: 30,
                    child: Row(
                      children:[
                        // CircleAvatar(
                        //   radius: 10,
                        //   backgroundImage: NetworkImage(tweetData.keys.contains("userProfileImageUrl") ?
                        //   tweetData["userProfileImageUrl"]
                        //       : defaultProfileImageUrl),
                        // ),
                        SizedBox(width: 5,),
                        Text(
                      tweetData["username"],
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black54),),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                durationDifference
                            ),
                          ),
                        )
                    ])

                  ),
                  SizedBox(height: 1),
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 5),
                    child: Text(
                      tweetData["text"],
                      style: TextStyle(color: Colors.white),
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,),
                  ),
                ]
            ),
          )
      );
    }
    else{
      return Card(
        elevation: 10,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
                vertical: 6, horizontal: 5),
            child: Text(
              this.tweetData["tweet_text"]!,
              style: TextStyle(color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,),
          ),
        )
      );
    }
  }
}