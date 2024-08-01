import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/widgets/tweet_widget.dart';

class TagTweetsScreen extends StatelessWidget {
  final String tag;

  TagTweetsScreen({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweets for #$tag'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tweets')
              .where('tags', arrayContains: tag)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            }

            final tweets = snapshot.data?.docs;

            if (tweets == null || tweets.isEmpty) {
              return Center(child: Text('No tweets found for this tag.'));
            }

            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (ctx, index) {
                final tweetData = tweets[index].data() as Map<String, dynamic>;

                return TweetWidget.first(tweetData: tweetData);
              },
            );
          },
        ),
      ),
    );
  }
}
