import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_state.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/simple_bloc_delegate.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
import 'package:loginchefmenu/src/ui/login_screen.dart';
import 'package:loginchefmenu/src/ui/other_methods_screen.dart';
import 'package:loginchefmenu/src/ui/personal_data_screen.dart';
import 'package:loginchefmenu/src/ui/profile_screen.dart';
import 'package:loginchefmenu/src/ui/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  const App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is Uninitialized) {
          return SplassScreen();
        }
        if (state is AuthenticatedWithOutEmail) {
          return PersonalDataScreen(
            userRepository: _userRepository,
          );
        }
        if (state is Authenticated) {
          return ProfileScreen(
            user: state.user,
            userRepository: _userRepository,
          );
        }
        if (state is Unauthenticated) {
          return LoginScreen(
            userRepository: _userRepository,
          );
        }
        if (state is OtherMethodsState) {
          return OtherMethodsScreen(userRepository: _userRepository);
        }
        return Container();
      }),
    );
  }
}
