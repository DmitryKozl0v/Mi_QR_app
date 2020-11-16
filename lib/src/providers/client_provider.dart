import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:qr_app_cliente2/src/models/client_model.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class ClientProvider{

  final _userData = new SavedUserData();

  final String _url = 'https://qr-app-cliente.firebaseio.com';

  Future<Map <String, dynamic>> createClient (ClientModel client) async{
    
    final url = '$_url/cliente.json?auth=${_userData.idToken}';

    final resp = await http.post(
      url, 
      body: clientModelToJson(client)
    );

    final Map <String, dynamic> decodedData = json.decode(resp.body);

    _userData.dataID = decodedData['name'].toString();

    if ( decodedData.containsKey('name') ) { 
      return { 'ok': true, 'data': decodedData['name'],};
    } else {
      return { 'ok': false, 'message': decodedData['error'] };
    }
  }

  Future<ClientModel> requestClient (ClientModel client) async{

    final url = '$_url/cliente/${_userData.dataID}.json?auth=${_userData.idToken}';

    final resp = await http.get(url);

    final client = clientModelFromJson(resp.body);

    return client;
  }

  updateUserMetaData(String idToken, String uid, DateTime expirationTime) async{

    final Map <String, String> data = {'expirationTime': expirationTime.toString()};

    final url = '$_url/metadata/$uid.json?auth=$idToken';

    final resp = await http.patch(url, body: json.encode(data));

    final Map <String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
  }

  updateDataBase(String idToken, String uid) async{

     final Map <String, String> data = {'nombre': 'Gonzalo'};


     final url = '$_url/cliente.json?auth=$idToken';

     final resp = await http.post(url, body: json.encode(data));

     final Map <String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
  }
}