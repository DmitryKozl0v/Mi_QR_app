import 'package:flutter/material.dart';

void showErrorAlert(BuildContext context, String msg){

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
}

Widget createTextField(String initialValue, String labelText){

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: TextFormField(
      initialValue: initialValue,
      enabled: false,
      decoration: InputDecoration(
        icon: Icon(Icons.crop_landscape, color: Colors.deepPurple),
        labelText: labelText,
      ),
    ),
  );
}