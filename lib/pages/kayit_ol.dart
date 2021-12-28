import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:provider/provider.dart';

String? _eposta, _sifre,user_isim, _sifreKontrol,_sifreDogrulukHatasi="Girilen şifreler eşleşmiyor";
bool? mailDogruMu;


class KayitOlSayfasi extends StatefulWidget {
  const KayitOlSayfasi({Key? key}) : super(key: key);

  @override
  _KayitOlSayfasiState createState() => _KayitOlSayfasiState();
}

class _KayitOlSayfasiState extends State<KayitOlSayfasi> {

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kayıt Ol",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/e_posta_girisi_kopegi.png",
                width: 250,
                height: 250,
              ),
              Container(
                height: 75,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Adınızı girin",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (girilenDeger) {
                    user_isim = girilenDeger;
                  },
                ),
              ),
              Container(
                height: 75,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: TextFormField(

                  validator: (email)=>EmailValidator.validate(email) ? null :"Lütfen geçerli bir email adresi giriniz.",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-postanızı girin",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (girilenDeger) {
                    _eposta = girilenDeger;
                  },
                ),
              ),
              //Eposta Containeri Bitişi

              Container(
                height: 100,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 40),
                child: Column(
                  children: [
                    PasswordField(
                      color: Colors.orange,
                      // passwordConstraint: r'@$#.*0-9a-zA-z',
                      inputDecoration: PasswordDecoration(),
                      hintText: 'Şifrenizi girin',
                      border: PasswordBorder(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 2, color: Colors.red),
                        ),
                      ),
                      errorMessage:
                      'Şifreniz güvenli gözükmüyor !!',
                      onChanged: (girilenDeger) {
                        _sifre = girilenDeger;
                      },
                    ),
                  ],
                ),
              ),
              //şifre Containeri Bitişi

              Container(
                height: 100,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 40),
                child: Column(
                  children: [
                    PasswordField(
                      color: Colors.orange,

                      passwordConstraint: r'[0-9a-zA-Z]',
                      inputDecoration: PasswordDecoration(),
                      hintText: 'Şifrenizi tekrar girin',
                      border: PasswordBorder(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 2, color: Colors.red),
                        ),
                      ),
                      errorMessage:
                      _sifreDogrulukHatasi,
                      onChanged: (girilenDeger) {
                        _sifreKontrol = girilenDeger;
                        if(_sifreKontrol==_sifre){
                          _sifreDogrulukHatasi="";

                        }else{
                          _sifreDogrulukHatasi="";
                        }

                      },
                    ),
                  ],
                ),
              ),
              //şifre Containeri Bitişi

              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ElevatedButton(child: Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                    onPressed: (){
                      if(_sifre!=_sifreKontrol){
                        ScaffoldMessenger.of(context).showMaterialBanner(
                            MaterialBanner(
                                padding: EdgeInsets.all(20),
                                leading: Icon(Icons.error_outline,color: Colors.white,size: 32,),
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Şifreleriniz eşleşmiyor !",style: TextStyle(color: Colors.white)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentMaterialBanner();
                                      },
                                      child: Text("Anladım",style: TextStyle(color: Colors.white),))
                                ]));
                      }
                      else {
                        ScaffoldMessenger.of(context).showMaterialBanner(
                            MaterialBanner(
                                padding: EdgeInsets.all(20),
                                leading: Icon(Icons.verified_outlined,color: Colors.white,size: 32,),
                                backgroundColor: Colors.green,
                                content: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Hesabınız oluşturuldu.",style: TextStyle(color: Colors.white),),
                                    Text("Lütfen mailinizi onaylayınız!",style: TextStyle(color: Colors.white),),

                                  ],),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentMaterialBanner();
                                    },
                                    child:Column(children: [
                                      Text("Hemen",style: TextStyle(color: Colors.white),),
                                      Text("Onaylıyorum",style: TextStyle(color: Colors.white),),

                                    ],) ,)
                                ]));

                        context.read<AuthService>().createUserWithEmailandPassword(_eposta!, _sifre!,user_isim!);

                      }print("Kayda engel bir şey yok");
                    },

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
