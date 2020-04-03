import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/profile_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/isLog.dart';
class ProfileScreen extends StatelessWidget {
  final FirebaseUser _user;

  ProfileScreen({Key key, @required FirebaseUser user})
    : assert(user != null),
    _user = user,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(user: _user),
        child: IsLog(),
      ),
    );
  }
}