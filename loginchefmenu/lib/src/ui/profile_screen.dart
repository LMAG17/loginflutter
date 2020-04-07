import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/profile_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/isLog.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseUser _user;
  final UserRepository _userRepository;
  ProfileScreen(
      {Key key,
      @required FirebaseUser user,
      @required UserRepository userRepository})
      : assert(user != null, userRepository != null),
        _user = user,
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
          user: _user,
          userRepository: _userRepository,
        ),
        child: IsLog(),
      ),
    );
  }
}
