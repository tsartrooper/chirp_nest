


import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/screens/communities_list_screen.dart';

import 'package:social_app/screens/home_screen.dart';
import 'package:social_app/screens/upload_sreen.dart';
import 'package:social_app/screens/search_screen.dart';

import 'explore_screen.dart';

class Tabs extends StatefulWidget{
  State<Tabs> createState(){
    return _TabsState();
  }
}

class _TabsState extends State<Tabs>{
  int pageIndex = 0;

  selectPageIndex(int index){
    setState(() {
      pageIndex = index;
    });
  }



  Widget build(BuildContext context){
      Widget activePage =  HomeScreen();
      if(pageIndex == 1){
      activePage = ExploreScreen();
      }
      else if (pageIndex == 2){
      activePage = UploadScreen();
      }else if(pageIndex == 3){
        activePage = CommunitiesList();
      }
    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPageIndex,
        fixedColor: Colors.red,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label:"explore"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "post"),
          BottomNavigationBarItem(icon: Icon(Icons.group_work_outlined), label: "communities")
        ],
        currentIndex: pageIndex,
      ),
    );
  }
}