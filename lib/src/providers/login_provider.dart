import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qr_app_cliente2/src/models/firebase_user_model.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class LoginProvider {

  final String _firebaseToken = 'AIzaSyBThFX1tranSrVdeJG1LnZCb48Ac1LzUjw';
  final _userData = SavedUserData();

  Future<Map<String, dynamic>> login( String email, String password) async{


    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('idToken') ) { 
      return { 'ok': true, 'token': decodedResp['idToken'], 'uid': decodedResp['localId']};
    } else {
      return { 'ok': false, 'message': decodedResp['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> newUser( String email, String password) async{

    final String _firebaseToken = 'AIzaSyBThFX1tranSrVdeJG1LnZCb48Ac1LzUjw';

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('idToken') ) { 
      _userData.idToken = decodedResp['idToken'];
      return { 'ok': true, 'token': decodedResp['idToken'] };
    } else {
      return { 'ok': false, 'message': decodedResp['error']['message'] };
    }
  }

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

  Future<Map<String, dynamic>> requestUser(String idToken, FirebaseUser firebaseUser) async{

    final userData = {
      'idToken'       : idToken,
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$_firebaseToken',
      body: json.encode(userData)
    );

    dynamic decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('users') ) { 
      firebaseUser = FirebaseUser.fromJson(decodedResp);

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

}