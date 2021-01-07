import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/detay.dart';
import 'package:flutter_app/onay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'mesaj.dart';
class bildirimler extends StatefulWidget {
  bool bilSay=false;

  bildirimler({this.bilSay});
  @override
  _bildirimlerState createState() => _bildirimlerState();
}
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore _firestore=FirebaseFirestore.instance;

class _bildirimlerState extends State<bildirimler> {
  var deger;
  var docDeger;
  int i;
  DocumentReference docRef;
@override
void initState(){
  super.initState();
_firestore.collection('bildirimler').where("karsiUid", isEqualTo: _auth.currentUser.uid).get().then((value) {
  for(deger in value.docs){


    _firestore.collection('bildirimler').doc(deger.data()['doc'].toString()).update({'gormeDurumu':true});
  }




});




}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            )
        ),
      body: StreamBuilder(
        stream: _firestore.collection('bildirimler').where("karsiUid",isEqualTo: _auth.currentUser.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.data==null){return Center(child: CircularProgressIndicator());

          }

          return ListView(

            children:[ Column(
              children:
              snapshot.data.docs.map((doc) {
                if(doc['istekDurumu']==true){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(

                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  Colors.blueGrey.withOpacity(0.6),
                      ),

                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(doc['kullanici']+' Yayınladığın Bir Ürünü Kiralamak İstiyor',
                              style: TextStyle(color: Colors.white,fontSize: 12),),
                            IconButton(icon: Icon(Icons.add_alert,size: 25, color: Colors.white,),
                                onPressed: (){


                                })
                          ]),

                    ),
                  );
                }

                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      color: doc['onayDurumu']==false  ? Colors.red.withOpacity(0.6) : Colors.green.withOpacity(0.6),
                  ),

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                  Text(doc['onayDurumu']==false  ? doc['kullanici']+' senin kiralama isteğini reddetti' : doc['kullanici']+' senin kiralama isteğini kabul etti',
                    style: TextStyle(color: Colors.white),),
                    IconButton(icon: doc['onayDurumu']==true ? Icon(Icons.message_outlined,size: 25, color: Colors.white,) : Icon(Icons.cloud_off,size: 25, color: Colors.white,),
                        onPressed: (){
                        if(doc['onayDurumu']==true){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>mesajSayfa(kullanici: doc['kullanici'], karsiUid: doc['karsiUid'],uid: doc['uid'],)));

                          Toast.show("Mesaj Gönderebilirsiniz.", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
                        }else{
                          Toast.show(doc['kullanici']+" senin isteğini reddettiği için mesaj gönderemezsin.", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
                        }

                    })
                  ]),

                ),
              );}

              ).toList()

            ),
              ]
          );
        }
      ),
    );

  }


}

