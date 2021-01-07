import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/firebase.dart';
import 'package:flutter_app/grs.dart';
import 'package:flutter_app/ilkekran.dart';

import 'package:google_fonts/google_fonts.dart';
import 'bottom.dart';
import 'verilerigoster.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CommonThings {
  static Size size;
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(App());
}
FirebaseAuth _auth=FirebaseAuth.instance;
class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {

            return Scaffold(

              body: Center(
                child: Text("hata varrrr"+snapshot.error.toString()),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            if(_auth.currentUser!=null){

              return bottom();
            }else{
              return kullanici();
            }


          }


          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}