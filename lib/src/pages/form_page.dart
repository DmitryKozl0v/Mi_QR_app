
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_app_cliente2/src/bloc/client_bloc.dart';
import 'package:qr_app_cliente2/src/bloc/provider.dart';

import 'package:qr_app_cliente2/src/models/client_model.dart';

import 'package:qr_app_cliente2/src/utils/utils.dart' as utils;

import 'package:qr_app_cliente2/src/providers/client_provider.dart';
import 'package:qr_app_cliente2/src/providers/login_provider.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';

class FormPage extends StatelessWidget {

  final client   = new ClientModel();
  final clientProvider = new ClientProvider();
  final loginProvider = new LoginProvider();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _crearPagina(context),
    );
  }


  Stack _crearPagina(BuildContext context){

    return Stack(

      children: <Widget>[
        _crearFondo(),
        _datosForm(context),
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

  Widget _datosForm(BuildContext context){

    final userData = new SavedUserData();
    final clientBloc = Provider.clientBloc(context);
    final size = MediaQuery.of(context).size;


    final RegExp nameRegExp = RegExp(r'^[a-z A-Z ñ Ñ á é í ó ú Á É Í Ó Ú,.\-]+$');
    final RegExp dirRegExp = RegExp(r'^[a-z A-Z ñ Ñ á é í ó ú Á É Í Ó Ú 0-9,.\-]+$');

    return SingleChildScrollView(

      child: Column(
        children: <Widget>[
          Center(
            child: SafeArea(
              child: Container(

                width: size.width * 0.85,
                margin: EdgeInsets.symmetric(vertical: 30.0),
                padding: EdgeInsets.symmetric(vertical: 50.0),
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

                child: Form(

                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Text('Ingreso de datos', style: TextStyle(fontSize: 20.0),),
                      SizedBox(height: 15.0),
                      _crearDNI(clientBloc),
                      SizedBox(height: 15.0),
                      _crearNombre(clientBloc, nameRegExp),
                      SizedBox(height: 15.0),
                      _crearApellido(clientBloc, nameRegExp),
                      SizedBox(height: 15.0),
                      _crearDireccion(clientBloc, dirRegExp),
                      SizedBox(height: 15.0),
                      _crearTelefono(clientBloc),
                      SizedBox(height: 15.0),
                      _crearBoton(context ,clientBloc, userData),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearBoton(BuildContext context, ClientBloc clientBloc, SavedUserData userData){

    return StreamBuilder(
      stream: clientBloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? ()=> _submit(clientBloc, context, userData) : null,
          // onPressed: ()=> _submit(clientBloc, context, userData),
        );
      }
    );
  }

  _submit(ClientBloc clientBloc, BuildContext context, SavedUserData userData) async{

    formKey.currentState.save();

    Map <String, dynamic> createClientResp = await clientProvider.createClient(client);

    if(createClientResp['ok']){

      userData.hasCreatedQR = true;

      await loginProvider.updateUserName(userData.dataID, userData.idToken);
    
      Navigator.pushReplacementNamed(context, 'home');

      print('ok');
    }else{
      utils.showErrorAlert(context, createClientResp['message']);
    }
    
  }

  Widget _crearDNI(ClientBloc clientBloc){

    return StreamBuilder(
      stream:clientBloc.dniStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            // initialValue: clientBloc.dni.toString(),
            maxLength: 8,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              icon: Icon(Icons.crop_landscape, color: Colors.deepPurple),
              helperText: 'Sin puntos entre los dígitos',
              labelText: 'DNI',
              counterText: '',
              errorText: snapshot.error
            ),
            onChanged: (value) => clientBloc.changeDni(int.parse(value)),
            onSaved: (value) => client.dni = int.parse(value),
          ),
        );
      }
    );
  }

  Widget _crearNombre(ClientBloc clientBloc, RegExp nameRegExp){

    return StreamBuilder(
      stream:clientBloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(nameRegExp)],
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.deepPurple),
              helperText: 'Como figura en el documento',
              labelText: 'Nombre',
              // counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => clientBloc.changeNombre(value.toUpperCase()),
            onSaved: (value) => client.nombre = value.toUpperCase(),
          ),
        );
      }
    );
  }

  Widget _crearApellido(ClientBloc clientBloc, RegExp nameRegExp){

    return StreamBuilder(
      stream:clientBloc.apellidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(nameRegExp)],
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.deepPurple),
              helperText: 'Como figura en el documento',
              labelText: 'Apellido',
              // counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => clientBloc.changeApellido(value.toUpperCase()),
            onSaved: (value) => client.apellido = value.toUpperCase(),
          ),
        );
      }
    );
  }

  Widget _crearDireccion(ClientBloc clientBloc, RegExp dirRegExp){

    return StreamBuilder(
      stream:clientBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(dirRegExp)],
            decoration: InputDecoration(
              icon: Icon(Icons.home, color: Colors.deepPurple),
              helperText: 'Incluya numeración',
              labelText: 'Direccion',
              // counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => clientBloc.changeDireccion(value.toUpperCase()),
            onSaved: (value) => client.direccion = value.toUpperCase(),
          ),
        );
      }
    );
  }

  Widget _crearTelefono(ClientBloc clientBloc){

    return StreamBuilder(
      stream:clientBloc.telefonoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              icon: Icon(Icons.phone, color: Colors.deepPurple),
              helperText: 'Nro de area + su número',
              labelText: 'Telefono',
              // counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => clientBloc.changeTelefono(int.parse(value)),
            onSaved: (value) => client.telefono = int.parse(value),
          ),
        );
      }
    );
  }
}