import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
class dty extends StatefulWidget {
  var url;
  String ad;
  String aciklama;
  String fiyat;
  String lokasyon;


  dty({this.url,this.ad,this.aciklama,this.fiyat,this.lokasyon});
  @override
  _dtyState createState() => _dtyState();
}
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore _firestore=FirebaseFirestore.instance;
int sayac=1;
class _dtyState extends State<dty> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
            children:[
              Hero(tag: widget.url, child:
              Container(
              width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.url),fit: BoxFit.cover,
                  )
                ),

            ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.3),
              ),
              Positioned(
                top: 475,
                right: 10,
                left: 10,
                child: Container(
                  width: 430,
                  height: 200,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children:[ Container(


                            width: 160,
                            height: 150,

                            child: ListView(
                              children: [

                                Text(widget.ad,style: GoogleFonts.comfortaa(fontSize: 15, decoration: TextDecoration.none,color: Colors.blueGrey ),),
                                SizedBox(height: 10,),
                                Text(widget.aciklama,style: GoogleFonts.comfortaa(fontSize: 15, decoration: TextDecoration.none,color: Colors.blueGrey),),
                                SizedBox(height: 10,),
                                Text(widget.fiyat,style: GoogleFonts.comfortaa(fontSize: 15, decoration: TextDecoration.none,color: Colors.blueGrey),),
                                SizedBox(height: 10,),
                                Text(widget.lokasyon,style: GoogleFonts.comfortaa(fontSize: 15, decoration: TextDecoration.none,color: Colors.blueGrey),),
                                SizedBox(height: 10,),


                              ],
                            ),
                          ),
                            SizedBox(width: 10,),

      ]
                        ),
                      ),


                    ],
                  ),
                ),

              ),
              Positioned(
                  top: 410,
                  left: 10,
                  child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
              ))
            ]
        ),

    );
  }
}

