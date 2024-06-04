import 'dart:async';
import 'package:chat_app_yt_shivam_gupta_may/screens/home.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBqisD9HSDxy0h48gtlds9BoHEW1pbsXRM',
    appId: '1:1086867901876:android:bb98ab14948b5ea16536e1',
    messagingSenderId: '1086867901876',
    projectId: 'chatapp-b19df',
    storageBucket: 'myapp-b9yt18.appspot.com',
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return SingIn();
            }
          },
          future: authMethods().getCurrentUser(),
        ));

    //   SingIn()
  }
}
