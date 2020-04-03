import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  String name;
  String photoUrl;
  String email;
  String phoneNumber;
  ProfileBloc({@required FirebaseUser user})
      : assert(user != null),
        this.name = user.displayName,
        this.photoUrl = user.photoUrl,
        email = user.email,
        phoneNumber = user.phoneNumber;
  @override
  ProfileState get initialState =>
      ProfileContent(name, photoUrl, 'Mi Perfil', email, phoneNumber);

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileEvent) {}
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
      );
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
      name = userinfo.displayName;
      photoUrl = userinfo.photoUrl;
      print(name + "===========================================" + photoUrl);
      yield ProfileContent(name, photoUrl, 'Mi Perfil', email, phoneNumber);
    } catch (e) {
      //yield Failure(e);
    }
  }

  Stream<ProfileState> _mapChangePasswordToState(
      {String email, String oldPassword, String newPassword}) async* {
    yield Loading();
    //yield EditPassword(requestState: 'Loading');
    try {
      await UserRepository().changePassword(email, oldPassword, newPassword);
      yield Success();
    } catch (e) {
      print('El resultado es un error' + e.toString());
      yield FailurePassword(
          name: name,
          photoUrl: photoUrl,
          title: 'Cambiar Contraseña',
          email: email,
          message: e.toString());
    }
  }
}
