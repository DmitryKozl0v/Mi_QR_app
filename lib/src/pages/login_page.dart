import 'package:flutter/material.dart';

import 'package:qr_app_cliente2/src/models/login_model.dart';
import 'package:qr_app_cliente2/src/providers/client_provider.dart';

import 'package:qr_app_cliente2/src/utils/utils.dart' as utils;
import 'package:qr_app_cliente2/src/bloc/login_bloc.dart';
import 'package:qr_app_cliente2/src/providers/login_provider.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final loginData     = LoginData();
  final clientProvider = ClientProvider();
  final loginProvider = LoginProvider();
  final loginKey      = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _loginForm( context ),
          _isLoading ? Stack(children: <Widget>[
            Container(height: double.infinity,width: double.infinity, color: Colors.white24,),
            Center(child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(39, 39, 39, 1.0),
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[400])
              )
            )
          ]) : Container()
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final userData = new SavedUserData();
    final loginBloc = new LoginBloc();
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric( vertical: 50.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Form(
              key: loginKey,
              child: Column(
                children: <Widget>[
                  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                  SizedBox( height: 60.0 ),
                  _crearEmail( loginBloc ),
                  SizedBox( height: 30.0 ),
                  _crearPassword( loginBloc ),
                  SizedBox( height: 50.0 ),
                  _crearBoton(loginBloc, loginData, userData, size),
                  SizedBox( height: 20.0 ),
                  _crearBotonRegistro(size)
                ],
              ),
            ),
          ),
          FlatButton(
            child: Text('¿Olvidaste tu contraseña?'),
            onPressed: () => Navigator.pushNamed(context, 'pass'),
            textColor: Colors.blueAccent,
          ),
          SizedBox( height: 100.0 )
        ],
      ),
    );


  }

  Widget _crearEmail(LoginBloc loginBloc) {

    return StreamBuilder(
      stream: loginBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),

        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electrónico',
            // counterText: snapshot.data,
            errorText: snapshot.error
          ),
          onChanged: loginBloc.changeEmail,
          onSaved: (value) => loginData.email = value
        ),

      );


      },
    );


  }

  Widget _crearPassword(LoginBloc loginBloc) {

    return StreamBuilder(
      stream: loginBloc.loginPasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),

          child: TextFormField(
            maxLength: 32,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
              labelText: 'Contraseña',
              counterText: '',
              // counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: loginBloc.changeLoginPassword,
            onSaved: (value) => loginData.password = value
          ),
        );
      },
    );
  }

  Widget _crearBoton( LoginBloc loginBloc, LoginData loginData, SavedUserData userData, Size size) {

    return StreamBuilder(
      stream: loginBloc.loginValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            height: size.height * 0.062,
            width: size.width * 0.6,
            child: Center(child: Text('Ingresar')),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          // onPressed: snapshot.hasData ? ()=> _login(loginData, context, userData) : null
          onPressed: () => _login(loginData, context, userData)
        );
      },
    );
  }

  Widget _crearBotonRegistro(Size size){

    return RaisedButton(
      child: Container(
        height: size.height * 0.062,
        width: size.width * 0.6,
        child: Center(child: Text('Registrarse')),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
    );
  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final background = Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(39, 39, 39, 1.0),
    );

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );


    return Stack(
      children: <Widget>[
        background,
        fondoMorado,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, right: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: -10.0, child: circulo ),
        Positioned( bottom: 120.0, right: 20.0, child: circulo ),
        Positioned( bottom: 50.0, left: -20.0, child: circulo ),
        
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon( Icons.person_pin_circle, color: Colors.white, size: 100.0 ),
              SizedBox( height: 10.0, width: double.infinity ),
            ],
          ),
        )
      ],
    );
  }

  _login(LoginData loginData, BuildContext context, SavedUserData userData, ) async{

    FocusScope.of(context).requestFocus(FocusNode());   //Removes keyboard!
    userData.hasCreatedQR = false;

    setState(() {
      _isLoading = true;
    });
    
    loginKey.currentState.save();
    Map loginInfo = await loginProvider.firebaseAuthLogin(loginData.email, loginData.password);

    if(loginInfo['ok']){

      Map idTokenData = await loginProvider.firebaseAuthGetIdTokenExpirationTime();

      if(idTokenData['ok']){
        await clientProvider.updateUserMetaData(loginInfo['token'], loginInfo['uid'], idTokenData['date']);
      }

      Map userInfo = await loginProvider.firebaseAuthGetCurrentUser();

      if(userInfo['ok']){

        if(userData.uid == loginInfo['uid'] && userData.dataID != ''){

          setState(() {
            _isLoading = false;
          });
          userData.hasCreatedQR = true;
          Navigator.pushReplacementNamed(context, 'home', arguments: loginInfo['token']);

        }else if(userInfo['user'].displayName != null){

          setState(() {
            _isLoading = false;
          });
          userData.dataID = userInfo['user'].displayName;
          userData.uid = loginInfo['uid'];
          userData.hasCreatedQR = true;
          Navigator.pushReplacementNamed(context, 'home', arguments: loginInfo['token']);

        }else{

          setState(() {
            _isLoading = false;
          });
          userData.uid = loginInfo['uid'];
          Navigator.pushReplacementNamed(context, 'disclaimer', arguments: loginInfo['token']);

        }
      }else{

        setState(() {
            _isLoading = false;
          });
        utils.showErrorAlert(context, userInfo['message']);

      }
    }else{

      setState(() {
            _isLoading = false;
          });
      utils.showErrorAlert(context, loginInfo['message']);

    }
  }

  
}