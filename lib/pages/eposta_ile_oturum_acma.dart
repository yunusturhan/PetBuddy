import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petbuddy/pages/anasayfa.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:petbuddy/pages/ilanlar_sayfasi.dart';
import 'package:petbuddy/pages/sifremi_unuttum.dart';
import 'package:provider/provider.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class EPostaIleOturumAcmaSayfasi extends StatefulWidget {
  const EPostaIleOturumAcmaSayfasi({Key? key}) : super(key: key);

  @override
  _EPostaIleOturumAcmaSayfasiState createState() =>
      _EPostaIleOturumAcmaSayfasiState();
}
String? _eposta,_sifre;
class _EPostaIleOturumAcmaSayfasiState
    extends State<EPostaIleOturumAcmaSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap",style: TextStyle(color: Colors.white),),
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
              Text("E-postanızı girin:"),
              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (girilenDeger){
                    _eposta=girilenDeger;

                  },
                ),
              ),
              //Eposta Containeri Bitişi

              Text("Şifrenizi girin:"),
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
                      hintText: ' ',
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
                      '''Doğru bir şifrede bunlar olur : 1 A a . * @ # \$'
tamam bakmıyorum doğrusunu gir''',

                      onChanged: (girilenDeger){
                        _sifre=girilenDeger;

                      },
                    ),
                  ],
                ),
              ),
              //şifre Containeri Bitişi
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Şifreni mi unuttun ? ",
                    ),
                    InkWell(
                      child: Text(
                        "Sıfırla",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SifremiUnuttum()));},
                    )
                  ],
                ),
              ),

              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ElevatedButton(
                    onPressed: () async{
                      await
                      context.read<AuthService>().signInUserWithEmailandPassword(_eposta!, _sifre!);
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Anasayfa()));
                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                         create: (_)=>AuthService(),
                         child: Anasayfa(),
                       )));
                      print("bastı");

                    },
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
