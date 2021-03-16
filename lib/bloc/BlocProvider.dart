import 'package:flutter/material.dart';
import 'package:votelink/bloc/AppBloc.dart';

class BlocProvider extends InheritedWidget {
  final AppBloc bloc;

  BlocProvider({Key key, this.bloc, child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<BlocProvider>()).bloc;
}