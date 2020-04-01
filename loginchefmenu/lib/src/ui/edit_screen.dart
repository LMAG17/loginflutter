import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/login_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/edit_information.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
class EditScreen extends StatelessWidget {
  final FirebaseUser _user;

  EditScreen({Key key, @required FirebaseUser user})
    : assert(user != null),
    _user = user,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository:  UserRepository()),
        child: EditInformationPage(user: _user),
      ),
    );
  }
}