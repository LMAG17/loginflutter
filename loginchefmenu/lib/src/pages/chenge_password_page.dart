import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/login_bloc/bloc.dart';

import 'isLog.dart';
import 'utils/createBackground.dart';

class ChangePasswordPage extends StatefulWidget {
  final FirebaseUser user;
  ChangePasswordPage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  LoginBloc _loginBloc;
  TextStyle style = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle style2 = TextStyle(
    fontSize: 20,
  );
  FirebaseUser get _user => widget.user;
  String oldPassword;
  String newPasswordOne;
  String newPasswordTwo;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  bool isButtonEnable() {
    return newPasswordOne == newPasswordTwo;
  }

  void _editPassword() async {
    _loginBloc.add(ChangePassword(
        email: _user.email,
        oldPassword: oldPassword,
        newPassword: newPasswordOne));
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
                    Text("Fallo al cambiar contraseña"),
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
                    Text("Cambiando contraseña..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IsLog(
                        user: _user,
                      )));
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              CreateBackground().createCircleBackground(context),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                right: MediaQuery.of(context).size.height * 0.05,
                child: Text(
                  "Mi Perfil",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.04,
                child: CircleAvatar(
                  maxRadius: 80,
                  backgroundImage: NetworkImage(_user.photoUrl != null
                      ? _user.photoUrl
                      : "https://thumbs.dreamstime.com/z/restaurante-logotipo-del-vector-del-caf%C3%A9-men%C3%BA-plato-comida-o-cocinero-icono-del-cocinero-69996518.jpg"),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                child: Card(
                  elevation: 4,
                  // shadowColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width - 32,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.green,
                        hintColor: Colors.grey[800],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Contraseña:",
                              style: style, textAlign: TextAlign.left),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                color: Colors.green,
                              ),
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
                            onChanged: (v) {
                              setState(() {
                                oldPassword = v;
                              });
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Nueva contraseña:",
                              style: style, textAlign: TextAlign.left),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                color: Colors.green,
                              ),
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
                            onChanged: (v) {
                              setState(() {
                                newPasswordOne = v;
                              });
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Vuelva a ingresar su contraseña:",
                              style: style, textAlign: TextAlign.left),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                color: Colors.green,
                              ),
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
                            onChanged: (v) {
                              setState(() {
                                newPasswordTwo = v;
                              });
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.green,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 16),
                                child: Text(
                                  "Guardar",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              onPressed:
                                  isButtonEnable() ? _editPassword : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.225,
                right: MediaQuery.of(context).size.width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.not_interested,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
