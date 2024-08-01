import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/SearchWidget.dart';
import '../widgets/TagWidget.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExploreScreenState();
  }
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<String> tags = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  Future<void> fetchTags() async {
    try {
      QuerySnapshot tagsSnapshot = await FirebaseFirestore.instance.collection('tags').get();
      setState(() {
        tags = tagsSnapshot.docs.map((doc) => doc.id).toList();
        isLoading = false;
      });
    } catch (e) {
        error = "Error fetching tags: $e";
        isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [SearchWidget()],),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : tags.isEmpty
          ? Center(child: Text('No tags found'))
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: tags.length,
        itemBuilder: (ctx, index) {
          return TagWidget(tag: tags[index]);
        },
      ),
    );
  }
}
