import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final String email;
  final String phoneNumber;

  const ProfileInitial(
      this.name, this.photoUrl, this.title, this.email, this.phoneNumber);
  @override
  String toString() => 'Estado de carga de datos';
}

class ProfileContent extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final String email;
  final String phoneNumber;
  ProfileContent(
      this.name, this.photoUrl, this.title, this.email, this.phoneNumber);
  @override
  String toString() => 'Contenido del pefil';
}

class EditProfileContent extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;

  EditProfileContent(this.name, this.photoUrl, this.title);
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

class FailurePassword extends ProfileState {
  final String name;
  final String photoUrl;
  final String title;
  final String email;
  final String message;
  FailurePassword( {
    this.name,
    this.photoUrl,
    this.title,
    this.email,
    this.message,
  });
  @override
  String toString() => 'Editar Contraseña';
}

class ErrorState extends ProfileState {
  final String message;

  ErrorState({this.message});
  String toString() => 'Error $message';
}
class Success extends ProfileState {
  String toString() => 'Satisfactorio  ';
}

class Loading extends ProfileState {
  String toString() => 'Satisfactorio  ';
}


class TakePhotoActionState extends ProfileState {}
