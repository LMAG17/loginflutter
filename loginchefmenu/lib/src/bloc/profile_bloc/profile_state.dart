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
  

  const ProfileInitial(this.name, this.photoUrl, this.title,this.email,this.phoneNumber);
   @override
  String toString() =>'Estado de carga de datos';
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

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;
  EditPassword(
      {this.name,
      this.photoUrl,
      this.title,
      this.email,
      this.isSubmitting,
      this.isSuccess,
      this.isFailure,
      this.message});
  @override
  String toString() => 'Editar Contraseña';
  factory EditPassword.loading() {
    return EditPassword(isSubmitting: true, isSuccess: false, isFailure: false);
  }

  factory EditPassword.empty() {
    return EditPassword(isSubmitting: false, isSuccess: false, isFailure: false);
  }
  factory EditPassword.success() {
    return EditPassword(isSubmitting: false, isSuccess: true, isFailure: false);
  }

  factory EditPassword.failure({message}) {
    String message;
    return EditPassword(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  // Funciones adicionales: copywith - update
  EditPassword copyWith({bool isSubmitting, bool isSuccess, bool isFailure}) {
    return EditPassword(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  EditPassword update(
      {bool isEmailValid, bool isPasswordValid, bool isValidPhone}) {
    return copyWith(isSubmitting: false, isSuccess: false, isFailure: false);
  }
}

class TakePhotoActionState extends ProfileState {}
