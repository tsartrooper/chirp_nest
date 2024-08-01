import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/screens/user_profile_screen.dart';

class SearchResult extends StatelessWidget{
  final String search_value;
  SearchResult({required this.search_value});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: (){
          },
          child: Text(search_value),
        ),

      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users")
              .where("username", isEqualTo: search_value.toString())
              .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty? snapshot.docs.first : null),
          builder: (context,  AsyncSnapshot<DocumentSnapshot?> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(!snapshot.hasData || snapshot.data == null){
              return Center(
                child: Text("No user named $search_value",
                  style: TextStyle(color: Colors.black),),
              );
            }

            var user = snapshot.data!;
            print(search_value);
            return InkWell(
              onTap: (){
                Navigator.of(context)
                    .push(
                    MaterialPageRoute(
                        builder: (ctx) => UserProfile(
                            username: user["username"]
                        )
                    )
                );
              },
              child: ListTile(
                leading: Card(
                  child: Container(
                    alignment: Alignment.center,
                    width: 200,
                    height: 100,
                    child: Text(user["username"],
                    style: TextStyle(color: Colors.black),),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}