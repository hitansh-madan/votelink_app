import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:votelink/repository/models/Election.dart';

class ElectionCard extends StatefulWidget {
  @override
  _ElectionCardState createState() => _ElectionCardState();
  final String docId;

  ElectionCard(this.docId);
}

class _ElectionCardState extends State<ElectionCard> {

  int value = 0;
  //DocumentReference electionDoc=FirebaseFirestore.instance.collection("elections").doc(widget.docId);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.white24,
      child: Column(
        children: <Widget>[
          Hero(
            tag: widget.docId,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/bckgrnd.webp"),
                ),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("elections").doc(widget.docId).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData)
                return Container();
              return ListTile(
                title: Text(snapshot.data['name']),
                subtitle: Text("Voting closes in 0 hrs"),
                trailing: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Election(widget.docId,snapshot.data['parties']),
                      ),
                    );
                  },
                  child: Text(
                    "Vote",
                  ),
                  color: Color.fromRGBO(60, 75, 175, 1),
                  textColor: Colors.white,
                ),
              );
            }
          )
        ],
      ),
    );
  }
}
