import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:loginchefmenu/src/bloc/profile_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/utils/createBackground.dart';
import 'package:loginchefmenu/src/pages/utils/flutter_country_picker.dart';
import 'package:loginchefmenu/src/pages/utils/shimmer.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
import 'package:loginchefmenu/src/utils/validators.dart';

class IsLog extends StatefulWidget {
  IsLog({Key key}) : super(key: key);
  @override
  _IsLogState createState() => _IsLogState();
}

class _IsLogState extends State<IsLog> {
  TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle style2 = TextStyle(
    fontSize: 20,
  );
  @override
  void initState() { 
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(LoadProviders());
  }
  Future<File> getImage(ImageSource origen) async {
    return await ImagePicker.pickImage(source: origen);
  }

  bool isEditable(EditProfileContent state) {
    return state.foto != null || state.updateinfo.displayName != null;
  }

  bool isButtonEnable(
      String oldPassword, String newPasswordOne, String newPasswordTwo) {
    return newPasswordOne != null && newPasswordOne == newPasswordTwo;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is Success) {
          BlocProvider.of<ProfileBloc>(context).add(ChangeToProfileContent());
        } else if (state is Loading) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Por favor espera..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        } else if (state is Failure) {
          if (state.provider != null) {
            reAuth() {
              BlocProvider.of<ProfileBloc>(context)
                  .add(ReAuthentication(state.confirmPassword, 'facebook.com'));
            }

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        "Estamos seguros que eres tu, solamente debemos confirmar"),
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (v) {
                                state.confirmPassword = v;
                              },
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
                              validator: (v) {
                                if (v != null) {
                                  return Validators.isValidPassword(v)
                                      ? null
                                      : 'Contraseña invalida';
                                }else{
                                  return null;
                                }
                              },
                              obscureText: true,
                              autovalidate: true,
                              autocorrect: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Aceptar"),
                              onPressed: () {
                                reAuth();
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.message != null
                          ? state.message
                          : 'Se ha producido un error'),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        } else if (state is TakePhotoActionState) {
          BlocProvider.of<ProfileBloc>(context).add(TakePhotoActionDissmis());
          Widget cameraButton = FlatButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.camera),
                Text("Camara"),
              ],
            ),
            onPressed: () {
              getImage(ImageSource.camera).then((foto) {
                if (foto != null) {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(TakePhotoActionSuccess(foto));
                } else {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(TakePhotoActionDissmis());
                }
              });
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
              getImage(ImageSource.gallery).then((foto) {
                if (foto != null) {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(TakePhotoActionSuccess(foto));
                } else {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(TakePhotoActionDissmis());
                }
              });
              Navigator.pop(context);
            },
          );
          AlertDialog alerta = AlertDialog(
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
              return alerta;
            },
          );
        }
      },
      buildWhen: (previous, state) {
        return !(state is TakePhotoActionState) &&
            !(state is TakePhotoActionDissmisState) &&
            !(state is Failure) &&
            !(state is Loading);
      },
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileContent) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height + 48,
              child: Stack(
                children: <Widget>[
                  CreateBackground().createCircleBackground(context),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    right: MediaQuery.of(context).size.height * 0.025,
                    child: Text(
                      "${state.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Container(
                        height: 160,
                        width: 160,
                        child: state.foto != null
                            ? CircleAvatar(
                                backgroundImage: AssetImage(state.foto.path),
                              )
                            : CachedNetworkImage(
                                imageUrl: "${state.photoUrl}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(180),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SafeArea(
                        child: Container(
                          height: 200.0,
                        ),
                      ),
                      Card(
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
                              TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: "${state.name}",
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
                                  hintText: "${state.name}",
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
                                  hintText: "${state.email}",
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
                                  hintText: "${state.phoneNumber}",
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
                                        horizontal: 40, vertical: 8),
                                    child: Text(
                                      "Cambiar Contraseña",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<ProfileBloc>(context)
                                        .add(ChangeToEditPassword());
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
                        onPressed: state.faceLink
                            ? () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(UnLinkWithCredentials('facebook.com'));
                              }
                            : () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(LinkWithCredentials('facebook.com'));
                              },
                        text: state.faceLink
                            ? "Desvincular de Facebook"
                            : "Continuar con Facebook",
                      ),
                      GoogleSignInButton(
                        borderRadius: 5,
                        onPressed: state.googleLink
                            ? () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(UnLinkWithCredentials('google.com'));
                              }
                            : () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(LinkWithCredentials('google.com'));
                              },
                        text: state.googleLink
                            ? "   Desvincular de Google   "
                            : "   Continuar con Google   ",
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
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
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.256,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(ChangeToEditProfileContent());
                      },
                      child: Container(
                        width: 40,
                        height: 40,
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
          );
        } else if (state is EditProfileContent) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  CreateBackground().createCircleBackground(context),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    right: MediaQuery.of(context).size.height * 0.025,
                    child: Text(
                      "${state.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Container(
                        height: 160,
                        width: 160,
                        child: state.foto != null
                            ? CircleAvatar(
                                backgroundImage: AssetImage(state.foto.path),
                              )
                            : CachedNetworkImage(
                                imageUrl: "${state.photoUrl}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(180),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
                                hintText: "${state.name}",
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
                                  state.updateinfo.displayName = v;
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
                                hintText: "${state.name}",
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
                                onPressed: isEditable(state)
                                    ? () async {
                                        BlocProvider.of<ProfileBloc>(context)
                                            .add(UpdateUserProfile(
                                                state.updateinfo.displayName,
                                                state.foto));
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.21,
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(TakePhotoAction());
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
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.256,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(ChangeToProfileContent());
                      },
                      child: Container(
                        width: 40,
                        height: 40,
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
          );
        } else if (state is EditPassword) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  CreateBackground().createCircleBackground(context),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    right: MediaQuery.of(context).size.height * 0.025,
                    child: Text(
                      "${state.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left: MediaQuery.of(context).size.width * 0.04,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Container(
                        height: 160,
                        width: 160,
                        child: state.foto != null
                            ? CircleAvatar(
                                backgroundImage: AssetImage(state.foto.path),
                              )
                            : CachedNetworkImage(
                                imageUrl: "${state.photoUrl}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(180),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                      ),
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
                                validator: (v) {
                                  if (state.oldPassword != null) {
                                    return Validators.isValidPassword(v)
                                        ? null
                                        : 'Contraseña invalida';
                                  }else{
                                  return null;
                                }
                                },
                                obscureText: true,
                                autovalidate: true,
                                autocorrect: false,
                                onChanged: (v) {
                                  state.oldPassword = v;
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
                                validator: (v) {
                                  if (state.newPasswordOne != null) {
                                    return Validators.isValidPassword(v)
                                        ? null
                                        : 'Contraseña invalida';
                                  }else{
                                  return null;
                                }
                                },
                                onChanged: (v) {
                                  state.newPasswordOne = v;
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
                                validator: (v) {
                                  if (state.newPasswordTwo != null) {
                                    return v == state.newPasswordOne
                                        ? null
                                        : 'Las contraseñas no coinciden';
                                  }else{
                                  return null;
                                }
                                },
                                onChanged: (v) {
                                  state.newPasswordTwo = v;
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
                                  onPressed: isButtonEnable(
                                          state.oldPassword,
                                          state.newPasswordOne,
                                          state.newPasswordTwo)
                                      ? () {
                                          BlocProvider.of<ProfileBloc>(context)
                                              .add(ChangePassword(
                                                  email: state.email,
                                                  oldPassword:
                                                      state.oldPassword,
                                                  newPassword:
                                                      state.newPasswordOne));
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.256,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(ChangeToProfileContent());
                      },
                      child: Container(
                        width: 40,
                        height: 40,
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
          );
        } else {
          return Center(
            child: Container(
              child: FlareActor(
                'assets/animations/animation.flr',
                alignment: Alignment.center,
                animation: "Untitled",
              ),
            ),
          );
        }
      },
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
