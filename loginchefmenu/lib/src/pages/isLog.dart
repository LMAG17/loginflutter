import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:loginchefmenu/src/pages/utils/createBackground.dart';
import 'package:loginchefmenu/src/pages/utils/flutter_country_picker.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
import 'package:loginchefmenu/src/ui/change_password_screen.dart';
import 'package:loginchefmenu/src/ui/edit_screen.dart';

class IsLog extends StatefulWidget {
  final FirebaseUser user;
  IsLog({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _IsLogState createState() => _IsLogState();
}

class _IsLogState extends State<IsLog> {
  bool faceLink = false;
  bool googleLink = false;
  FirebaseUser get _user => widget.user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle style2 = TextStyle(
    fontSize: 20,
  );
  var value;
  @override
  void initState() {
    _auth.fetchSignInMethodsForEmail(email: _user.email).then((value) {
      print(value);
      if (value.contains('facebook.com')) {
        faceLink = true;
      }
      if (value.contains('google.com')) {
        googleLink = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 80,
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
              // SingleChildScrollView(
              //child:
              Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      height: 180.0,
                    ),
                  ),
                  Card(
                    elevation: 4,
                    //shadowColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width - 32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nombre:",
                              style: style, textAlign: TextAlign.left),
                          TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "${_user.displayName}",
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
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Apellido:",
                              style: style, textAlign: TextAlign.left),
                          TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "${_user.displayName}",
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
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Email:",
                              style: style, textAlign: TextAlign.left),
                          TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "${_user.email}",
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
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Numero:",
                              style: style, textAlign: TextAlign.left),
                          TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              icon: CountryPicker(
                                showDialingCode: true,
                                showName: false,
                                onChanged: (Country value) {},
                              ),
                              hintText: "${_user.phoneNumber}",
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
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Tu numero ha sido validado ✔️",
                                  style: TextStyle(color: Colors.green),
                                )),
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
                                  "Cambiar Contraseña",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordScreen(
                                              user: _user,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  FacebookSignInButton(
                    borderRadius: 5,
                    onPressed: () {
                      UserRepository().loginWithFacebook();
                      setState(() {
                        
                      });
                    },
                    text: faceLink
                        ? "Desvincular de Facebook"
                        : "Continuar con Facebook",
                  ),
                  GoogleSignInButton(
                    borderRadius: 5,
                    onPressed: () async {
                      UserRepository().signInWithGoogle();
                      setState((){});
                    },
                    text: googleLink
                        ? "Desvincular de Google"
                        : "Continuar con Google",
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Cerrar Sesión",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    color: Colors.deepPurple,
                    onPressed: () {
                      showAlertDialog(context);
                    },
                  ),
                ],
              ),
              // ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                right: MediaQuery.of(context).size.width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditScreen(
                                  user: _user,
                                )));
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
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

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        UserRepository().signOut();
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Cerrar sesión"),
      content: Text("¿Realmente desea cerrar sesión? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
