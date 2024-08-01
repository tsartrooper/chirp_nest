import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class SearchWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(
              MaterialPageRoute(
                  builder: (ctx) => SearchScreen()
              ));
        },
        icon: Icon(Icons.search)
    );
  }
}