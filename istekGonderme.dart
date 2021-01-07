import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/arkadaslar.dart';
import 'package:flutter_app/bildirim.dart';
import 'package:flutter_app/bottom.dart';
import 'package:flutter_app/ilkekran.dart';
import 'package:flutter_app/mesaj.dart';
import 'package:flutter_app/mesajSayfa.dart';
import 'package:flutter_app/profil.dart';
import 'package:flutter_app/profilim2.dart';

import 'arama.dart';
import 'firebase.dart';
import 'detay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'sepet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
class istekGonder extends StatefulWidget {
  var url;
  String kullanici;
  String aciklama;
  String fiyat;
  String ad;
  String lokasyon;
  String uid;
  String docId;
  istekGonder({this.url,this.kullanici,this.aciklama,this.fiyat,this.ad,this.lokasyon,this.uid,this.docId});

  @override
  _istekGonderState createState() => _istekGonderState();
}

FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;


class _istekGonderState extends State<istekGonder> {
  bool onayDurumu=false;
  int sayac=1;
  int fiyat;
  int sonFiyat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.blueGrey

        ),
       leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
       })
      ),
      body:ListView(
          children:[ Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height:250 ,
            decoration: BoxDecoration(
                image: DecorationImage(

                    image: NetworkImage(
                        widget.url
                    ),fit:BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(25)
            ),
          ),
            SizedBox(height: 10,),
            Center(child: Text('Ürün Açıklaması',style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.grey, decoration: TextDecoration.none,),)),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(right: 10,left: 10),
              width: 250,
              height:60 ,
              child: ListView(children:[
                Center(child:
                Text(widget.aciklama, style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blueGrey, decoration: TextDecoration.none,),),

                )]) ,
            ),
            SizedBox(height: 10,),
            Center(child: Text('Ürün Fiyatı',style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.grey, decoration: TextDecoration.none,),)),

            Container(
              margin: EdgeInsets.all(10),
              width: 350,

              height:25,
              child: Center(child: Text(sayac==1?widget.fiyat:sonFiyat.toString(), style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blueGrey, decoration: TextDecoration.none,),)) ,
            ),
            Center(child: Text('Kiralamak İstediğin Gün Sayısı',style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.grey, decoration: TextDecoration.none,),)),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: (){
                        if(sayac>1){
                          setState(() {
                            sayac--;
                            fiyat=int.parse(widget.fiyat);
                            sonFiyat=sayac*fiyat;

                          });
                        }

                      },
                    ),

                  ),
                  SizedBox(width: 10,),

                  Container(
                    width: 50,
                    child:  Center(
                      child: Text(
                          sayac.toString(),
                      ),
                    ),

                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: (){

                        setState(() {

                          sayac++;
                          fiyat=int.parse(widget.fiyat);
                          sonFiyat=sayac*fiyat;


                        });

                      },
                    ),

                  ),
                ],
              ),

            ),
            SizedBox(height: 15,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
                  },
                  child: Container(
                    width: 130,
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [ Colors.red,Colors.pinkAccent]

                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Text("Vazgeç",style: GoogleFonts.comfortaa(fontSize: 14,color: Colors.white),)),

                  ),
                ),
                SizedBox(width: 15,),
                InkWell(
                  onTap: (){
                    siparis(widget.ad,sayac.toString(),widget.kullanici,_auth.currentUser.uid, _auth.currentUser.email, _auth.currentUser.photoURL, _auth.currentUser.displayName, widget.url ,widget.aciklama, widget.lokasyon,sonFiyat.toString(),widget.uid,
                        widget.docId, onayDurumu);
                    bildirim(false, onayDurumu, _auth.currentUser.uid, widget.uid, _auth.currentUser.displayName, widget.docId,true);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
                    Toast.show(
                        "Kiralama İsteğiniz Gönderildi",
                        context,
                        duration: Toast
                            .LENGTH_LONG,
                        gravity: Toast
                            .BOTTOM);
                  },
                  child: Container(
                  width: 130,
                  height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [ Colors.cyanAccent,Colors.green]

                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                  child: Center(child: Text("Gönder",style: GoogleFonts.comfortaa(fontSize: 14,color: Colors.white),)),

                  ),
                ),


              ],
            )



          ]
      )
    );
  }
  void siparis(String urunAd,String gunSayisi,String sahipAd,String uid,String email,String pp,String kulad, var res, String aciklama,String lokasyon, String fiyat,String sahipUid,docId,onayDurumu) async{
    try{

      Map<String, dynamic> aktar= Map();
      aktar['urunAd']=urunAd;
      aktar['gunSayisi']=gunSayisi;
      aktar['sahipAd']=sahipAd;
      aktar['uid']=uid;
      aktar['pp']=pp;
      aktar['email']=email;
      aktar['kullanici']=kulad;

      aktar['resim']=res;
      aktar['aciklama']=aciklama;
      aktar['lokasyon']=lokasyon;
      aktar['fiyat']=fiyat;
      aktar['sahipUid']=sahipUid;
      aktar['docId']=docId;
      aktar['onayDurumu']=onayDurumu;
      await _firestore.collection('istekler').doc(docId).set(aktar, SetOptions(merge: true));

    }
    catch(e){
      debugPrint(e);

    }

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
