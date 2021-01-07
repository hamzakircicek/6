import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_app/bildirim.dart';
import 'package:flutter_app/mesajSayfa.dart';

import 'package:flutter_app/profil.dart';

import 'package:flutter_app/verilerigoster.dart';
import 'arama.dart';
import 'firebase.dart';

import 'package:google_fonts/google_fonts.dart';

import 'sepet.dart';
import 'package:firebase_auth/firebase_auth.dart';


class bottom extends StatefulWidget {

  @override
  _bottomState createState() => _bottomState();


}

final tabs=[
  goster(),
  verigonder(),
  arama(),
  profil()

];
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;


class _bottomState extends State<bottom> {
  @override
  void initState(){
    super.initState();


    _firestore.collection('bildirimler').where("karsiUid", isEqualTo: _auth.currentUser.uid).where("gormeDurumu", isEqualTo: false).snapshots().listen((event) {
      setState(() {
        _sayi=event.docs.length;
      });





    });
    _firestore.collection(_auth.currentUser.uid).snapshots().listen((event) {
      setState(() {
        _sepetSayi=event.docs.length;
      });

    });

  }

  int msjSayi=0;
  int _sayi=0;
  int _sepetSayi=0;
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {

    return
    Scaffold(

    appBar: AppBar(
      automaticallyImplyLeading: false,

      title: Text(
        "Kira'La",
        style: GoogleFonts.comfortaa(fontSize: 25,color: Colors.blueGrey,),
      ),
      actions: [
        Stack(children:[
          IconButton(icon: Icon(Icons.add_alert,color: Colors.blueGrey,), onPressed:()=>
            Navigator.push(context, MaterialPageRoute(builder: (context)=>bildirimler()))
          ),

          Positioned(
            left: 23, top: 10,
            child: Container(
              width:_sayi== 0 ? 0:13,
              height:_sayi== 0 ? 0:13,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)


              ),
              child: Center(child: Text(_sayi.toString()== "0" ? "": _sayi.toString(),style: TextStyle(fontSize: 8),)),
            ),
          )


        ],),
        Stack(children:[
          IconButton(icon: Icon(Icons.add_shopping_cart_rounded,color: Colors.blueGrey,), onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>sepetim()));
          }),

          Positioned(
            left: 23, top: 10,
            child: Container(
              width:_sepetSayi== 0 ? 0:13,
              height:_sepetSayi== 0 ? 0:13,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)


              ),
              child: Center(child: Text(_sepetSayi.toString()== "0" ? "": _sepetSayi.toString(),style: TextStyle(fontSize: 8),)),
            ),
          )


        ],),

        Stack(children:[
          IconButton(icon: Icon(Icons.maps_ugc_outlined ,color: Colors.blueGrey,), onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>mesajSayfasi()));
          }),

          Positioned(
            left: 23, top: 10,
            child: Container(
              width:msjSayi== 0 ? 0:13,
              height:msjSayi== 0 ? 0:13,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)


              ),
              child: Center(child: Text(msjSayi.toString()== "0" ? "": msjSayi.toString(),style: TextStyle(fontSize: 8),)),
            ),
          )


        ],),
      ],

      elevation: 0,
      backgroundColor: Colors.white,
    ),

    body: tabs[_currentIndex],




    bottomNavigationBar: BottomNavigationBar(
      currentIndex:_currentIndex,

      iconSize: 25,


      selectedFontSize: 0,
     type: BottomNavigationBarType.fixed,


      items: [
        BottomNavigationBarItem(
          icon: Icon(_currentIndex==0?Icons.home_filled :Icons.home_outlined,color:Colors.blueGrey.withOpacity(0.9),size: 27,),

            backgroundColor: Colors.white,
          label: "",

        ),
        BottomNavigationBarItem(
          icon: Icon(_currentIndex==1?Icons.add_box_rounded:Icons.add_box_outlined,color:Colors.blueGrey.withOpacity(0.9),size: 27,),
          backgroundColor: Colors.white,
          label: "",

        ),
        BottomNavigationBarItem(
          icon: Icon(_currentIndex==2?Icons.saved_search:Icons.search,color:Colors.blueGrey.withOpacity(0.9),size: 27,),
          label: "",
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(_currentIndex==3?Icons.person:Icons.person_outline,color:Colors.blueGrey.withOpacity(0.9),size: 27,),
          label: "",
          backgroundColor: Colors.white,
        ),

      ],
      onTap: (index){
        setState(() {
          _currentIndex=index;
        });
      },
    ),

    );


  }
}
