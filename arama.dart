


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/profilim2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'arkadaslar.dart';
class arama extends StatefulWidget {



  @override
  _aramaState createState() => _aramaState();
}

final FirebaseFirestore _firestore= FirebaseFirestore.instance;
class _aramaState extends State<arama> {
  var url;
  String idd;
  String arm="";
@override
void initState() {
    // TODO: implement initState
    super.initState();
    _firestore.collection("user").snapshots().listen((event) {

      for(var t in event.docs){
        url=t.data()['resim'];
      }

    });
  }





  TextEditingController txt=new TextEditingController();
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

          return Scaffold(
            backgroundColor: Colors.white,


            body: ListView(
                children:[

            Column(
            children: [
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: TextField(
               controller: txt,
                 decoration: InputDecoration(

                   hintText: "Bir Ürün Arayın",
                   suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: (){





                     setState(() {
                       arm=txt.text;
                     });

                   }))
                 ),


            ),

              SizedBox(height: 10,),
              Divider(height: 10,),
              SizedBox(height: 10,),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("ad", isEqualTo: arm).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.data == null) return Center(child: CircularProgressIndicator());
                  snapshot.data.docs
                  .map((doc) {
                 url=doc['resim'];
                 idd=doc.id;
                      aranmalar(txt.text,_auth.currentUser.uid.toString(),url,idd );}).toList();

                  return Column(

                    children:

                    snapshot.data.docs
                        .map((doc) {



                      return Container(
                        color: Colors.white,
                        child:
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, right: 5, left: 5),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.all(15),
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    InkWell(

                                      onTap: () {
                                        if (_auth.currentUser.uid ==
                                            doc['uid']) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      profilim()));
                                        } else {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      profilark(pp: doc['pp'],
                                                        email: doc['email'],
                                                        uid: doc['uid'],
                                                        kuladi: doc['kullanici'],)));
                                        }
                                      },


                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              doc['pp'],
                                            ), fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 180,

                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          profilark(
                                                            pp: doc['pp'],
                                                            email: doc['email'],
                                                            uid: doc['uid'],
                                                            kuladi: doc['kullanici'],)));
                                            },
                                            child: Text(doc['kullanici'],
                                              style: GoogleFonts.comfortaa(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight
                                                      .bold),),),
                                          Text("Tarih", style: TextStyle(
                                              color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 42,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {


                                        })
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(children: [
                                  Stack(
                                      children: [ Material(
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: 170,
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  doc['resim'],
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                        ),

                                      ),

                                      ]
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      height: 150,

                                      child: ListView(


                                        children: [

                                          Text("Ürün Adı: ",
                                            style: GoogleFonts.alata(
                                                fontSize: 15,
                                                color: Colors.grey),),
                                          Text(doc['ad'],
                                              style: GoogleFonts.alata(
                                                  fontSize: 15)),

                                          SizedBox(height: 10,),
                                          Text("Lokasyon: ",
                                            style: GoogleFonts.alata(
                                                fontSize: 15,
                                                color: Colors.grey),),
                                          Text(doc['lokasyon'],
                                              style: GoogleFonts.alata(
                                                  fontSize: 15)),

                                          SizedBox(height: 10,),
                                          Text("Fiyat: ",
                                            style: GoogleFonts.alata(
                                                fontSize: 15,
                                                color: Colors.grey),),
                                          Text(doc['fiyat'],
                                              style: GoogleFonts.alata(
                                                  fontSize: 15)),

                                          SizedBox(height: 10,),
                                          Text("Açıklama: ",
                                            style: GoogleFonts.alata(
                                                fontSize: 15,
                                                color: Colors.grey),),
                                          Text(doc['aciklama'],
                                              style: GoogleFonts.alata(
                                                  fontSize: 15))


                                        ],
                                      ),
                                    ),
                                  ),


                                ]),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.all(15),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(

                                        onTap: () async {
                                          await _firestore.collection(
                                              _auth.currentUser.uid)
                                              .doc(doc.id)
                                              .delete();
                                          Toast.show("Ürün Sepetten Kaldırıldı",
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                        },

                                        child: Material(
                                          elevation: 5,
                                          borderRadius: BorderRadius.circular(
                                              15),
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(15),
                                              color: Colors.red.withOpacity(
                                                  0.7),
                                            ),
                                            child: Icon(
                                              Icons.delete, color: Colors.white,
                                              size: 20,),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                15),
                                            color: Colors.green.withOpacity(
                                                0.7),
                                          ),
                                          child: Icon(Icons.arrow_forward_ios,
                                            color: Colors.white, size: 20,),
                                        ),
                                      ),
                                    ],
                                  ),
                                )


                              ]),
                            ),


                          ),


                        ),


                      );


                    }
                    )
                        .toList());
    }),
                ]

            )

          ])
          );

  }
  void aranmalar(String a,String u,var r,String dc)async{
  try{
  Map <String, dynamic> arama=Map();
  arama['arama']=a;
  arama['uid']=u;
  arama['resim']=r;
  arama['docId']=dc;
  await _firestore.collection("aramalar").doc(idd).set(arama, SetOptions(merge: true)
  );
  }
  catch(e){

  }




  }
  void y(String h){
    h=txt.text;
  }
}
