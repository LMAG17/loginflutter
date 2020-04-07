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
  ProfileContent(this.name, this.photoUrl, this.title, this.email,
      this.phoneNumber, this.faceLink, this.googleLink);
  @override
  String toString() => 'Contenido del pefil';
}

class EditProfileContent extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final UserUpdateInfo updateinfo;
  EditProfileContent(this.name, this.photoUrl, this.title, this.updateinfo);
  @override
  String toString() => 'Editar contenido del pefil';
}

class EditPassword extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final String email;
  EditPassword({
    this.name,
    this.photoUrl,
    this.title,
    this.email,
  });
  @override
  String toString() => 'Editar Contraseña';
}

class Failure extends ProfileState {
  final String message;
  final String provider;
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

class TakePhotoActionState extends ProfileState {}
