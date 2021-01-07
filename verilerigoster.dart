import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/arkadaslar.dart';
import 'package:flutter_app/bildirim.dart';
import 'package:flutter_app/ilkekran.dart';
import 'package:flutter_app/istekGonderme.dart';
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

class goster extends StatefulWidget {
  String docal;
  var t;
  var kullanici;
  bool onayDrm=false;
  String bildirimlerim;


  goster({this.t, this.docal,this.kullanici});

  @override
  _gosterState createState() => _gosterState();
}
FirebaseAuth _auth=FirebaseAuth.instance;
int sayac=1;
int fyt;
int bildirimSay;
String text="1";
int limitSay;
int paylasimSay;
bool goruldu=false;



class _gosterState extends State<goster> with SingleTickerProviderStateMixin{



FirebaseFirestore _firestore= FirebaseFirestore.instance;
  int _sayi=0;
  int _sepetSayi=0;
  int _currentIndex=0;
  int paylasimSayisi;
  int getirilenler=8;
  String ensongetirilen;
  AnimationController controller;
  double y=0;
  TextEditingController txt=new TextEditingController();
  ProgressDialog progressDialog;
  TabController cont;




  Future<Null> refresh() async{

    await Future.delayed(Duration(seconds: 2));
  }
Map<String, dynamic> documentId;
@override
void initState() {
  super.initState();
  _firestore.collection('users').get().then((value) {
    paylasimSayisi = value.docs.length;
  });
  controller = AnimationController(vsync: this,
      duration: Duration(seconds: 5),
      lowerBound: 0,
      upperBound: 200);
  controller.addListener(() {
    setState(() {
      y = controller.value;
    });
    controller.forward();
  });
}


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Map<String, dynamic> veriler;


  @override
  Widget build(BuildContext context) {
    DocumentReference dc;


    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Yükleniyor...');
    return Scaffold(
      backgroundColor: Colors.white,

      body: RefreshIndicator(
        onRefresh: refresh,

        child: ListView(

            children: [ Column(
              children: [
                SizedBox(height: 10,),
                Text("Kategorini Belirle", style: GoogleFonts.raleway(
                    fontSize: 20, color: Colors.black.withOpacity(0.5)),),
                SizedBox(height: 5,),
                Container(
                  height: 90,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [ Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: InkWell(
                              onTap: () {

                              },
                              child: Container(

                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.green,


                                ),
                                child: Center(child: Text("Teknoloji",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),)),
                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.lightBlueAccent,


                              ),
                              child: Center(child: Text("Giyim",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),)),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.purpleAccent,


                              ),
                              child: Center(child: Text("Vasıta",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),)),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red,


                              ),
                              child: Center(child: Text("Emlak",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),)),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.teal,


                              ),
                              child: Center(child: Text("Takı",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),)),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.lightBlueAccent,


                              ),
                              child: Center(child: Text("Kitap",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),)),
                            ),

                          ),


                        ],
                      ),
                      ]
                  ),

                ),
                Divider(height: 5,),
                SizedBox(height: 15,),
                Text("Sevilen İlanlar", style: GoogleFonts.raleway(
                    fontSize: 20, color: Colors.black.withOpacity(0.5)),),
                SizedBox(height: 5,),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users')
                        .limit(getirilenler)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null)
                        return Center(
                            child: Center(child: CircularProgressIndicator()));
                      return
                        Container(
                          height: 400,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot dsnap = snapshot.data
                                    .docs[index];


                                return Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 7),
                                      child: Column(
                                        children: [
                                          Stack(
                                              children: [ Hero(
                                                tag: dsnap['resim'],
                                                child: Material(
                                                  color: Colors.white,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  dty(
                                                                    url: dsnap['resim'],
                                                                    ad: dsnap['ad'],
                                                                    aciklama: dsnap['aciklama'],
                                                                    lokasyon: dsnap['lokasyon'],
                                                                    fiyat: dsnap['fiyat'],)));
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.all(7),
                                                      height: 250,
                                                      width: 175,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                dsnap['resim']
                                                            ), fit: BoxFit.cover
                                                        ),
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            10),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: 55,

                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(10),
                                                              gradient: LinearGradient(
                                                                  begin: FractionalOffset
                                                                      .topCenter,
                                                                  end: FractionalOffset
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors
                                                                        .black,
                                                                    Colors
                                                                        .transparent
                                                                  ]

                                                              ),
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (dsnap['uid'] ==
                                                                    _auth
                                                                        .currentUser
                                                                        .uid) {
                                                                  Navigator
                                                                      .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (
                                                                              context) =>
                                                                              profilim()));
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (
                                                                              context) =>
                                                                              profilark(
                                                                                pp: dsnap['pp'],
                                                                                email: dsnap['email'],
                                                                                uid: dsnap['uid'],
                                                                                kuladi: dsnap['kullanici'],)));
                                                                }
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .all(7),
                                                                    height: 30,
                                                                    width: 30,
                                                                    decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(
                                                                              dsnap['pp']
                                                                          ),
                                                                          fit: BoxFit
                                                                              .cover
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          60),
                                                                    ),

                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Container(
                                                                    width: 100,
                                                                    child: Row(
                                                                      children: [
                                                                        Flexible(
                                                                            child: RichText(
                                                                              overflow: TextOverflow
                                                                                  .ellipsis,
                                                                              strutStyle: StrutStyle(
                                                                                  fontSize: 12.0),
                                                                              text: TextSpan(
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white),
                                                                                  text: dsnap['kullanici']),
                                                                            )

                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              ]
                                          ),
                                          SizedBox(height: 5,),
                                          Text(dsnap['fiyat'] + " TL",
                                            style: GoogleFonts.righteous(
                                                fontSize: 15,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold),),
                                          SizedBox(height: 10,),
                                          Container(

                                              width: 175,
                                              child: Row(

                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Flexible(

                                                      child: RichText(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        strutStyle: StrutStyle(
                                                            fontSize: 12.0),
                                                        text: TextSpan(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            text: dsnap['aciklama']),
                                                      )),
                                                ],
                                              )),


                                          SizedBox(height: 10,),
                                          Text("Tarih", style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10),),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 60,
                                                child: OutlineButton(
                                                  onPressed: () {
                                                    sepet(
                                                        dsnap['uid'],
                                                        dsnap['email'],
                                                        dsnap['pp'],
                                                        dsnap['kullanici'],
                                                        dsnap['ad'],
                                                        widget.docal,
                                                        dsnap['resim'],
                                                        dsnap['aciklama'],
                                                        dsnap['lokasyon'],
                                                        dsnap['fiyat']);
                                                    Toast.show(
                                                        "Ürün Sepete Eklendi",
                                                        context,
                                                        duration: Toast
                                                            .LENGTH_LONG,
                                                        gravity: Toast
                                                            .BOTTOM);
                                                  },
                                                  child: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.green,),
                                                  borderSide: BorderSide(
                                                      color: Colors.green
                                                          .shade200),
                                                  shape: StadiumBorder(),

                                                ),
                                              ),
                                              SizedBox(width: 15,),
                                              Container(
                                                height: 30,
                                                width: 60,
                                                child: OutlineButton(
                                                  onPressed: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                istekGonder(
                                                                  url: dsnap['resim'],
                                                                  kullanici: dsnap['kullanici'],
                                                                  aciklama: dsnap['aciklama'],
                                                                  fiyat: dsnap['fiyat'],
                                                                  ad: dsnap['ad'],
                                                                  lokasyon: dsnap['lokasyon'],
                                                                  uid: dsnap['uid'],
                                                                  docId: dsnap
                                                                      .id
                                                                      .toString() +
                                                                      _auth
                                                                          .currentUser
                                                                          .email,)));
                                                  },

                                                  child: Center(child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.orange,)),
                                                  borderSide: BorderSide(
                                                      color: Colors.orange
                                                          .shade200),
                                                  shape: StadiumBorder(),

                                                ),
                                              )

                                            ],
                                          ),

                                        ],
                                      ),

                                    ),
                                  ],
                                );
                              }
                          ),
                        );
                    }),
                Divider(height: 5,),
                SizedBox(height: 10,),
                Text("Göz Attıkların", style: GoogleFonts.raleway(
                    fontSize: 20, color: Colors.black.withOpacity(0.5)),),
    StreamBuilder(
    stream: FirebaseFirestore.instance.collection('aramalar').where('uid', isEqualTo: _auth.currentUser.uid)

        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null)
    return Container(
     height: 200,
     color: Colors.white,
      child: Center(child: Text("Henüz Bir Arama Yapmadın",style: TextStyle(color: Colors.black87),)),
    );
    return Container(
                  height: 200,
                  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    physics: AlwaysScrollableScrollPhysics(),
    itemCount: snapshot.data.docs.length,
    itemBuilder: (BuildContext context, int index) {
      DocumentSnapshot dsnap = snapshot.data
          .docs[index];


      return

        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14,),
              child: Container(

                height: 175,
                width: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(

                      dsnap['resim']==null? "https://cdn1.iconfinder.com/data/icons/user-interface-vol-1-12/68/folder_empty_add_sharing_data_search_zoom_magnifier-512.png":dsnap['resim']
                    ),fit: BoxFit.cover
                  )


                ),
              ),

            ),


          ],
        );
      }

       ));
    }),


                Divider(height: 5,),
                SizedBox(height: 15,),
                Text("Yakınınızdaki İlanlar", style: GoogleFonts.raleway(
                    fontSize: 20, color: Colors.black.withOpacity(0.5)),),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [ Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,


                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.orange,


                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.purpleAccent,


                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.lightBlueAccent,


                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey,


                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green,


                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14,),
                            child: Container(

                              height: 175,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.orange,


                              ),
                            ),

                          ),

                        ],
                      ),
                      ]
                  ),

                ),


              ],
            ),
            ]
        ),
      ),


    );
  }


  void sepet(String uid, String email, String pp, String kulad, String ad,
      String doc, var res, String aciklama, String lokasyon,
      String fiyat) async {
    try {
      Map<String, dynamic> aktar = Map();
      aktar['uid'] = uid;
      aktar['pp'] = pp;
      aktar['email'] = email;
      aktar['kullanici'] = kulad;
      aktar['ad'] = ad;
      aktar['resim'] = res;
      aktar['aciklama'] = aciklama;
      aktar['lokasyon'] = lokasyon;
      aktar['fiyat'] = fiyat;

      await _firestore.collection(_auth.currentUser.uid).doc().set(
          aktar, SetOptions(merge: true));
    }
    catch (e) {
      debugPrint(e);
    }
  }




}

