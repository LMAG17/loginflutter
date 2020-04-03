import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

//Show profile info
class ChangeToProfileContent extends ProfileEvent {}

//Update info
class ChangeToEditProfileContent extends ProfileEvent {}

//change password
class ChangeToEditPassword extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final UserUpdateInfo userinfo;

  const UpdateUserProfile({@required this.userinfo});
  @override
  List<Object> get props => [userinfo];
  @override
  String toString() {
    return 'ChangeToProfileContent {userinfo:$userinfo}';
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

class TakePhotoAction extends ProfileEvent {}
