
/*ListView(
        children: [Container(
          margin: EdgeInsets.all(50),
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: [
              TextField(
                controller: txt,
                decoration: InputDecoration(
                    hintText: "Ürün Adı gir"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: txt2,
                decoration: InputDecoration(
                    hintText: "Döküment Adı Gir"
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                controller: txt4,
                decoration: InputDecoration(
                    hintText: "İl/İlçe"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: txt5,
                decoration: InputDecoration(
                    hintText: "Günlük Kiralama Ücreti"
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: txt3,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                    hintText: "Ürün Açıklaması"
                ),
              ),

              InkWell(
                onTap: (){
                  veriekle(txt.text,txt2.text, url, txt3.text,txt4.text, txt5.text);

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> goster(t: url, docal: txt2.text,)));

                },
                child:

                Text("Veriyi Gönder"),
              ),
              //////////////////////////////////////////////////////////////////


              SizedBox(height: 50,),
              Row(
                children :[ InkWell(
                  onTap:
                  (){
                    galeriden(txt3.text);
                  }
                  ,
                  child: Container(
                    width: 150,
                    height: 150,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,

                    ),
                    child: Center(child: _secilenresim==null ? Text("Lütfen Galeriden Resim Seçin") : Image.file(_secilenresim, )),
                  ),

                ),

              SizedBox(width: 10,),
              InkWell(
                onTap:
                    (){
                  kameradan(txt3.text);
                }
                ,
                child: Container(
                  width: 150,
                  height: 150,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,

                  ),
                  child: Center(child: _kameradanresim==null ? Text("Lütfen Kameradan Resim Seçin") : Image.file(_kameradanresim, )),
                ),

              ),

                ]
              ),

            ],
          ),
        ),
    ]
      ),*/

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/sepet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom.dart';
import 'verilerigoster.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class verigonder extends StatefulWidget {
String kulad;
verigonder({this.kulad});

  @override
  _verigonderState createState() => _verigonderState();
}
FirebaseAuth _auth=FirebaseAuth.instance;
class _verigonderState extends State<verigonder> {

  ProgressDialog progressDialog;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;


  var pagescont=PageController();
  File _secilenresim;
  File _kameradanresim;
  TextEditingController txt= new TextEditingController();
  TextEditingController txt2= new TextEditingController();
  TextEditingController txt3= new TextEditingController();
  TextEditingController txt4= new TextEditingController();
  TextEditingController txt5= new TextEditingController();
  var url;
  int aktifstep=0;
  bool complete=false;
  bool hata=false;





  @override
  Widget build(BuildContext context) {

    progressDialog=ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Yükleniyor...');
    return Scaffold(
      backgroundColor: Colors.white,
        body:  ListView(
              children:[ Stepper(steps: tumadimlar(),
                currentStep: aktifstep,
                onStepContinue: next,

                onStepCancel: cancel,


              ),

              ]
          ),
        );





  }
  List <Step> tumadimlar(){

    List<Step> stepler=[

      Step(title: Text("Ürün Adı"),


          isActive: true,
          content: TextFormField(
            controller: txt,
            decoration: InputDecoration(

              hintText: "Ürün Adı Girin",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),

            ),
          )),

      Step(title: Text("Ürün Açıklaması"),

          isActive: true,
          content: TextFormField(
            controller: txt3,
            decoration: InputDecoration(

              hintText: "Ürün Açıklaması Girin",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),

            ),
          )
      ),
      Step(title: Text("Bulunduğunuz il"),

          isActive: true,
          content: TextFormField(
            controller: txt4,
            decoration: InputDecoration(

              hintText: "Bulunduğunuz ili Girin",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),

            ),
          )),
      Step(title: Text("Fiyat"),

          isActive: true,
          content: TextFormField(

            controller: txt5,
            decoration: InputDecoration(

              hintText: "Fiyat",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),

            ),



          )),
      Step(title: Text("Fotoğraf Ekle"),

          isActive: true,
          content:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ IconButton(icon: Icon(Icons.image_outlined, size: 45, ), onPressed: (){
                setState(() {
                  complete=true;
                });
                galeriden(txt3.text);
                _kameradanresim==null ? Text("Lütfen Galeriden Resim Seçin") :Image.file(_kameradanresim, );

              }),
                SizedBox(width: 35,),
                IconButton(icon: Icon(Icons.photo_camera, size: 45,), onPressed:(){
                  setState(() {
                    complete=true;
                  });
                  kameradan(txt3.text);
                  _secilenresim==null ? Text("Lütfen Galeriden Resim Seçin") :Image.file(_secilenresim, );


                })
              ]
          )
        /**/

      ),
    ];
    return stepler;
  }




  next(){
    if(aktifstep +1 != tumadimlar().length) {
      git(aktifstep +1);


    } else {

      if
      (url==null){


      } else{

        String a=_auth.currentUser.displayName;
        String pp=_auth.currentUser.photoURL;

          if(pp==null){
            pp='https://louisville.edu/enrollmentmanagement/images/person-icon/image';
            veriekle(_auth.currentUser.email.toString(),_auth.currentUser.uid.toString(),pp,a,txt.text, url, txt3.text, txt4.text, txt5.text,"0","0");

            Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
          }else{
            veriekle(_auth.currentUser.email.toString(),_auth.currentUser.uid.toString(),pp,a,txt.text, url, txt3.text, txt4.text, txt5.text,"0","0");

            Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
          }





      }





    }




  }
  cancel(){
    if(aktifstep>0){
      git(aktifstep-1);
    }
  }
  git(int step){
    setState(() {
      aktifstep=step;
    });
  }


  void veriekle (String email,String uid,String pp,String kul,String ad,  var res, String aciklama,String lokasyon, String fiyat,String puan,String oySay) async{

    try{
      Map<String, dynamic> hamza= Map();
      hamza['email']=email;
      hamza['uid']=uid;
      hamza['pp']=pp;
      hamza['kullanici']=kul;
      hamza['ad']=ad;
      hamza['resim']=res;
      hamza['aciklama']=aciklama;
      hamza['lokasyon']=lokasyon;
      hamza['fiyat']=fiyat;
      hamza['puan']=puan;
      hamza['oylamaSayisi']=oySay;

      await _firestore.collection("users").doc().set(hamza, SetOptions(merge: true));


    }
    catch(e){
      debugPrint(e);

    }


  }


  void kameradan(String foto)async{

    try{
      progressDialog.show();
      var reesim= await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);
      setState(() {
        _kameradanresim=reesim;
      });
      Reference ref=FirebaseStorage.instance.ref().child("user").child(foto);
      UploadTask uploadTask= ref.putFile(_kameradanresim);
      var r = await (await uploadTask).ref.getDownloadURL() ;

      debugPrint("Urlmizzzzzzzzzzzzzzzz:"+r);
      url=r;
      progressDialog.hide();}
    catch(e){

    }

  }


  void galeriden(String foto) async{
    try{
      progressDialog.show();
      var resimm= await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 25);
      setState(() {
        _secilenresim=resimm;
      });

      Reference ref=FirebaseStorage.instance.ref().child("user").child(foto);
      UploadTask uploadTask= ref.putFile(_secilenresim);
      var r = await (await uploadTask).ref.getDownloadURL() ;

      debugPrint("Urlmizzzzzzzzzzzzzzzz:"+r);
      url=r;
      progressDialog.hide();
    } catch(e){

    }



  }


}


