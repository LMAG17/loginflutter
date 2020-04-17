import 'package:flutter/material.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget circulo() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.08),
        shape: BoxShape.circle,
      ),
    );
  }

  String user;
  String password;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: size.height / 2,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromRGBO(147, 206, 222, 1),
                    Color.fromRGBO(147, 206, 222, 1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 180, left: 3, child: circulo()),
          Positioned(top: 20, left: 50, child: circulo()),
          Positioned(top: 200, left: 400, child: circulo()),
          Positioned(top: 50, left: 300, child: circulo()),
          Positioned(top: 300, left: 200, child: circulo()),
          Positioned(
            top: size.height * 0.1,
            left: size.width * 0.3,
            child: Container(
              height: size.width * 0.35,
              width: size.width * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.remove_red_eye,
                size: 100,
                color: Colors.cyan,
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.4,
            left: size.width * 0.09,
            child: Card(
              borderOnForeground: true,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                height: size.height * 0.4,
                width: size.width * 0.8,
                padding: EdgeInsets.all(16),
                child: Theme(
                  data: ThemeData(
                    //primaryColor: Colors.indigoAccent,
                    hintColor: Colors.grey[800],
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.mail_outline,
                              color: Colors.cyan,
                            ),
                            labelText: 'Usuario',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(32.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            fillColor: Colors.white70,
                          ),
                          onChanged: (v) {
                            setState(() {
                              user = v;
                            });
                          }),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.cyan,
                          ),
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(32.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70,
                        ),
                        obscureText: true,
                        autovalidate: true,
                        autocorrect: false,
                        onChanged: (v) {
                          setState(() {
                            password = v;
                          });
                        },
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.cyan[600],
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            child: Text(
                              "Ingresar",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          onPressed: () {
                            if (user == 'admin' && password == 'admin') {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                            } else {
                              Scaffold.of(context)..showSnackBar(SnackBar(
                                content: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Error al iniciar sesion'),
                                    Icon(Icons.error_outline),
                                  ],
                                ),
                              ));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
