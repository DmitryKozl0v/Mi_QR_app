import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:qr_app_cliente2/src/models/firebase_user_model.dart' as fum;
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class LoginProvider {

  final String _firebaseToken = 'AIzaSyBThFX1tranSrVdeJG1LnZCb48Ac1LzUjw';
  final _userData = SavedUserData();
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<Map<String, dynamic>> updateUserName(String userName, String idToken) async{

    final userData = {
      'displayName'       : userName,
      'idToken'           : idToken,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$_firebaseToken',
      body: json.encode(userData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('localId') ) { 
      print(decodedResp['displayName']);
      _userData.idToken = decodedResp['idToken'];
      return { 'ok': true, 'token': decodedResp['idToken'], 'uid': decodedResp['localId'] };
    } else {
      // return { 'ok': false};
      return { 'ok': false, 'message': decodedResp['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> requestUser(String idToken, fum.FirebaseUser firebaseUser) async{

    final userData = {
      'idToken'       : idToken,
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$_firebaseToken',
      body: json.encode(userData)
    );

    dynamic decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('users') ) { 
      firebaseUser = fum.FirebaseUser.fromJson(decodedResp);

    // print(firebaseUser.users[0].emailVerified);

      if(!firebaseUser.users[0].emailVerified){
        return { 'ok': false, 'message': 'EMAIL_NOT_VERIFIED' };
      }
      
      return { 'ok': true, 'user': firebaseUser.users[0].displayName};
    } else{
      print(decodedResp);
      return { 'ok': false, 'message': decodedResp['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> resetPassword( String email) async{


    final authData = {
      'requestType'       :'PASSWORD_RESET',
      'email'             : email,
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('email') ) { 
      return { 'ok': true};
    } else {
      return { 'ok': false, 'message': decodedResp['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> requestEmailVerification(String idToken, String email) async{


    final authData = {
      'requestType'       :'VERIFY_EMAIL',
      'idToken'           : idToken,
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('email') ) { 
      return { 'ok': true};
    } else {
      return { 'ok': false, 'message': decodedResp['error']['message'] };
    }
  }
   // ignore: missing_return
   Future<Map<String, dynamic>> firebaseAuthLogin(String email, String password) async{

    try {

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      String idToken = await userCredential.user.getIdToken();
      return { 'ok': true, 'token': idToken, 'uid': userCredential.user.uid};

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        return { 'ok': false, 'message': 'Usuario no encontrado'};
      } else if (e.code == 'wrong-password') {
        return { 'ok': false, 'message': 'Contraseña incorrecta'};
      }
    }
  }
  // ignore: missing_return
  Future<Map<String, dynamic>> firebaseAuthNewUser(String email, String password) async{

    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

      String idToken = await userCredential.user.getIdToken();
      return { 'ok': true, 'token': idToken, 'uid': userCredential.user.uid};

    } on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        return { 'ok': false, 'message': 'Email ya registrado'};
      }else if(e.code == 'invalid-email'){
        return { 'ok': false, 'message': 'Email inválido'};
      }
    }
  }

  Map<String, dynamic> firebaseAuthGetCurrentUser(){

    User user = _auth.currentUser;

    if(user != null){
      return { 'ok': true, 'user': user};
    }else{
      return { 'ok': false};
    }
  }

  Future<Map<String, dynamic>> firebaseAuthGetIdTokenExpirationTime() async{

    IdTokenResult tokenResult = await _auth.currentUser.getIdTokenResult();

    if (tokenResult.token != null){
      return {'ok': true, 'date': tokenResult.expirationTime};
    }else{
      return {'ok': false};
    }
  }

}