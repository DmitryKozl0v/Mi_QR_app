import 'package:flutter/material.dart';
import 'package:qr_app_cliente2/src/models/firebase_user_model.dart';
import 'package:qr_app_cliente2/src/models/login_model.dart';

// import 'package:qr_app_cliente2/src/utils/utils.dart' as utils;
import 'package:qr_app_cliente2/src/bloc/login_bloc.dart';
import 'package:qr_app_cliente2/src/providers/login_provider.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class TestPage extends StatelessWidget {

  final loginData     = LoginData();
  final firebaseUser = new FirebaseUser();
  final loginProvider = LoginProvider();
  final loginKey      = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _loginForm( context ),
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
                  Text('TestPage', style: TextStyle(fontSize: 20.0)),
                  SizedBox( height: 60.0 ),
                  _crearEmail( loginBloc ),
                  SizedBox( height: 30.0 ),
                  _crearPassword( loginBloc ),
                  SizedBox( height: 30.0 ),
                  _crearBoton(loginBloc, loginData, userData, firebaseUser )
                ],
              ),
            ),
          ),
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
            counterText: snapshot.data,
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
      stream: loginBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),

          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: loginBloc.changePassword,
            onSaved: (value) => loginData.password = value
          ),

        );

      },
    );


  }

  Widget _crearBoton( LoginBloc loginBloc, LoginData loginData, SavedUserData userData, FirebaseUser firebaseUser) {

    return StreamBuilder(
      stream: loginBloc.loginValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          // onPressed: snapshot.hasData ? ()=> _login(loginData, context, userData) : null
          onPressed: () => _login(loginData, context, userData, firebaseUser)
        );
      },
    );
  }

  _login(LoginData loginData, BuildContext context, SavedUserData userData, FirebaseUser firebaseUser) async{

    // print('${loginData.email},${loginData.password}');
    // loginKey.currentState.save();
    // Map info = await loginProvider.login(loginData.email, loginData.password);
    // Map info = await loginProvider.updateUserName('Nicolas', userData.idToken);
    // Map info = await loginProvider.requestUser(userData.idToken, firebaseUser);
    

    // if(info['ok']){
      // print('ok');
      // print(info['user']);
    // if(userData.hasAcceptedDisclaimer){
    //   Navigator.pushReplacementNamed(context, 'home');
    // }else{
    //   Navigator.pushReplacementNamed(context, 'disclaimer');
    // }
    // }else{
      // utils.showErrorAlert(context, info['message']);
  }


  


  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
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
        fondoModaro,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, right: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: -10.0, child: circulo ),
        Positioned( bottom: 120.0, right: 20.0, child: circulo ),
        Positioned( bottom: -50.0, left: -20.0, child: circulo ),
        
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

}