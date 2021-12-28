import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petbuddy/pages/anasayfa.dart';
import 'package:petbuddy/pages/eposta_ile_oturum_acma.dart';
import 'package:petbuddy/pages/ilanlar_sayfasi.dart';
import 'package:petbuddy/pages/kayit_ol.dart';

import '../service/auth_service.dart';
import 'package:provider/provider.dart';


FirebaseAuth _auth = FirebaseAuth.instance;

class GirisYapSayfasi extends StatefulWidget {
  const GirisYapSayfasi({Key? key}) : super(key: key);

  @override
  _GirisYapSayfasiState createState() => _GirisYapSayfasiState();
}

class _GirisYapSayfasiState extends State<GirisYapSayfasi> {

  @override
  void initState() {
    // TODO: implement initState
    _auth
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        debugPrint('Kullanici oturumu kapattı veya yok!');
      } else {
        if(user.emailVerified){
          debugPrint('Kullanıcı oturum açtı hesap onaylı!');
        }
        else {
          debugPrint('Kullanıcı oturum açtı ama hesap onaylanmadı!');
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    final myAuth = Provider.of<AuthService>(context,listen: true);
    switch (myAuth.durum) {
      case KullaniciDurumu.OturumAciliyor:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case KullaniciDurumu.OturumAcilmamis:
        return girisYapSayfasi(context);

      case KullaniciDurumu.OturumAcilmis:
        return Ilanlar();
    }







  }

  Scaffold girisYapSayfasi(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/giris_sayfasi_kopegi.png",
              width: 250,
              height: 250,
            ),
            Text(
              "PetBuddy'e Hoşgeldin! ",
              style: TextStyle(fontSize: 30, fontFamily: "IndieFlower"),
            ),
            Container(
              width: 100,
              height: 50,
            ),
            Container(
              height: 50,
              width: 450,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ElevatedButton.icon(
                  onPressed: () {


                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                      create: (_)=>AuthService(),
                      child: EPostaIleOturumAcmaSayfasi(),
                    )));

                  },
                  icon: Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    "E-posta Şifre İle Giriş Yap",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 450,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ElevatedButton.icon(
                  onPressed: _gmailleGiris,
                  icon: Image.asset(
                    "assets/images/google_oturum_acma_icon.png",
                    width: 25,
                    height: 25,
                  ),
                  label: Text(
                    "Google İle Giriş Yap",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hala bir PetBuddy hesabın yok mu ? ",
                  ),
                  InkWell(
                    child: Text(
                      "Kaydol",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
                        create: (_)=>AuthService(),
                        child: KayitOlSayfasi(),
                      )));


                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<UserCredential?> _gmailleGiris() async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangeNotifierProvider(
        create: (_)=>AuthService(),
        child: Ilanlar(),
      )));
    }
    catch(e){
      debugPrint("gmail ile giris hatası" );
    }
  }
}
