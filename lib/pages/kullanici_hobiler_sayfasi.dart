import 'package:flutter/material.dart';

class KullaniciHobileri extends StatefulWidget {
  const KullaniciHobileri({Key? key}) : super(key: key);

  @override
  State<KullaniciHobileri> createState() => _KullaniciHobileriState();
}

class _KullaniciHobileriState extends State<KullaniciHobileri> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hobilerim"),),
      body: Center(
        child: Column(
          children: [

          ],
        ),
      ),

    );
  }
}
