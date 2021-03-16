import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:votelink/ui/views/ElectionCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Elections extends StatefulWidget {
  @override
  _ElectionsState createState() => _ElectionsState();
}

class _ElectionsState extends State<Elections> with TickerProviderStateMixin {
  final firebase = Firebase.initializeApp();
  CollectionReference elections =
      FirebaseFirestore.instance.collection("elections");

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Elections",
          style: TextStyle(color: Colors.black87, fontSize: 35),
        ),
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Ongoing",
            ),
            Tab(
              text: "Previous",
            ),
          ],
          labelColor: Colors.black87,
          labelStyle: TextStyle(fontFamily: "Jost", fontSize: 16),
          unselectedLabelColor: Colors.black54,
          indicatorColor: Color.fromRGBO(60, 75, 175, 1),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 40),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 250,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ongoingList(),
              previousList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget ongoingList() {
    return StreamBuilder<QuerySnapshot>(
      stream: elections.where('ongoing',isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: ElectionCard(snapshot.data.docs[i].id),
            );
          },
        );
      },
    );
  }
  Widget previousList() {
    return StreamBuilder<QuerySnapshot>(
      stream: elections.where('ongoing',isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: ElectionCard(snapshot.data.docs[i].id),
            );
          },
        );
      },
    );
  }
}
