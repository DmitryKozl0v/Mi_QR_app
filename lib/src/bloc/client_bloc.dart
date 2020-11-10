import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:qr_app_cliente2/src/bloc/validators.dart';

class ClientBloc with Validators{

  final _dniController            = new BehaviorSubject<int>();
  final _nombreController         = new BehaviorSubject<String>();
  final _apellidoController       = new BehaviorSubject<String>();
  final _direccionController      = new BehaviorSubject<String>();
  final _telefonoController       = new BehaviorSubject<int>();


  // Recuperar datos del stream
  Stream<int>    get dniStream            => _dniController.stream.transform<int>(validateDni);
  Stream<String> get nombreStream         => _nombreController.stream.transform<String>(validateString);
  Stream<String> get apellidoStream       => _apellidoController.stream.transform<String>(validateString);
  Stream<String> get direccionStream      => _direccionController.stream.transform<String>(validateString);
  Stream<int>    get telefonoStream       => _telefonoController.stream.transform<int>(validateTelefono);


  // Insertar valores al stream
  Function(int)    get changeDni            => _dniController.sink.add;
  Function(String) get changeNombre         => _nombreController.sink.add;
  Function(String) get changeApellido       => _apellidoController.sink.add;
  Function(String) get changeDireccion      => _direccionController.sink.add;
  Function(int)    get changeTelefono       => _telefonoController.sink.add;

  
  // Obtener el último valor ingresado a los streams
   int    get dni             => _dniController.value;
   String get nombre          => _nombreController.value;
   String get apellido        => _apellidoController.value;
   String get direccion       => _direccionController.value;
   int    get telefono        => _telefonoController.value;


  // Revisa que todos los campos sean válidos
  Stream<bool> get formValidStream => 
    Rx.combineLatest5(dniStream, nombreStream, apellidoStream, direccionStream, telefonoStream, (a, b, c, d, e) => true);


  // Eliminar los controllers
  dispose(){
    _dniController?.close();
    _nombreController?.close();
    _apellidoController?.close();
    _direccionController?.close();
    _telefonoController?.close();
  }
}