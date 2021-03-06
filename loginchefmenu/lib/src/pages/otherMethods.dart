import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/bloc.dart';
import 'package:loginchefmenu/src/bloc/login_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/utils/createBackground.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';

class OtherMethods extends StatefulWidget {
  final UserRepository _userRepository;
  OtherMethods({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _OtherMethodsState createState() => _OtherMethodsState();
}

class _OtherMethodsState extends State<OtherMethods> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnable(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        //tres casos
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Fallo al Iniciar Sesión"),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Iniciando Sesión..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  CreateBackground().createBigBackground(context),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.45,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(LoggedOut());
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "Bienvenido de nuevo",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.green,
                          hintColor: Colors.grey[800],
                        ),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.mail_outline,
                                ),
                                labelText: 'Correo Electronico',
                                hintText: "example@example.ex",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(32.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white70,
                              ),
                              autocorrect: false,
                              autovalidate: true,
                              validator: (_) {
                                return !state.isEmailValid
                                    ? 'Correo invalido'
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock_outline),
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(32.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white70,
                              ),
                              obscureText: true,
                              autovalidate: true,
                              autocorrect: false,
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? 'Contraseña invalida'
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Enviaremos un correo de verificacion"),
                                        content: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: _emailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration: InputDecoration(
                                                    icon: Icon(
                                                      Icons.mail_outline,
                                                    ),
                                                    labelText:
                                                        'Correo Electronico',
                                                    hintText:
                                                        "example@example.ex",
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.green),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        const Radius.circular(
                                                            32.0),
                                                      ),
                                                    ),
                                                    filled: true,
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                    fillColor: Colors.white70,
                                                  ),
                                                  autocorrect: false,
                                                  autovalidate: true,
                                                  validator: (_) {
                                                    return !state.isEmailValid
                                                        ? 'Correo invalido'
                                                        : null;
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                  child: Text("Aceptar"),
                                                  onPressed: () {
                                                    if (_emailController
                                                        .text.isNotEmpty) {
                                                      _userRepository
                                                          .forgotPassword(
                                                              _emailController
                                                                  .text);
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                "Olvide mi contraseña",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.72,
                    left: MediaQuery.of(context).size.width * 0.16,
                    right: MediaQuery.of(context).size.width * 0.16,
                    child: RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        child: Text(
                          "Continuar",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      onPressed:
                          isLoginButtonEnable(state) ? _onFormSubmitted : null,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.83,
                    left: MediaQuery.of(context).size.width * 0.12,
                    right: MediaQuery.of(context).size.width * 0.12,
                    child: Column(
                      children: <Widget>[
                        FacebookSignInButton(
                          borderRadius: 5,
                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context)
                                .add(LoginWithFacebook());
                          },
                          text: "Continuar con Facebook",
                        ),
                        GoogleSignInButton(
                          borderRadius: 5,
                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context)
                                .add(LoginWithGoogle());
                          },
                          text: "   Continuar con Google   ",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
