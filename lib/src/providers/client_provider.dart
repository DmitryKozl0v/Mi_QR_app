import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:qr_app_cliente2/src/models/client_model.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class ClientProvider{

  final _databaseRef = FirebaseDatabase.instance.reference();
  // final _uuid = Uuid();
  // Map<String, dynamic> _tempMap;

  final String _url = 'https://qr-app-cliente.firebaseio.com';

  // Future<Map <String, dynamic>> createClient (ClientModel client) async{
  createClient (ClientModel client) async{

    final userData = new SavedUserData();

    // final key = _uuid.v4();

    // Map <String, String> auth = {"uid": "${userData.uId}"};

    // final authPayload = json.encode(auth);

    final url = '$_url/cliente/${userData.uId}.json?auth=${userData.idToken}';

    print(url);

    // client.uid = userData.uId;

    final resp = await http.post(url, body: clientModelToJson(client));

    final Map <String, dynamic> decodedData = json.decode(resp.body);

    // userData.dataID = decodedData['name'].toString();

    // // print(userData.dataID);

    // await _databaseRef.child('/cliente/$key/${userData.uId}/')
    //   .update(client.toJson());



    if ( decodedData.containsKey('name') ) { 
      // return { 'ok': true, 'data': decodedData['name'],};
      print('ok');
    } else {
      print(decodedData);
      // return { 'ok': false, 'message': decodedData['error'] };
    }

  }

  Future<ClientModel> requestClient (ClientModel client) async{

    final userData = new SavedUserData();

    final url = '$_url/cliente/${userData.uId}/${userData.dataID}.json';

    final resp = await http.get(url);

    final client = clientModelFromJson(resp.body);

    // print(client);

    return client;
  }

  updateUserMetaData(){

    final userData = SavedUserData();

    DatabaseReference ref = FirebaseDatabase.instance.reference().child('/metadata/${userData.uId}');

    Map<String, dynamic> loginData;

      

    
  }
}