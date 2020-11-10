import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:qr_app_cliente2/src/bloc/provider.dart';
import 'package:qr_app_cliente2/src/pages/change_password_page.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';

import 'package:qr_app_cliente2/src/pages/test_page.dart';
import 'package:qr_app_cliente2/src/pages/user_data_page.dart';
import 'package:qr_app_cliente2/src/pages/disclaimer_page.dart';
import 'package:qr_app_cliente2/src/pages/form_page.dart';
import 'package:qr_app_cliente2/src/pages/home_page.dart';
import 'package:qr_app_cliente2/src/pages/login_page.dart';
import 'package:qr_app_cliente2/src/pages/register_page.dart';

void main() async{


  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
  ]);

  // ignore: unused_local_variable
  final FirebaseApp app = await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: '1:853107174977:android:7d0048414f20f4bbf960c0',
      apiKey: 'AIzaSyBThFX1tranSrVdeJG1LnZCb48Ac1LzUjw',
      databaseURL: 'https://qr-app-cliente.firebaseio.com/',
      messagingSenderId: '853107174977',
      projectId: 'qr-app-cliente',
    )
  );

  final prefs = new SavedUserData();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'MiQR',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {

          'home'              :(BuildContext context)         => HomePage(),
          'login'             :(BuildContext context)         => LoginPage(),
          'register'          :(BuildContext context)         => RegisterPage(),
          'pass'              :(BuildContext context)         => ChangePasswordPage(),
          'form'              :(BuildContext context)         => FormPage(),
          'disclaimer'        :(BuildContext context)         => DisclaimerPage(),
          'data'              :(BuildContext context)         => UserDataPage(),
          'test'              :(BuildContext context)         => TestPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.black
        ),
      ),
    );
  }
// TODO: Considerar modo parental
// TODO: Buscar otra forma de implementar modo avión
}

