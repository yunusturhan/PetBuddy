import 'package:flutter/material.dart';

String? _eposta;
class SifremiUnuttum extends StatelessWidget {
   const SifremiUnuttum({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(title: Text("Şifremi Unuttum",style: TextStyle(color: Colors.white),),
            iconTheme: IconThemeData(color: Colors.white),),
         body: Center(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                  Container(
                     height: 75,
                     width: 450,
                     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                     child: TextFormField(
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
                     height: 50,
                     width: 450,
                     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                     child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ElevatedButton(
                           onPressed: () {
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                  MaterialBanner(
                                      padding: EdgeInsets.all(20),
                                      leading: Icon(Icons.done_outlined,color: Colors.white,size: 32,),
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          "Sıfırlama maili başarıyla gönderildi. !",style: TextStyle(color: Colors.white)),
                                      actions: [
                                         TextButton(
                                             onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentMaterialBanner();
                                             },
                                             child: Text("Anladım",style: TextStyle(color: Colors.white),))
                                      ]));
                              /*Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EPostaIleOturumAcmaSayfasi()));*/
                           },
                           child: Text(
                              "Sıfırlama maili gönder",
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
      );
   }
}