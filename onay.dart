import 'package:flutter/material.dart';
import 'package:flutter_app/profilim2.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/detay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bottom.dart';
import 'profil.dart';
class onay extends StatefulWidget {
  String url;
  String aciklama;
  String gonderenAd;
  String gunSayisi;
  String lokasyon;
  String kullanici;
  String sahipUid;
  String docAl;
  var docId;
  bool onayDurumu=false;

  onay({this.url,this.aciklama,this.gonderenAd,this.gunSayisi,this.lokasyon,this.docId,this.sahipUid});
  @override
  _onayState createState() => _onayState();
}
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;

class _onayState extends State<onay> {
  bool _gormeDurumu=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('istekler').where("docId", isEqualTo: widget.docId ).where("kullanici",isEqualTo: widget.gonderenAd).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.data == null) return CircularProgressIndicator();
          return SingleChildScrollView(
              child: Column(
                  children:
              snapshot.data.docs.map((doc) => Column(
                children: [
                  Container(
                    height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        doc['resim']
                      ),fit: BoxFit.cover
                    )
                  ),
          ),
                    SizedBox(height: 15,),
                    Text('Kiralama İsteği Gönderen: '+doc['kullanici']),
                    SizedBox(height: 15,),
                  Text('Kiralamak İstediği Gün Sayısı: '+doc['gunSayisi']),
                  SizedBox(height: 15,),
                  Text('Toplam Fiyat: '+doc['fiyat']+" TL"),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[ RaisedButton(onPressed: (){
                      _firestore.collection('istekler').doc(doc.id).delete();
                      Toast.show("İstek Reddedildi", context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                      setState(() {
                        widget.onayDurumu=false;
                        widget.docAl=doc.id.toString();
                      });
                      bildirim(_gormeDurumu,widget.onayDurumu, widget.sahipUid, doc['uid'], doc['sahipAd'],widget.docAl+doc['uid'],false);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));

                    },color: Colors.red,
                      child: Text("Reddet",style: TextStyle(color: Colors.white),),



                    ),
                      SizedBox(width: 15,),
                      RaisedButton(onPressed: (){

                        Toast.show("İstek Kabul Edildi", context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                        setState(() {
                          widget.onayDurumu=true;
                            widget.docAl=doc.id.toString();


                          DocumentReference docRef= FirebaseFirestore.instance.collection('istekler').doc(doc.id);
                          Map<String, dynamic> aktar= Map();
                          aktar['onayDurumu']=true;
                          docRef.set(aktar, SetOptions(merge: true));


                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));


                        bildirim(_gormeDurumu,widget.onayDurumu, widget.sahipUid,doc['uid'], doc['sahipAd'],widget.docAl+doc['uid'],false);


                      },color: Colors.green,
                        child: Text("Kabul Et",style: TextStyle(color: Colors.white),),



                      ),
                ]
                  )

                ],
              ),


              ).toList(),

          )
          );

        }
    ),

    );
  }
  void bildirim(bool gormeDurumu,bool onayDurumu,String uid,String karsiUid,String kulad,String dcal,bool istekDurumu) async{
    try{

      Map<String, dynamic> aktar= Map();
      aktar['gormeDurumu']=gormeDurumu;
      aktar['onayDurumu']=onayDurumu;
      aktar['uid']=uid;
      aktar['karsiUid']=karsiUid;
      aktar['kullanici']=kulad;
      aktar['doc']=dcal;
      aktar['istekDurumu']=istekDurumu;


      await _firestore.collection('bildirimler').doc(dcal).set(aktar, SetOptions(merge: true));

    }catch(e){
    }
  }
}
