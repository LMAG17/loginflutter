import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginchefmenu/src/bloc/login_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/isLog.dart';
import 'package:loginchefmenu/src/pages/utils/createBackground.dart';

class EditInformationPage extends StatefulWidget {
  final FirebaseUser user;
  EditInformationPage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _EditInformationPageState createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  LoginBloc _loginBloc;
  FirebaseUser get _user => widget.user;
  String name;
  String url;
  File foto;
  UserUpdateInfo updateinfo = UserUpdateInfo();
  TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle style2 = TextStyle(
    fontSize: 20,
  );
  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  getImage(ImageSource origen) async {
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
    url = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(context).pop();
    return url;
  }

  bool isEditable() {
    return foto != null || name != null;
  }

  void _editUser() async {
    if (name != null) {
      updateinfo.displayName = name;
    }
    if (foto != null) {
      updateinfo.photoUrl = await uploadImage();
    }
    _loginBloc.add(UpdateUserProfile(userinfo: updateinfo));
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
                    Text("Fallo al Actualizar datos"),
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
                    Text("Actualizando datos..."),
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
                  backgroundImage: foto != null
                      ? AssetImage(foto.path)
                      : NetworkImage(_user.photoUrl != null
                          ? _user.photoUrl
                          : "https://thumbs.dreamstime.com/z/restaurante-logotipo-del-vector-del-caf%C3%A9-men%C3%BA-plato-comida-o-cocinero-icono-del-cocinero-69996518.jpg"),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.19,
                left: MediaQuery.of(context).size.width * 0.33,
                child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                child: Card(
                  elevation: 4,
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
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          enabled: true,
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
                          onChanged: (v) {
                            setState(() {
                              name = v;
                            });
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text("Apellido:",
                            style: style, textAlign: TextAlign.left),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          enabled: true,
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
                            onPressed: isEditable() ? _editUser : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.225,
                right: MediaQuery.of(context).size.width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IsLog(
                                  user: _user,
                                )));
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

  showAlertDialog(BuildContext context) {
    Widget cameraButton = FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.camera),
          Text("Camara"),
        ],
      ),
      onPressed: () {
        getImage(ImageSource.camera);
        Navigator.pop(context);
      },
    );
    Widget galleryButton = FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.camera_roll),
          Text("Galeria"),
        ],
      ),
      onPressed: () {
        getImage(ImageSource.gallery);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Seleccionar una imagen"),
      content: Text("¿De donde desea seleccionar su imagen?"),
      actions: [
        cameraButton,
        galleryButton,
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
