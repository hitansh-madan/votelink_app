import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:votelink/ui/pages/Elections.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Color(0xFFF2F2F2),
          brightness: Brightness.light,
          elevation: 0,
          actions: <Widget>[
            IconButton(icon: Icon(CupertinoIcons.bell), onPressed: null),
            IconButton(icon: Icon(CupertinoIcons.settings), onPressed: null),
          ],
          title: Container(
            padding: EdgeInsets.all(0),
            child: Image(
              image: AssetImage("assets/logofull.png"),
              width: 70,
              colorBlendMode: BlendMode.difference,
              color: Color(0xFFF0F2FF),
            ),
          ),
        ),
      ),
      body: FutureBuilder(future:Firebase.initializeApp(),
        builder: (context,snapshot)
        {
          if(snapshot.connectionState == ConnectionState.done)
            return Elections();
          return Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}
