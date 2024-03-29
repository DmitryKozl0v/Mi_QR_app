import 'package:flutter/material.dart';

import 'package:qr_app_cliente2/src/utils/utils.dart' as utils;
import 'package:qr_app_cliente2/src/bloc/provider.dart';
import 'package:qr_app_cliente2/src/models/login_model.dart';
import 'package:qr_app_cliente2/src/providers/login_provider.dart';


class ChangePasswordPage extends StatefulWidget {

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  
  final loginData     = LoginData();
  final loginProvider = LoginProvider();
  final registerKey   = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _registerForm( context ),

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

  Widget _registerForm(BuildContext context) {

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
              key: registerKey,
              child: Column(
                children: <Widget>[
                  Text('Recuperar contraseña', style: TextStyle(fontSize: 20.0)),
                  SizedBox( height: 60.0 ),
                  Text('Ingresa el email de tu cuenta:'),
                  SizedBox( height: 15.0 ),
                  _crearEmail( loginBloc ),
                  SizedBox( height: 30.0 ),
                  _crearBoton( loginBloc, loginData)
                ],
              ),
            ),
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

  Widget _crearBoton( LoginBloc loginBloc, LoginData loginData) {

    return StreamBuilder(
      stream: loginBloc.loginValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Enviar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: ()=> _submit(loginBloc ,context)
        );
      },
    );
  }

  _submit(LoginBloc loginBloc ,BuildContext context) async{

    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _isLoading = true;
    });

    registerKey.currentState.save();
    Map info = await loginProvider.resetPassword(loginData.email);

    if(info['ok']){
      setState(() {
        _isLoading = false;
      });
      _showAlert(context);
    }else{
      setState(() {
        _isLoading = false;
      });
      utils.showErrorAlert(context, info['message']);
    }
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
        Positioned( top: 90.0, left: 30.0, child: circulo       ),
        Positioned( top: -40.0, right: -30.0, child: circulo    ),
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

void _showAlert(BuildContext context){

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text('Se te ha enviado un email con la información para que recuperes tu contraseña'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          )
        ],
      );
    },
  );
}
}