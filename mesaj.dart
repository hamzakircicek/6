import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/mesajSayfa.dart';
import 'package:toast/toast.dart';
class mesajSayfa extends StatefulWidget {
  String kullanici;

  String karsiUid;
  String uid;
  mesajSayfa({this.kullanici,this.karsiUid, this.uid});
  @override
  _mesajSayfaState createState() => _mesajSayfaState();
}
String e;
bool ben=false;
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;

class _mesajSayfaState extends State<mesajSayfa> {
  String email=_auth.currentUser.email;
  @override
  void initState(){
    super.initState();
   var a= _firestore.collection('bildirimler').get();
   a.then((value) {
     for(var t in value.docs){
       e=t.data()['karsiUid'].toString();

     }
   });
   debugPrint("aaaaaaaaaa"+e);

  }

  TextEditingController txt=new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          )
      ),
      body: ListView(
        children:[ Column(
          children:[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text(widget.kullanici),
              ),
            ),

             StreamBuilder(

            stream: _firestore.collection('mesaj').where("uid", isEqualTo: _auth.currentUser.uid ).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.data==null){return CircularProgressIndicator();}

              return Container(
                height: 420,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(

                    children: snapshot.data.docs.map((doc) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 40,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: doc['uid']==_auth.currentUser.uid ? Colors.green : Colors.blueGrey
                          ),
                          child: Center(
                            child: Text(
                              doc['icerik'], style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ),
                    )

                        ).toList(),
                  )
                ),
              );
            },
          ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  width: 250,

                  child: TextField(

                    controller: txt,

                  )
                ),
                SizedBox(width: 10,),
                IconButton(icon: Icon(Icons.send), onPressed: (){

                     mesajj(_auth.currentUser.email,ben, _auth.currentUser.uid, e, txt.text,widget.kullanici);
                     setState(() {

                       txt.text="";

                     });

                })
              ],
            ),


    ]
        ),
    ]
      )
    );
  }
  void mesajj(String gonderenEmail,bool onayDurumu,String uid,String karsiUid,String icerik,String kullanici) async{
    try{

      Map<String, dynamic> aktar= Map();
      aktar['gonderenEmail']=gonderenEmail;
      aktar['onayDurumu']=onayDurumu;
      aktar['uid']=uid;
      aktar['karsiUid']=karsiUid;
      aktar['icerik']=icerik;
      aktar['kullanici']=kullanici;
      await _firestore.collection('mesaj').doc().set(aktar, SetOptions(merge: true));

    }catch(e){
      debugPrint(e);
    }
  }

}
