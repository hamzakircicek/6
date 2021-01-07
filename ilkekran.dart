import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bottom.dart';
import 'package:flutter_app/firebase.dart';
import 'package:flutter_app/grs.dart';
import 'package:flutter_app/verilerigoster.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
class kullanici extends StatefulWidget {
  String ad;
  kullanici({this.ad});
  @override
  _kullaniciState createState() => _kullaniciState();
}
ProgressDialog progressDialog;
TextEditingController txt=new TextEditingController();
TextEditingController txt2=new TextEditingController();
User Girisyapan;
FirebaseAuth _auth=FirebaseAuth.instance;
class _kullaniciState extends State<kullanici> {

  @override
  Widget build(BuildContext context) {
    progressDialog=ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Yükleniyor...');
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: txt,
              decoration: InputDecoration(
                hintText: "E-Mail Adresininizi Girin",

              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txt2,
              decoration: InputDecoration(
                hintText: "Şifrenizi Girin",

              ),
            ),
            SizedBox(height: 10,),
            RaisedButton(onPressed: (){

              girisyap(context,txt.text,txt2.text,widget.ad);






            }, child: Text("Giriş Yap"),),
            SizedBox(height: 10,),
            RaisedButton(onPressed: (){


              Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));



            }, child: Text("Kaydol"),),


          ],
        ),
      ),
    );
  }
}
void girisyap(BuildContext context,String email, String password,String kull)async{
  try{

    if(_auth.currentUser==null ){
      progressDialog.show();
      Girisyapan=(await _auth.signInWithEmailAndPassword(
          email: email, password: password)).user;
      progressDialog.hide();
      if(Girisyapan.emailVerified){
        Toast.show("Giriş Başarılı", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );

        Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));

      }else{
        Toast.show("Lütfen Size Gönderdiğimiz Maili Onaylayın", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM );
        await _auth.signOut();
      }


    }else{
      progressDialog.show();
      debugPrint("Bu kullanıcı zaten giriş yapmış");
      Girisyapan=(await _auth.signInWithEmailAndPassword(
          email: email, password: password)).user;
      progressDialog.hide();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
    }
  }
  catch(e){

  }

}