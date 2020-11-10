import 'dart:async';



class Validators {


  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) {


      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if (email.length > 40){
        sink.addError('Email es demasiado largo');
      }else if (!regExp.hasMatch( email )){
        sink.addError('Email no es correcto');
      }else{
        sink.add( email );
      }

    }
  );


  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {

      Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
      RegExp regExp   = new RegExp(pattern);

      if (password.length > 32){
        sink.addError('Menos de 32 caracteres por favor');
      }else if(!regExp.hasMatch(password)){
        sink.addError('Su contraseña no contiene los caracteres pedidos');
      }else{
        sink.add( password );
      }

    }
  );

  final validateString = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink){
 
      if(value.length > 40){
        sink.addError('Ha ingresado demasiados caracteres');
      }else{
        sink.add(value.trim());
      }
    }
  );

  final validateDni = StreamTransformer<int, int>.fromHandlers(
    handleData: (dni, sink){

      final String dniToString = dni.toString();

      if (!(dniToString.length >= 7 && dniToString.length < 9)){
        sink.addError('Ha ingresado menos o más números de los requeridos');
      }else{
        sink.add(num.parse(dniToString));
      }
    }
    
  );

  final validateTelefono = StreamTransformer<int, int>.fromHandlers(
    handleData: (telefono, sink){
      if(telefono.toString().length < 10){
        sink.addError('El número ingresado es muy corto');
      }else{
        sink.add(telefono);
      }
    }
  );

}