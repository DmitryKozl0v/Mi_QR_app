import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';

class DisclaimerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String idToken = ModalRoute.of(context).settings.arguments;
    final userData = new SavedUserData();

    return Scaffold(
      body: Stack(

        children: <Widget>[
          _crearFondo(),
          _crearDisclaimer(context, userData, idToken),
        ],
      )
    );
  }

  Widget _crearFondo(){

    return Container(

      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(39, 39, 39, 1.0)
    );
  }

  Widget _crearDisclaimer(BuildContext context, SavedUserData userData, String idToken){

    final titleStyle   = TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold
    );
    final parrafoStyle = TextStyle(
      fontSize: 20
    );

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width*0.9,
            height: size.height*0.7,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3.0,
                        offset: Offset(0.0, 5.0),
                        spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('ATENCION:', style: titleStyle,),
                SizedBox(height: 30.0,),
                Text('Al usar esta app, el usuario toma completa responsabilidad respecto a los datos que carga en el formulario, y se le recuerda que los mismos pueden ser verificados por quien escanea su código QR tan sólo con pedir su documentación.', style: parrafoStyle,),
                Expanded(child: Container(),),
                Row(
                  children: <Widget>[
                    _botonNo(size),
                    Expanded(child: Container(),),
                    _botonSi(context, userData, size, idToken),
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _botonNo(Size size){
    return RaisedButton(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: Center(child: Text('No acepto')),
      ),
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
      ),
      textColor: Colors.white,
      color: Colors.grey,
      onPressed: () => SystemNavigator.pop(),
    );
  }

  Widget _botonSi(BuildContext context, SavedUserData userData, Size size, String idToken){
    return RaisedButton(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.3,
        child: Center(child: Text('Si, acepto')),
      ),
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
      ),
      textColor: Colors.white,
      color: Colors.deepPurple,
      onPressed: (){

        userData.hasAcceptedDisclaimer = true;
        Navigator.pushReplacementNamed(context, 'home', arguments: idToken);

      } 
    );
  }
}