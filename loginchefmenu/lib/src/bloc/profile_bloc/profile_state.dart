import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  String toString() => 'Estado de carga de datos';
}

class ProfileContent extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final String email;
  final String phoneNumber;
  final bool faceLink;
  final bool googleLink;
  final File foto;
  ProfileContent(this.name, this.photoUrl, this.title, this.email,
      this.phoneNumber, this.faceLink, this.googleLink,{this.foto});
  @override
  String toString() => 'Contenido del pefil';
}

class EditProfileContent extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final UserUpdateInfo updateinfo;
  final File foto;
  EditProfileContent(this.name, this.photoUrl, this.title, this.updateinfo,
      {this.foto});
  @override
  String toString() => 'Editar contenido del pefil';
}

class EditPassword extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final String email;
  final File foto;
  String oldPassword;
  String newPasswordOne;
  String newPasswordTwo;
  EditPassword({
    this.name,
    this.photoUrl,
    this.title,
    this.email,
    this.oldPassword,
    this.newPasswordOne,
    this.newPasswordTwo,
    this.foto,
  });
  @override
  String toString() => 'Editar Contraseña';
}

class Failure extends ProfileState {
  final String message;
  final String provider;
  String confirmPassword;
  Failure({
    this.provider,
    this.message,
  });
  @override
  String toString() => 'Fallo ';
}

class Success extends ProfileState {
  String toString() => 'Satisfactorio  ';
}

class Loading extends ProfileState {
  String toString() => 'Satisfactorio  ';
}

class TakePhotoActionState extends ProfileState {
  File foto;
}
