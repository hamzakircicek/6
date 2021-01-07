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

import 'ilkekran.dart';
class profil extends StatefulWidget {
  @override
  _profilState createState() => _profilState();
}
FirebaseAuth _auth=FirebaseAuth.instance;
FirebaseFirestore _firestore=FirebaseFirestore.instance;


class _profilState extends State<profil> {
  String url;

  ProgressDialog progressDialog;
  File _secilenresimm;

  String kullaniciAdi = _auth.currentUser.displayName;
  String mail = _auth.currentUser.email;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Yükleniyor...');
    return Scaffold(
      backgroundColor: Colors.white,
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

                                _auth.currentUser.photoURL == null ? 'https://louisville.edu/enrollmentmanagement/images/person-icon/image' : _auth.currentUser.photoURL
                              ),
                              fit: BoxFit.cover,
                            )
                        ),

                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 100, left: 220),
                      child: InkWell(
                        onTap: () {

                         ayarla(context);

                        },
                        child: Container(
                          width: 50,
                          height: 50,

                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),

                          ),
                          child: Icon(Icons.settings, color: Colors.white,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
                SizedBox(height: 15,),
                Text("Kullanıcı Adı: $kullaniciAdi",
                  style: TextStyle(fontSize: 20),),
                SizedBox(height: 15,),
                Text("Mail: $mail", style: TextStyle(fontSize: 20),),
                SizedBox(height: 35,),
                Text("Verdiğin İlanlar", style: GoogleFonts.comfortaa(fontSize: 20),),
                SizedBox(height: 10,),
                StreamBuilder(
                stream: _firestore.collection('users').where("uid",isEqualTo: _auth.currentUser.uid).snapshots(),
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
                                  ),
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
                Text("Gelen Kiralama İstekleri",style: GoogleFonts.comfortaa(fontSize: 20)),
                SizedBox(height: 10,),
                StreamBuilder(
                  stream: _firestore.collection('istekler').where("sahipUid", isEqualTo: _auth.currentUser.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.data == null) return CircularProgressIndicator();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                     child: Padding(
                       padding: EdgeInsets.all(10),
                       child: Row(

                         children:
                           snapshot.data.docs.map((doc) => Stack(
                             children:[ Padding(
                               padding: EdgeInsets.only(right: 10),
                               child: InkWell(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>onay(url: doc['resim'], gonderenAd: doc['kullanici'],gunSayisi: "1",lokasyon: doc['lokasyon'],docId:doc['docId'],sahipUid: doc['sahipUid'],)));
                                 },
                                 child: Container(
                                   height: 150,
                                   width:125,
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(20),
                                     image: DecorationImage(
                                       image: NetworkImage(
                                                doc['resim']
                                       ),fit: BoxFit.cover

                                     )
                                   ),
                                   child: Padding(
                                     padding: EdgeInsets.only(top: 100),
                                     child: Container(
                                       width: MediaQuery.of(context).size.width,
                                       height: 50,
                                       decoration: BoxDecoration(
                                           color: Colors.black.withOpacity(0.5),
                                           borderRadius: BorderRadius.circular(20)
                                       ),

                                       child: Center(child: Text(doc['kullanici'],style: TextStyle(color: Colors.white),)),

                                     ),
                                   ),

                                 ),
                               ),
                             ),


                             ]
                           )).toList(),

                       ),
                     ),

                    );
                  },
                ),
                SizedBox(height: 25,),
                Text("Göderdiğim Kiralama İstekleri",style: GoogleFonts.comfortaa(fontSize: 20)),
                SizedBox(height: 10,),
                StreamBuilder(
                  stream: _firestore.collection('istekler').where("uid", isEqualTo: _auth.currentUser.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.data == null) return CircularProgressIndicator();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(

                          children:
                          snapshot.data.docs.map((doc) => Stack(
                              children:[ Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                    height: 150,
                                    width:125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                doc['resim']
                                            ),fit: BoxFit.cover

                                        )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 100),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(20)
                                        ),

                                        child: Center(child: Text(doc['sahipAd'],style: TextStyle(color: Colors.white),)),

                                      ),
                                    ),

                                  ),
                                ),
                              ),
                                Positioned(
                                  top: 5,
                                  left: 90,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(child: Icon(doc['onayDurumu']==false ? Icons.update : Icons.alarm_on,color: Colors.white.withOpacity(0.7),)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: doc['onayDurumu']==false ? Colors.grey.withOpacity(0.5) : Colors.green.withOpacity(0.5)
                                    ),

                                    ),

                                  ),



                              ]
                          )).toList(),

                        ),
                      ),

                    );
                  },
                ),
              ]
          )

        ],
      ),
    );
  }

  void galeriden(String foto) async {
    try {
      progressDialog.show();
      var resimm = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _secilenresimm = resimm;
      });

      Reference ref = FirebaseStorage.instance.ref().child("profil").child(foto);
      UploadTask uploadTask = ref.putFile(_secilenresimm);
      var r = await (await uploadTask).ref.getDownloadURL();

      debugPrint("Urlmizzzzzzzzzzzzzzzz:" + r);
      url = r;
      _auth.currentUser.updateProfile(photoURL: url);
      progressDialog.hide();
    } catch (e) {


    }
  }
  ayarla(context){
    return showDialog(context: context, builder: (context){
      return Center(
        child: Container(
          height: 130,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white.withOpacity(0.0)
          ),
          child: Material(
            borderRadius: BorderRadius.circular(25),
              color: Colors.white.withOpacity(0.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    galeriden(_auth.currentUser.displayName);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(1),
                        borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        "Profil Fotoğrafını Değiştir", style: TextStyle(color: Colors.white)
                      )
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    if(_auth.currentUser!=null){
                      _auth.signOut();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>kullanici()));
                      Toast.show("Çıkış Yaptınız", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(1),
                        borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                        child: Text(
                            "Çıkış Yap", style: TextStyle(color: Colors.white),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

    });
  }

}