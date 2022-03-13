import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbuddy/service/petekle_service.dart';

class PetEkle extends StatefulWidget {

  String kullanici_id;
  PetEkle({required this.kullanici_id});
  @override
  _PetEkle createState() => _PetEkle();

}

class _PetEkle extends State<PetEkle> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;



  TextEditingController statusController = TextEditingController();
  PetEkleService _petEkleService = PetEkleService();
  TextEditingController petAdiController=TextEditingController();
  TextEditingController turuController=TextEditingController();
  TextEditingController cinsiController=TextEditingController();
  TextEditingController cinsiyetiController=TextEditingController();

  final ImagePicker _pickerImage = ImagePicker();
  dynamic _pickImage;
  var profileImage;
  String? petAdi,turu,cinsi,secilenCinsiyet='Dişi';
  final cinsiyetlist=['Dişi','Erkek'];


  Widget imagePlace(){
    double height=MediaQuery.of(context).size.height;
    if(profileImage!=null){
      return CircleAvatar(
        backgroundImage: FileImage(File(profileImage!.path)),
          radius: height*0.12
      );
    }
    else{
      if(_pickImage!=null){
        return CircleAvatar(
          backgroundImage: NetworkImage(_pickImage),
            radius: height*0.12
        );
      }else{
        return CircleAvatar(
          backgroundImage: AssetImage("assets/images/petpati.png")
          ,radius: height*0.12,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    CollectionReference HayvanlarRef = _firestore.collection("Hayvanlar");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/petpati.png",
              width: 50,
              height: 50,
            ),
            Text("PET EKLE")
          ],
        ),
      ),
      body:Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              SizedBox(height: 10,),
              Center(child: imagePlace(),),
              Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,children: [
                InkWell(
                  child: Icon(Icons.camera_alt,size: 48,),onTap: ()=>_onImageButtonPressed(ImageSource.camera,context: context),
                ),
                InkWell(
                  child: Icon(Icons.image,size: 48,),onTap: ()=>_onImageButtonPressed(ImageSource.gallery,context: context),
                )
              ],),
              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: petAdiController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Petinizin Adını Girin",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (girilenDeger){
                    petAdi=girilenDeger;

                  },
                ),
              ),
              //petAdi Containeri Bitişi

              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: turuController,
                  decoration: InputDecoration(hintText: "Petinizin Türünü Girin",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (girilenDeger){
                    turu=girilenDeger;

                  },
                ),
              ),
              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                margin: EdgeInsets.all(10),
                child: TextFormField(controller: cinsiController,
                  decoration: InputDecoration(
                    hintText: "Petinizin Cinsini Girin",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange.shade100,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (girilenDeger){
                    cinsi=girilenDeger;

                  },
                ),
              ),
              //petAdi Containeri Bitişi

              Container(
                width: 300,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: Colors.grey.shade400)),
                child: DropdownButton(
                  isExpanded: true,
                  value: secilenCinsiyet,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items:cinsiyetlist.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(items)
                    );
                  }
                  ).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      secilenCinsiyet = newValue;
                    });
                  },
                ),
              ),

              ElevatedButton(onPressed:(){
                print("kullanici idsi $widget.kullanici_id");
                _petEkleService.petEkle(petAdiController.text, cinsiController.text, turuController.text, secilenCinsiyet!,widget.kullanici_id,profileImage!).then((value){
                  Fluttertoast.showToast(msg: "Pet eklendi");
                });
                petAdiController.text="";
                turuController.text="";
                cinsiController.text="";

              }, child: Text("PET EKLE",style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
      ) ,
    );
  }

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile = await _pickerImage.pickImage(source: source,maxHeight: 300,maxWidth:
      300,imageQuality: 50);
      setState(() {
        profileImage = pickedFile!;
        print("dosyaya geldim: $profileImage");
        if (profileImage != null) {}
      });
    } catch (e) {
      setState(() {
        _pickImage = e;
        print("Image Error: " + _pickImage);
      });
    }
  }

}
