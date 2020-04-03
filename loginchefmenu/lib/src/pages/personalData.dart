import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/bloc.dart';
import 'package:loginchefmenu/src/bloc/login_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/utils/createBackground.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';

class PersonalData extends StatefulWidget {
  PersonalData({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _PersonalDataState createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File foto;
  String name;
  UserUpdateInfo updateinfo = UserUpdateInfo();
  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      name != null &&
      foto != null;

  bool isLoginButtonEnable(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
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

  void _onFormSubmitted() async {
    updateinfo.displayName = name;
    updateinfo.photoUrl = await uploadImage();

    _loginBloc.add(SignUpWithEmailAndPassowrd(
        email: _emailController.text,
        password: _passwordController.text,
        userinfo: updateinfo));
  }

  _getImage(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);
    if (foto != null) {}
    setState(() {});
  }

  Future<String> uploadImage() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Text("Subiendo imagen"),
                CircularProgressIndicator(),
              ],
            ),
          );
        });
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child('Post Image');
    var timeKey = DateTime.now();
    final StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + ".jpg").putFile(foto);
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(context).pop();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  CreateBackground().createSlimBackground(context),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.16,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: Text(
                      "Bienvenido",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.22,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.green,
                          hintColor: Colors.grey[800],
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Seleccionar una imagen"),
                                      content: Text(
                                          "¿De donde desea seleccionar su imagen?"),
                                      actions: [
                                        FlatButton(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Icons.camera),
                                              Text("Camara"),
                                            ],
                                          ),
                                          onPressed: () {
                                            _getImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Icons.camera_roll),
                                              Text("Galeria"),
                                            ],
                                          ),
                                          onPressed: () {
                                            _getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                maxRadius: 80,
                                backgroundImage: foto != null
                                    ? AssetImage(foto.path)
                                    : NetworkImage(
                                        "https://thumbs.dreamstime.com/z/restaurante-logotipo-del-vector-del-caf%C3%A9-men%C3%BA-plato-comida-o-cocinero-icono-del-cocinero-69996518.jpg"),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            TextField(
                              onChanged: (v) {
                                setState(() {
                                  name = v;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person_outline,
                                  color: Colors.green,
                                ),
                                hintText: 'Ingrese su nombre',
                                labelText: 'Nombre',
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
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.mail_outline,
                                  color: Colors.green,
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
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? 'Invalid Password'
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.75,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
