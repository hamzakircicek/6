import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detay.dart';
class profilark extends StatefulWidget {
  String pp;
  String email;
  String uid;
  String kuladi;
  profilark({this.pp,this.email,this.uid,this.kuladi});
  @override
  _profilarkState createState() => _profilarkState();
}
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore _firestore=FirebaseFirestore.instance;


class _profilarkState extends State<profilark> {
  String url;

  ProgressDialog progressDialog;




  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Yükleniyor...');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        )
      ),
      body: ListView(
        children: [
          Column(
              children: [ Padding(
                padding: EdgeInsets.only(top: 35),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(

                                  widget.pp == null ? 'https://louisville.edu/enrollmentmanagement/images/person-icon/image' : widget.pp
                              ),
                              fit: BoxFit.cover,
                            )
                        ),

                      ),

                    ),

                  ],
                ),
              ),
                SizedBox(height: 15,),
                Text(widget.kuladi,
                  style: TextStyle(fontSize: 20),),
                SizedBox(height: 15,),
                Text(widget.email, style: TextStyle(fontSize: 20),),
                SizedBox(height: 25,),

                Text(widget.uid==_auth.currentUser.uid ? "Verdiğin İlanlar" : "Verdiği İlanlar", style: GoogleFonts.comfortaa(fontSize: 20),),
                SizedBox(height: 25,),
                StreamBuilder(
                    stream: _firestore.collection('users').where("uid",isEqualTo: widget.uid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.data == null) return CircularProgressIndicator();
                      return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:Row(
                            children:
                            snapshot.data.docs.map((doc) =>
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                      width: 220,
                                      height: 320,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: NetworkImage(doc['resim'],),fit: BoxFit.cover
                                          )
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top:240,
                                            right: 0,
                                            left: 0,


                                                child: InkWell(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>dty(url: doc['resim'],ad: doc['ad'],aciklama: doc['aciklama'],lokasyon: doc['lokasyon'],fiyat: doc['fiyat'],)));
                                                  },
                                                  child: Container(
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: Colors.black.withOpacity(0.5),
                                                      ),

                                                      child: Center(child: Text('Detay',style: GoogleFonts.comfortaa(color: Colors.white,fontSize: 20),))
                                                  ),
                                                )
                                            ),
                                          
                                        ],
                                      )
                                  ),
                                ),

                            ).toList(),

                          )
                      );
                    }
                ),
                SizedBox(height: 25,),


              ]
          )

        ],
      ),
    );
  }



}