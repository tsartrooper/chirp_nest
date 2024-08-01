import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_app/screens/tabs.dart';
import 'firebase_options.dart';

import 'package:social_app/screens/auth.dart';
import 'package:social_app/screens/home_screen.dart';
import 'package:social_app/screens/splash_screen.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return SplashScreen();
          }
          if(snapshot.hasData){
            return Tabs();
          }
          return AuthScreen();
        }
      )
    );
  }
}