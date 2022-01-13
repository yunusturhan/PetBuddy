import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

enum KullaniciDurumu { OturumAcilmis, OturumAcilmamis, OturumAciliyor }


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;


class AuthService with ChangeNotifier {
  KullaniciDurumu _durum = KullaniciDurumu.OturumAcilmamis;
  User? _user;

  set user(User? value) {
    _user = value;
  }

  KullaniciDurumu get durum => _durum;

  User? get user => _user;

  set durum(KullaniciDurumu value) {
    _durum = value;
    notifyListeners();
  }

  AuthService() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  void _authStateChanged(User? user) {
    if (user == null) {
      _user = null;
      durum = KullaniciDurumu.OturumAcilmamis;
    } else {
      _user = user;
      durum = KullaniciDurumu.OturumAcilmis;
    }
  }

  Future<User?> createUserWithEmailandPassword(
      String email, String sifre , String user_isim) async {
    try {
      durum = KullaniciDurumu.OturumAciliyor;
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: sifre);
      User? _yeniKullanici = _credential.user;
      _user = _yeniKullanici;


      await _firestore
          .collection("Kullanici")
          .doc(_user!.uid.toString())
          .set({'user_adi': user_isim, 'email': email,'user_id':_user!.uid.toString(),'profil_resmi':"https://firebasestorage.googleapis.com/v0/b/petbuddyim.appspot.com/o/Kullanici%2Fdefault.png?alt=media&token=114ff80d-752b-4b3c-bf64-adf6388f7ee1",'aciklama':" "});
      debugPrint(_user!.uid.toString());
      return _yeniKullanici;
    } catch (e) {
      durum = KullaniciDurumu.OturumAcilmamis;
      debugPrint("create userda hata cıktı $e");
      return null;
    }
  }

  Future<User?> signInUserWithEmailandPassword(
      String email, String sifre) async {
    try {
      durum = KullaniciDurumu.OturumAciliyor;
      UserCredential _credential =
      await _auth.signInWithEmailAndPassword(email: email, password: sifre);
      User? _oturumAcanKullanici = _credential.user;
      _user = _oturumAcanKullanici;
      debugPrint(_user!.uid.toString());


      return _oturumAcanKullanici;
    } catch (e) {
      durum = KullaniciDurumu.OturumAcilmamis;
      debugPrint("sing in metotunda hata cıktı $e");
      return null;
    }
  }

  Future<User?> googleIleGiris()async{
    try{
      // Trigger the authentication flow
      GoogleSignIn _googleSignIn= GoogleSignIn();
      final GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      if(_googleUser!=null){
        GoogleSignInAuthentication _googleAuth=_googleUser.authentication as GoogleSignInAuthentication;
        if(_googleAuth.idToken !=null && _googleAuth.accessToken !=null){
          UserCredential _credential= await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: _googleAuth.idToken,accessToken: _googleAuth.accessToken));
          User? _user=_credential.user;
          return _user;
        }else{
          return null;
        }
      }else {
        return null;
      }
    }
    catch(e){
      debugPrint("gmail ile giris hatası" );
    }


  }




  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      durum = KullaniciDurumu.OturumAcilmamis;
      return true;
    } catch (e) {
      debugPrint("sing out metotunda hata cıktı $e");
      return false;
    }
  }
}
