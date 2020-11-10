import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel{
    ClientModel({
        // this.uid             ='',
        this.dni             = 0,
        this.nombre          = '',
        this.apellido        = '',
        this.direccion       = '',
        this.telefono        = 0,

    });

    // String uid; 
    int dni;
    String nombre;
    String apellido;
    String direccion;
    int telefono;

    factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        dni           : json["dni"],
        nombre        : json["nombre"],
        apellido      : json["apellido"],
        direccion     : json["direccion"],
        telefono      : json["telefono"],
    );

    Map<String, dynamic> toJson() => {
        // "uid"             : uid,
        "dni"             : dni,
        "nombre"          : nombre,
        "apellido"        : apellido,
        "direccion"       : direccion,
        "telefono"        : telefono,
    };
}