import 'package:flutter/material.dart';
import 'package:votelink/bloc/AppBloc.dart';
import 'package:votelink/bloc/BlocProvider.dart';
import 'package:votelink/repository/AppSharedPreferences.dart';
import 'package:votelink/ui/pages/Onboarding.dart';
import 'package:votelink/ui/pages/home.dart';

void main() {
  final appBloc = AppBloc();
  runApp(MyApp(appBloc));
}

class MyApp extends StatefulWidget {
  final AppBloc bloc;

  MyApp(this.bloc);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLaunch = true;

  _MyAppState() {
    AppSharedPreferences.instance
        .getBooleanValue("isFirstLaunch")
        .then((value) => setState(() {
              isFirstLaunch = value ?? true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: widget.bloc,
      child: MaterialApp(
        routes: {
          '/home': (context) => Home(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Votelink',
        theme: ThemeData(fontFamily: "Jost"),
        home: isFirstLaunch ? Onboarding() : Home(),
      ),
    );
  }
}
