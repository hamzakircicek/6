import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/firebase.dart';
import 'package:flutter_app/verilerigoster.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'ilkekran.dart';
import 'ilkekran.dart';
FirebaseAuth _auth= FirebaseAuth.instance;

class giris extends StatefulWidget {
  @override
  _girisState createState() => _girisState();
}
ProgressDialog progressDialog;
class _girisState extends State<giris> {

  @override
  void initState(){
    _auth
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('Kullanıcı Oturumu Kapattı');
      } else {
        print('Kullanıcı Oturum Açtı');
      }
    });
  }

  TextEditingController txt=new TextEditingController();
  TextEditingController txt2=new TextEditingController();
  TextEditingController txt3=new TextEditingController();
  TextEditingController txt4=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    progressDialog=ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Yükleniyor...');
    return Scaffold(

      body: Stack(
          children:[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network("https://i.stack.imgur.com/7vMmx.jpg",fit: BoxFit.cover,),

            ),

            Container(

              margin: EdgeInsets.all(50),
              color: Colors.transparent,
              child: ListView(
                  children:[ Column(
                    children: [
                      TextField(
                        controller: txt,
                        decoration: InputDecoration(
                          hintText: "E-Mail Adresininizi Girin",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(width:0,color: Colors.white,)),
                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(color: Colors.white)) ,

                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.blueGrey.shade400,
                        ),
                        cursorColor: Colors.white,

                      ),
                      SizedBox(height: 15,),
                      TextField(
                        controller: txt4,
                        maxLength: 9,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı Adınızi Girin",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(width:0,color: Colors.white,)),
                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(color: Colors.white)) ,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.blueGrey.shade400,

                        ),
                        cursorColor: Colors.white,

                      ),
                      SizedBox(height: 15,),
                      TextField(
                        controller: txt2,
                        decoration: InputDecoration(

                          hintText: "Şifrenizi Girin",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(color: Colors.white)),
                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(color: Colors.white)) ,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.blueGrey.shade400,
                        ),

                      ),
                      SizedBox(height: 15),
                      TextField(

                        controller: txt3,
                        decoration: InputDecoration(
                          hintText: "Şifrenizi Tekrardan Girin",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(color: Colors.white)),
                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(35),borderSide: BorderSide(color: Colors.white)) ,
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.blueGrey.shade400,
                        ),
                      ),
                      SizedBox(height: 15,),
                      RaisedButton(onPressed: (){
                        if(txt2.text==txt3.text){
                          if(txt4.text.length<=9){
                            kaydol(context,txt4.text,txt.text,txt2.text);
                          }else{
                            Toast.show("Lütfen Kullanıcı Adını 9 Karakterden Fazla Girmeyin.", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
                          }

                        }
                        else{
                          txt2.text="";
                          txt3.text="";
                          Toast.show("Girdiğiniz Şifreler Eşleşmiyor.", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
                        }






                      }, child: Text("Kaydol"),),
                      SizedBox(height: 10,),
                      RaisedButton(

                        onPressed: (){

                          cikisyap();

                        },

                        child: Text("Çıkış Yap"),),
                      SizedBox(height: 10,),
                      RaisedButton(

                        onPressed: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>kullanici()));

                        },

                        child: Text("Çıkış Yap"),),
                    ],
                  ),
                  ]
              ),


            ),
          ]
      ),
    );
  }
}

void kaydol(BuildContext context,String kuladi,String mail, String sifre) async{

  try{

    progressDialog.show();
    UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: mail, password: sifre);
    User _kullanici= userCredential.user;
    _kullanici=_auth.currentUser;
    await _kullanici.updateProfile(displayName: kuladi);

    await _kullanici.sendEmailVerification();
    progressDialog.hide();
    if(_kullanici!=null){



      Toast.show("Kayıt Başarıyla Gerçekleşti. Giriş Yapabilmek İçin Size Gönderdiğimiz Maili Onaylayın.", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>kullanici(ad: kuladi,)));
      await _auth.signOut();



    }

  }catch(e){

  }

}
void cikisyap() async{
  if(_auth.currentUser!=null){
    await _auth.signOut();
  }else{

  }
}