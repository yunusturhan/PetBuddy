import 'package:flutter/material.dart';
import 'package:petbuddy/service/auth_service.dart';
import 'package:provider/src/provider.dart';

class Gezginler extends StatefulWidget {
  const Gezginler({Key? key}) : super(key: key);

  @override
  _GezginlerState createState() => _GezginlerState();
}

class _GezginlerState extends State<Gezginler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gezginler"),),
      body: Center(
        child: Text(context.watch<AuthService>().user!.uid),

      ),
    );
  }
}



