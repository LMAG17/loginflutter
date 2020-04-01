import 'package:flutter/material.dart';
import 'package:pushnoti/src/pages/home.dart';
import 'package:pushnoti/src/pages/mensaje_page.dart';

import 'src/providers/push_notifications_provider.dart';

void main() => runApp(_MyApp());

class _MyApp extends StatefulWidget {
  _MyApp({Key key}) : super(key: key);

  @override
  __MyAppState createState() => __MyAppState();
}

class __MyAppState extends State<_MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    final _pushProvider = PushNotificationProvider();
    _pushProvider.initNotifications();
    _pushProvider.mensajes.listen((argumento) {
      navigatorKey.currentState.pushNamed('mensaje', arguments: argumento);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => MyHomePage(),
        'mensaje': (BuildContext context) => MessagePage()
      },
    );
  }
}
