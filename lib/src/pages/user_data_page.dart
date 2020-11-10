import 'package:flutter/material.dart';

import 'package:qr_app_cliente2/src/utils/utils.dart' as utils;
import 'package:qr_app_cliente2/src/models/client_model.dart';
import 'package:qr_app_cliente2/src/providers/client_provider.dart';


class UserDataPage extends StatelessWidget {

  final clientProvider = new ClientProvider();
  final client = new ClientModel();

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

    final Future<ClientModel> requestedData = clientProvider.requestClient(client);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Center (
        child: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Container(

                width: size.width * 0.85,
                height: size.height * 0.75,
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
                child: _form(requestedData, size)
              ),
            ],
          ),
        ),
      ),
    );
  }

   _form(Future<ClientModel> requestedData, Size size){

    return Form(
      child: FutureBuilder(
        future: requestedData,
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<ClientModel> snapshot){
          if(snapshot.hasData){
            if(snapshot.data != null){
              return Column(
                children: <Widget>[
                  Text('Datos del cliente', style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data.dni.toString(), 'DNI'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data.nombre, 'Nombre'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data.apellido, 'Apellido'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data.direccion, 'Dirección'),
                  SizedBox(height: 15.0),
                  utils.createTextField(snapshot.data.telefono.toString(), 'Telefono'),
                  SizedBox(height: 15.0),
                ],
              );
            }
          }else{
            return Center(child: CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(39, 39, 39, 1.0),
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[400])
              ),
            );
          }
        }
      ),
    );
  }
}