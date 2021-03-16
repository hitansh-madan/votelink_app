import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:votelink/ui/pages/Vote.dart';
import 'package:votelink/ui/views/ElectionCard.dart';

class Election extends StatefulWidget {
  @override
  _ElectionState createState() => _ElectionState();
  final String docId;
  final Map<String,dynamic> parties;

  Election(this.docId,this.parties);
}

class _ElectionState extends State<Election> {
  String dropdownValue = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Color(0xFFF2F2F2),
            brightness: Brightness.light,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.docId,
                child: Image(
                  image: AssetImage(
                    "assets/bckgrnd.webp",
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("elections")
                .doc(widget.docId)
                .snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData)
                return SliverList(delegate: SliverChildListDelegate.fixed([Container()]));
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        snapshot.data['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Select your Constituency",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20),),
                            color: Colors.white,boxShadow: [BoxShadow(color: Color(0xFFECECEC),blurRadius: 10)]),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("elections")
                              .doc(widget.docId)
                              .collection("constituencies")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return const Center(
                                child: const CupertinoActivityIndicator(),
                              );
                            return DropdownButton<String>(
                              value: dropdownValue,
                              iconSize: 24,
                              isExpanded: true,
                              elevation: 10,
                              hint: Text("Select"),
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (String newValue) {
                                setState(
                                  () {
                                    dropdownValue = newValue;
                                    print(dropdownValue);
                                  },
                                );
                              },
                              items: snapshot.data.docs.map(
                                (DocumentSnapshot document) {
                                  return DropdownMenuItem<String>(
                                    value: document.id,
                                    child: Text(document.data()['name']),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "List of Candidates",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            child: (dropdownValue == null)
                ? SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text("Select Constituency to display Candidates"),
                        ),
                      ],
                    ),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("elections")
                        .doc(widget.docId)
                        .collection("constituencies")
                        .doc(dropdownValue)
                        .collection("candidates")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return SliverList(
                            delegate: SliverChildListDelegate.fixed(
                                [Text("Loading")]));
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.white,boxShadow: [BoxShadow(color: Color(0xFFECECEC),blurRadius: 10)]),
                                child: ListTile(
                                  title: Text(snapshot.data.docs[i].data()['name']),
                                  subtitle: Text(widget.parties[snapshot.data.docs[i].data()['partyId'].toString()]),
                                  leading: Hero(
                                    child: CircleAvatar(),
                                    tag: snapshot.data.docs[i].data()['name'],
                                  ),
                                  trailing: RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Vote(dropdownValue, snapshot.data.docs[i].id, widget.docId,widget.parties),
                                        ),
                                      );
                                    },
                                          //  builder: (context) => Vote(dropdownValue, snapshot.data.docs[i].id, widget.docId))),
                                    child: Text("Vote"),
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: snapshot.data.docs.length,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
