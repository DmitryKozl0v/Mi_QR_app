import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:qr_app_cliente2/src/models/client_model.dart';
import 'package:qr_app_cliente2/src/shared_preferences/shared_preferences.dart';


class ClientProvider{

  final String _url = 'https://qr-app-cliente.firebaseio.com';

  Future<Map <String, dynamic>> createClient (ClientModel client) async{

    final userData = new SavedUserData();

    final url = '$_url/cliente.json';

    final resp = await http.post(url, body: clientModelToJson(client));

    final Map <String, dynamic> decodedData = json.decode(resp.body);

    userData.dataID = decodedData['name'].toString();

    if ( decodedData.containsKey('name') ) { 
      return { 'ok': true, 'data': decodedData['name'],};
    } else {
      return { 'ok': false, 'message': decodedData['error'] };
    }

  }

  Future<ClientModel> requestClient (ClientModel client) async{

    final userData = new SavedUserData();

    final url = '$_url/cliente/${userData.dataID}.json';

    final resp = await http.get(url);

    final client = clientModelFromJson(resp.body);

    return client;
  }
}