import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  FirebaseUser _user;
  String name;
  String photoUrl;
  String email;
  String phoneNumber;
  ProfileBloc({@required FirebaseUser user})
      : assert(user != null),
        _user = user,
        this.name = user.displayName,
        this.photoUrl = user.photoUrl,
        email = user.email,
        phoneNumber = user.phoneNumber;
  @override
  ProfileState get initialState => ProfileContent(name,photoUrl,'Mi Perfil',email,phoneNumber);

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileEvent) {
    }
    if (event is ChangeToProfileContent) {
      yield ProfileContent(name, photoUrl, 'Mi Perfil', email, phoneNumber);
    }
    if (event is ChangeToEditProfileContent) {
      yield EditProfileContent(name, photoUrl, 'Editar mi Perfil');
    }
    if (event is ChangeToEditPassword) {
      yield EditPassword(
          name: name,
          photoUrl: photoUrl,
          title: 'Cambiar Contraseña',
          email: email,
          isFailure: false,
          isSubmitting: false,
          isSuccess: false);
    }
    if (event is UpdateUserProfile) {
      yield* _mapUpdateUserProfileToState(userinfo: event.userinfo);
    }
    if (event is ChangePassword) {
      yield* _mapChangePasswordToState(
          email: event.email,
          oldPassword: event.oldPassword,
          newPassword: event.newPassword);
    }
    if (event is TakePhotoAction) {
      yield TakePhotoActionState();
    }
  }

  Stream<ProfileState> _mapUpdateUserProfileToState(
      {UserUpdateInfo userinfo}) async* {
    //yield Loading();
    try {
      await UserRepository().updateUser(userinfo);
      //yield Success();
    } catch (e) {
      //yield Failure(e);
    }
  }

  Stream<ProfileState> _mapChangePasswordToState(
      {String email, String oldPassword, String newPassword}) async* {
    yield EditPassword.loading();
    try {
      await UserRepository().changePassword(email, oldPassword, newPassword);
      yield EditPassword.success();
    } catch (e) {
      yield EditPassword.failure(message: e);
    }
  }
}
