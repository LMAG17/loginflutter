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
  bool faceLink = false;
  bool googleLink = false;
  UserRepository _userRepository;
  UserUpdateInfo updateinfo = UserUpdateInfo();
  ProfileBloc(
      {@required FirebaseUser user, @required UserRepository userRepository})
      : assert(user != null, userRepository != null),
        _userRepository = userRepository,
        name = user.displayName,
        photoUrl = user.photoUrl,
        email = user.email,
        phoneNumber = user.phoneNumber;
  @override
  ProfileState get initialState => ProfileInitial();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileEvent) {}
    if (event is LoadProviders) {
      yield* _mapLoadProviders();
    }
    if (event is ChangeToProfileContent) {
      yield ProfileContent(name, photoUrl, 'Mi Perfil', email, phoneNumber,
          faceLink, googleLink);
    }
    if (event is ChangeToEditProfileContent) {
      yield EditProfileContent(name, photoUrl, 'Editar mi Perfil', updateinfo);
    }
    if (event is ChangeToEditPassword) {
      yield EditPassword(
        name: name,
        photoUrl: photoUrl,
        title: 'Cambiar Contraseña',
        email: email,
      );
    }
    if (event is TakePhotoAction) {
      yield TakePhotoActionState();
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
    if (event is LinkWithCredentials) {
      yield* _mapLinkWithCredentialsToState(event.provider);
    }
    if (event is UnLinkWithCredentials) {
      yield* _mapUnLinkWithCredentialsToState(event.provider);
    }
    if (event is ReAuthentication) {
      yield* _mapReAuthenticationToState(event.confirmPassword, event.provider);
    }
  }

  Stream<ProfileState> _mapLoadProviders() async* {
    yield Loading();
    try {
      print('obteniendo proveedores');
      List provs = await _userRepository.getProviders(email);
      faceLink = provs.contains('facebook.com');
      googleLink = provs.contains('google.com');
      yield Success();
    } catch (e) {
      yield Failure(message: e);
    }
  }

  Stream<ProfileState> _mapUpdateUserProfileToState(
      {UserUpdateInfo userinfo}) async* {
    yield Loading();
    try {
      await _userRepository.updateUser(userinfo);
      name = userinfo.displayName;
      photoUrl = userinfo.photoUrl;
      print(name + "===========================================" + photoUrl);
      yield Success();
    } catch (e) {
      yield Failure(message: e.toString());
    }
  }

  Stream<ProfileState> _mapChangePasswordToState(
      {String email, String oldPassword, String newPassword}) async* {
    yield Loading();
    try {
      await _userRepository.changePassword(email, oldPassword, newPassword);
      yield Success();
    } catch (e) {
      yield Failure(message: e.toString());
    }
  }

  Stream<ProfileState> _mapLinkWithCredentialsToState(String provider) async* {
    yield Loading();
    if (provider == 'google.com') {
      try {
        _userRepository.signInWithGoogle();
        googleLink = true;
        yield Success();
      } catch (e) {
        if (e.contains("ERROR_REQUIRES_RECENT_LOGIN")) {
          yield Failure(provider: 'google.com');
        }
        yield Failure(message: e);
      }
    } else if (provider == 'facebook.com') {
      try {
         print('intenta con facebook');
         _userRepository.loginWithFacebook();
         faceLink = true;
        yield Success();
      } catch (e) {
        if (e.contains("ERROR_REQUIRES_RECENT_LOGIN")) {
          yield Failure(provider: 'facebook.com');
        }
        yield Failure(message: e);
      }
    }
  }

  Stream<ProfileState> _mapUnLinkWithCredentialsToState(
      String provider) async* {
    yield Loading();
    try {
      _userRepository.unLinkProvider(provider);
      if (provider == 'facebook.com') {
        faceLink = false;
      }
      if (provider == 'google.com') {
        googleLink = false;
      }
      yield Success();
    } catch (e) {
      if (e.contains("ERROR_REQUIRES_RECENT_LOGIN")) {
        yield Failure(provider: provider);
      }
      yield Failure(message: e);
    }
  }

  Stream<ProfileState> _mapReAuthenticationToState(
      String confirmPassword, String provider) async* {
    yield Loading();
    _userRepository.logInEmail(email, confirmPassword);
    try {
      if (provider == 'facebook.com') {
        _userRepository.loginWithFacebook();
        faceLink = true;
      }
      if (provider == 'google.com') {
        _userRepository.signInWithGoogle();
        googleLink = true;
      }
      yield Success();
    } catch (e) {
      yield Failure(message: e.toString());
    }
  }
}
