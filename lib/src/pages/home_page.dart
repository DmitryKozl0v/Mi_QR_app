import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_app_cliente2/src/models/firebase_user_model.dart';
import 'package:qr_app_cliente2/src/providers/login_provider.dart';

import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget{

  final firebaseUser = FirebaseUser();
  final userData = new SavedUserData();
  final loginProvider = new LoginProvider();

  @override
  Widget build(BuildContext context) {
    String idToken = ModalRoute.of(context).settings.arguments;
    Permission.storage.request();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.replay),
          //   onPressed: () {
          //     userData.hasAcceptedDisclaimer  = false;
          //     userData.hasCreatedQR           = false;  
          //     userData.idToken                = '';
          //     userData.uId                    = '';
          //     userData.dataID                 = '';
          //   }
          // ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.pushNamed(context, 'data', arguments: idToken)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        backgroundColor: Colors.deepPurple,
        onPressed: () {

          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: Text('¿Está seguro que desea salir?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                  )
                ],
              );
            }
          );
        }
      ),

      body: _crearPagina(context)
    );
  }

  Stack _crearPagina(BuildContext context){

    return Stack(

      children: <Widget>[
        _crearFondo(),
        _crearQr(context),
        _crearBotonAForm(context, userData),
        
      ],
    );
  }

  Widget _crearFondo(){

    return Container(

      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(39, 39, 39, 1.0)
    );
  }

  Widget _crearQr(BuildContext context){

    final size = MediaQuery.of(context).size;
    final textStyle = TextStyle(fontSize: 25.0);

    if(!userData.hasCreatedQR){
      return Container();
    }else{
      return Center(
        child: Container(
          width: size.width*0.72,
          height: size.height*0.5,
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
            ],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text('Su código qr:', style: textStyle,),
              SizedBox(height: 10.0,),
              QrImage(
                data: userData.dataID,
                version: QrVersions.auto,
                size: size.width*0.65,                
              )
            ],
          )
        ),
      );
    }
  }

  Widget _crearBotonAForm(BuildContext context, SavedUserData userData){

    final size = MediaQuery.of(context).size;
    final textStyle = TextStyle(fontSize: 25.0,);

    if(userData.hasCreatedQR){
      return Container();
    }else{
      return Center(
        child: Container(
          width: size.width*0.72,
          height: size.height*0.5,
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
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'No ha cargado sus datos aún', 
                  style: textStyle, textAlign: TextAlign.center,
                ), 
                padding: EdgeInsets.symmetric(horizontal: 15.0),
              ),
              SizedBox(height: 100.0,),
              FlatButton(
                onPressed: !userData.hasCreatedQR? () => Navigator.pushNamed(context, 'form') : null,
                child: Text('Cargar',),
                color: Colors.deepPurple,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      );
    }    
  }
}