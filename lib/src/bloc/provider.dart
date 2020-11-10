import 'package:flutter/material.dart';

import 'package:qr_app_cliente2/src/bloc/client_bloc.dart';
export 'package:qr_app_cliente2/src/bloc/client_bloc.dart';
import 'package:qr_app_cliente2/src/bloc/login_bloc.dart';
export 'package:qr_app_cliente2/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget{

  final _clientBloc = ClientBloc();
  final _loginBloc  = LoginBloc();


  static Provider _instancia;

  factory Provider({Key key, Widget child}){

    if(_instancia == null ){
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }


  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ClientBloc clientBloc (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._clientBloc;
  }

  static LoginBloc loginBloc (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

}