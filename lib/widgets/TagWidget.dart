import 'package:flutter/material.dart';

import '../screens/TagTweetsScreen.dart';

class TagWidget extends StatelessWidget{
  final String tag;
  const TagWidget({required this.tag});
  Widget build(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder:(ctx) => TagTweetsScreen(tag: tag)));
      },
      splashColor: Theme.of(context).primaryColor,
      child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.pink.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
          child: Text(tag,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          )
      ),
    );
  }


}