import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginchefmenu/src/bloc/authentication_bloc/bloc.dart';
import 'package:loginchefmenu/src/bloc/login_bloc/bloc.dart';
import 'package:loginchefmenu/src/pages/utils/flutter_country_picker.dart';
import 'package:loginchefmenu/src/pages/utils/input_formater.dart';
import 'package:loginchefmenu/src/pages/utils/pinInput.dart';
import 'package:loginchefmenu/src/repository/user_repository.dart';
import 'package:loginchefmenu/src/ui/other_methods_screen.dart';

import 'utils/createBackground.dart';

class PhoneNumberPage extends StatefulWidget {
  final UserRepository _userRepository;
  PhoneNumberPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool sent = false;

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
      print('Aqui debe enviar el mensaje');
      print(verId);
      phoneVerificationId = verId;
      setState(() {
        
      sent = true;
      });
    };
    //En caso de que la verificacion sea exitosa
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      _auth.signInWithCredential(auth).then((value) {
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
          print('Invalid code/invalid authentication');
        }
      }).catchError((error) {
        //(Se debe informar al usuario) todo
        print('Ocurrio un error');
      });
    };
    //En caso de que la verificacion falle
    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      //En caso de que ocurra un error haciedo la verificacion (Se debe informar al usuario) todo
      if (exception.message.contains('not authorized'))
        print('No se encuentra autorizado para realizar esta accion.' +
            exception.message);
      else if (exception.message.contains('Network'))
        print('Por favor revise su conexion a internet e intentelo de nuevo');
      else
        print('Algo salio mal, intente mas tarde.');
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
    _auth.signInWithCredential(phoneCredential).then((value) {
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
      print('Algo salio mal, por favor intentalo de nuevo');
    });
  }

  final TextEditingController _phoneController = TextEditingController();
  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;
  ScrollController _scrollController = ScrollController();
  Country _countrySelected;
  MaskTextInputFormatter maskFormater =
      MaskTextInputFormatter(mask: '###-###-####');
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _phoneController.addListener(_onPhoneChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    _loginBloc.add(PhoneChanged(phone: _phoneController.text));
  }

  void _onFormSubmitted() {
    if (_countrySelected != null) {
      final number = ("+" +
          _countrySelected.dialingCode +
          _phoneController.text.replaceAll('-', ''));
      verifyPhone(number, context);
      // _loginBloc.add(LoginWithPhone(phoneNumber: number, context: context));
    } else {
      final number = ("+57" + _phoneController.text.replaceAll('-', ''));
      verifyPhone(number, context);
      // _loginBloc.add(LoginWithPhone(phoneNumber: number, context: context));
    }
  }

  bool isLoginButtonEnable(LoginState state) {
    return state.isValidPhone && accept;
  }

  bool accept = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        //tres casos
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Fallo al Iniciar Sesión"),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Enviando mensaje..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          sent = true;
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return sent
            ? smsBuild(context)
            : SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: <Widget>[
                      CreateBackground().createBigBackground(context),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.5,
                        left: MediaQuery.of(context).size.width * 0.08,
                        child: Text(
                          "Ingresar con tu celular",
                          style: TextStyle(fontSize: 24, color: Colors.black54),
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                            primaryColor: Colors.green,
                            hintColor: Colors.grey[800]),
                        child: Positioned(
                          top: MediaQuery.of(context).size.height * 0.55,
                          left: MediaQuery.of(context).size.width * 0.08,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: TextFormField(
                              inputFormatters: [maskFormater],
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              onTap: () {
                                _scrollController.animateTo(
                                    (MediaQuery.of(context).size.height * 0.34),
                                    curve: Curves.fastOutSlowIn,
                                    duration: Duration(milliseconds: 1600));
                              },
                              autocorrect: false,
                              autovalidate: true,
                              validator: (_) {
                                return !state.isValidPhone
                                    ? 'Numero invalido'
                                    : null;
                              },
                              decoration: InputDecoration(
                                icon: CountryPicker(
                                  showDialingCode: true,
                                  showName: false,
                                  onChanged: (Country country) {
                                    setState(() {
                                      _countrySelected = country;
                                    });
                                  },
                                  selectedCountry: _countrySelected,
                                ),
                                labelText: 'Escribe tu número',
                                hintText: "123-456-7890",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(32.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.65,
                        left: MediaQuery.of(context).size.width * 0.16,
                        right: MediaQuery.of(context).size.width * 0.16,
                        child: RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            child: Text(
                              "Verificar",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          onPressed: isLoginButtonEnable(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.74,
                        left: MediaQuery.of(context).size.width * 0.34,
                        right: MediaQuery.of(context).size.width * 0.16,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherMethodsScreen(
                                        userRepository: _userRepository)));
                          },
                          child: Text(
                            "Ingresar con otro metodo",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      // +57 3004896661 @
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.02,
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              value: accept,
                              onChanged: (value) {
                                setState(() {
                                  accept = !accept;
                                });
                              },
                            ),
                            Text(
                              "Acepto terminos y condiciones",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget smsBuild(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CreateBackground().createSlimBackground(context),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.16,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Text(
              "Mi código es:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.06,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => setState(() {
                    sent = false;
                  }),
                  child: Text(
                    "${_phoneController.text} 🖋️",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: _onFormSubmitted,
                  child: Text(
                    "REENVIAR",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.15,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: VerificationCodeInput(
                keyboardType: TextInputType.number,
                length: 6,
                autofocus: true,
                onCompleted: (String value) {
                  smsCode = value;
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.48,
            left: MediaQuery.of(context).size.width * 0.16,
            right: MediaQuery.of(context).size.width * 0.16,
            child: RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: Text(
                    "Continuar",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                onPressed: () {
                  signInWithPhoneNumber(context);
                }),
          ),
        ],
      ),
    );
  }
}
