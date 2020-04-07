//imports
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:loginchefmenu/src/bloc/authentication_bloc/bloc.dart';

class UserRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

  //Constructor
  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      FacebookLogin facebookLogin})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin();

  //SignInWithGoogle
  Future<FirebaseUser> signInWithGoogle() async {
    //Utilizar el metodod de google para obtener el usuario del pop up
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //autenticacion de inicio de sesion
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    //obtener credenciales del proveedor de google
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //Validar si existe un usuario autenticado
    _auth.currentUser().then((value) async {
      //En caso de que este intentando vincular la cuenta
      if (value != null) {
        //en caso de que el email que intenta vincular sea el mismo que ya esta dentro
        if (googleUser.email == value.email) {
          //enlace de las cuentas (requiere de un inicio de sesion reciente)
          await value.linkWithCredential(credential).then((value) {
            //Aqui debe mostrar la alerta de que todo fue exitoso
            print(
              "Cuenta vinculada exitosamente.",
            );
            return _auth.currentUser();
          })
              //Aqui debe informar al usuario que se produjo un error
              .catchError((e) {
            throw (e.code);
          });
        }
        //en caso de que el email no sea el mismo
        else {
          throw ("El corrreo no coincide.");
        }
      }
      //En caso que desee iniciar sesion con la cuenta
      else {
        //Es necesario validar si el email ya existe con el fin de evitar que google sobrescriba las cuentas
        _auth
            .fetchSignInMethodsForEmail(email: googleUser.email)
            .then((value) async {
          //En caso de que si este vinculada anteriormente
          if (value != null && value.length > 0) {
            //En caso de que el email este vinculado, validar que este vinculado con google
            if (value.contains("google.com")) {
              //En caso de que sea exitoso (Se debe informar al usuario) todo
              await _auth.signInWithCredential(credential).then((value)  {
                return value.user;
              });
            }
            //En caso de que el correo este vinculado pero no con la cuenta de google  (Se debe informar al usuario) todo
            else {
              throw ("Este correo ya se encuentra registrado, debes iniciar sesion para vincularlo con google");
            }
          }
          //En caso de que no este vinculada se debe evitar que se sobrescriba  (Se debe informar al usuario) todo
          else {
            throw ("Debes registrarte primero");
          }
        });
      }
    });
  }

  //SignInWithFacebook
  Future<FirebaseUser> loginWithFacebook() async {
    //Utilizar el metodo del proveedor de faceboook para obtener los datos de inicio de sesion
    FacebookLoginResult result =
        await _facebookLogin.logIn(['email', 'public_profile']);
    //Se valida con un switch el estado del resultado obtenido
    switch (result.status) {
      //En caso de que el estado sea loggeado
      case FacebookLoginStatus.loggedIn:
        //Se obtiene el token del resultado
        FacebookAccessToken facebookAccessToken = result.accessToken;
        //Se obtiene el token de acceso desde el proveedor de facebook
        AuthCredential authCredential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        //Se valida si hay un usuario ya logueado
        _auth.currentUser().then((value) async {
          //En caso de que haya un usuario logueado
          if (value != null) {
            //Se hace el enlace de cuentas (no requiere validar si ya existe, este metodo con facebook no sobrescribe la cuenta)
            await value.linkWithCredential(authCredential).then((value) {
              //En caso de que haya sido exitoso (Se debe informar al usuario) todo
              print(
                "Cuenta vinculada exitosamente.",
              );
              return _auth.currentUser();
            })
                //En caso de que salga fallido (Se debe informar al usuario) todo
                .catchError((e) {
              throw (e.code);
            });
          }
          //En caso de que este intentando iniciar sesion
          else {
            //Se debe obtener el email de la persona desde graph de facebook
            final faceEmail = await getProfile(facebookAccessToken);
            //Se verifica que el email se encuentre enlazado a otras cuetas
            _auth
                .fetchSignInMethodsForEmail(email: faceEmail)
                .then((value) async {
              //En caso de que se encuentre enlazado
              if (value != null && value.length > 0) {
                //En caso de que este enlazado con facebook
                if (value.contains("facebook.com")) {
                  //Se realiza el inicio de sesion
                  await _auth.signInWithCredential(authCredential).then((user) async {
                    return user.user;
                  });
                }
                //En caso de que el email no se encuentre enlazado
                else {
                  throw ("Este correo ya se encuentra registrado, debes iniciar sesion para vincularlo con facebook");
                }
              }
              //En caso de que no se encuentre enlazado y este intentando iniciar sesion
              else {
                throw ("Debes registrarte primero");
              }
            });
          }
        });
        break;
      //En caso de que el usuario lo cancele
      case FacebookLoginStatus.cancelledByUser:
        break;
      //En caso de que ocurra algun error
      case FacebookLoginStatus.error:
        //(Se debe informar al usuario) todo
        throw (result.errorMessage);
        break;
    }
  }

  //Metodo para obtener el email del usuario de facebook desde el graph
  Future<String> getProfile(FacebookAccessToken facebookAccessToken) async {
    //Se obtiene la respuesta del graph en base al token de acceso
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookAccessToken.token}');
    //Se almacenan los datos de la persona en un mapa
    Map perfil = json.decode(graphResponse.body);
    //Se crea una variable para retornar el email
    String correo = perfil['email'];
    return correo;
  }

//Verificacion con numero de telefono
  //Se crean unas variables para mantener el codigo y el id de verificacion
  String smsCode;
  String phoneVerificationId;
  Future<void> verifyPhone(String phone, context) async {
    //Se crean las funciones anonimas necesarias para el envio y verificacion del mensaje de texto

    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      phoneVerificationId = verId;
    };
    //Se envia el mensaje
    final PhoneCodeSent smsCodeSent =
        (String verId, [int forceCodeRedend]) async {
      phoneVerificationId = verId;
    };
    //En caso de que la verificacion sea exitosa
    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential auth) async {
      await _auth.signInWithCredential(auth).then((value) {
        //Se verifica que la respuesta sea positiva
        if (value.user != null) {
          //Se verifica que este enlazado a un email
          if (value.user.email != null) {
            //Se le notifica al bloc el ingreso exitoso
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
          //En caso de que no tenga un email
          else {
            //Se le notifica al bloc para que se dirija a la pestaña de datos
            BlocProvider.of<AuthenticationBloc>(context)
                .add(LoggedInWithOutEmail());
          }
          return value.user;
        }
        //En caso de que se presente un error iniciando sesion
        else {
          //(Se debe informar al usuario) todo
          throw ('Invalid code/invalid authentication');
        }
      }).catchError((error) {
        //(Se debe informar al usuario) todo
        throw ('Ocurrio un error');
      });
    };
    //En caso de que la verificacion falle
    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      //En caso de que ocurra un error haciedo la verificacion (Se debe informar al usuario) todo
      if (exception.message.contains('not authorized'))
        throw ('No se encuentra autorizado para realizar esta accion.');
      else if (exception.message.contains('Network'))
        throw ('Por favor revise su conexion a internet e intentelo de nuevo');
      else
        throw ('Algo salio mal, intente mas tarde.');
    };
    //Metodo de firebase que hace la solicitud de verificacion con numero de telefono
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrive,
      timeout: const Duration(minutes: 2),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiedFailed,
    );
  }

//Metodo para iniciar sesion ingresando el codigo manualmente
  Future<void> signInWithPhoneNumber(context) async {
    //Se obtienen las credeciales del proveedor de numero telefonico
    final phoneCredential = PhoneAuthProvider.getCredential(
        verificationId: phoneVerificationId, smsCode: smsCode);
    //Inicio de sesion con numero de telefono
    await _auth.signInWithCredential(phoneCredential).then((value) {
      //Se valida si la cuenta tiene un email asociado
      if (value.user.email != null) {
        //Se le notifica al bloc el inicio de sesion exitoso
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      } else {
        //Se le notifica al bloc para que lo dirija a los datos personales
        BlocProvider.of<AuthenticationBloc>(context)
            .add(LoggedInWithOutEmail());
      }
    }).catchError((onError) {
      //(Se debe informar al usuario) todo
      throw ('Algo salio mal, por favor intentalo de nuevo');
    });
  }

  //Inicio se sesion
  Future<void> logInEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //Registro
  Future<void> signUpWithEmail(
      String email, String password, UserUpdateInfo userinfo) async {
    final FirebaseUser newuser = await _auth.currentUser();
    await newuser
        .updateProfile(userinfo)
        .then((_) {})
        .catchError((e) => throw (e));
    return await newuser
        .linkWithCredential(
            EmailAuthProvider.getCredential(email: email, password: password))
        .then((_) {})
        .catchError((error) {
      throw (error);
    });
  }

  //Salir
  Future<void> signOut() async {
    return Future.wait([_auth.signOut()]);
  }

  //Usuario dentro
  Future<bool> isSignedIn() async {
    final currentUser = await _auth.currentUser();
    return currentUser != null;
  }

  //Current User
  Future<FirebaseUser> getUser() async {
    return (await _auth.currentUser());
  }

  //Olvido la contraseña
  void forgotPassword(email) {
    _auth
        .sendPasswordResetEmail(email: email)
        .then((onValue) => print('Mensaje enviado exitosamente'))
        .catchError((onError) => throw (onError.code));
  }

  //Cambio de contraseña
  Future changePassword(
      String email, String oldPassword, String newPassword) async {
    final AuthResult result = await _auth
        .signInWithEmailAndPassword(email: email, password: oldPassword)
        .catchError((e) =>
            throw ('Error al cambiar contraseña, intenta probando con la correcta'));
    return await result.user
        .updatePassword(newPassword)
        .then((onValue) => print('cambio de contraseña exitoso'))
        .catchError((onError) =>
            throw ('Error al cambiar contraseña, intenta probando con la correcta'));
  }

  //Actualizar informacion del usuario
  Future updateUser(UserUpdateInfo userinfo) async {
    final FirebaseUser user = await _auth.currentUser();
    return await (user
        .updateProfile(userinfo)
        .then((onValue) {})
        .catchError((e) {
      print('Aqui se presenta un error' + e);
    }));
  }

  //Obtener Proveedores
  Future<List<String>> getProviders(String email) async {
    List<String> providers =
        await _auth.fetchSignInMethodsForEmail(email: email).catchError((e) {
      throw (e.code);
    });
    return providers;
  }

  //Desvilcular proveedores
  unLinkProvider(provider) async {
    final FirebaseUser user = await getUser();
    user.unlinkFromProvider(provider).catchError((e) {
      throw (e.code);
    });
  }
}
