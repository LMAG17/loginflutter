import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

//Show profile info
class LoadProviders extends ProfileEvent {}

//Show profile info
class ChangeToProfileContent extends ProfileEvent {}

//Update info
class ChangeToEditProfileContent extends ProfileEvent {}

//change password
class ChangeToEditPassword extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final String name;
  final File foto;

  const UpdateUserProfile(this.name, this.foto,);
  @override
  List<Object> get props => [name,foto];
  @override
  String toString() {
    return 'ChangeToProfileContent {name:$name, foto:$foto} ';
  }
}

class ChangePassword extends ProfileEvent {
  final String email;
  final String oldPassword;
  final String newPassword;

  const ChangePassword(
      {@required this.email,
      @required this.oldPassword,
      @required this.newPassword});
  @override
  List<Object> get props => [email, oldPassword, newPassword];
  @override
  String toString() {
    return 'ChangePassword {email:$email,oldpassword:$oldPassword,newpassword:$newPassword}';
  }
}

class LinkWithCredentials extends ProfileEvent {
  final String provider;

  LinkWithCredentials(this.provider);
  @override
  List<Object> get props => [provider];
  @override
  String toString() {
    return 'LinkWithCredentials {provider:$provider}';
  }
}

class UnLinkWithCredentials extends ProfileEvent {
  final String provider;

  UnLinkWithCredentials(this.provider);
  @override
  List<Object> get props => [provider];
  @override
  String toString() {
    return 'UnLinkWithCredentials {provider:$provider}';
  }
}

class ReAuthentication extends ProfileEvent {
  final String provider;
  final String confirmPassword;
  ReAuthentication( this.confirmPassword,this.provider,);
  @override
  List<Object> get props => [confirmPassword,provider];
  @override
  String toString() {
    return 'ReAuthentication {provider:$provider}';
  }
}

class TakePhotoAction extends ProfileEvent {}

class TakePhotoActionSuccess extends ProfileEvent {
  final File foto;

  TakePhotoActionSuccess(this.foto);

}

class TakePhotoActionDissmis extends ProfileEvent {}
