import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{

  Widget build(BuildContext context){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Icon(Icons.speaker_group_outlined,
        color: Colors.black,),
      )
    );
  }
}