import 'package:shared_preferences/shared_preferences.dart';

class SavedUserData{

  static final SavedUserData _instancia = new SavedUserData._internal();

  factory SavedUserData(){
    return _instancia;
  }

  SavedUserData._internal();

  SharedPreferences _prefs;

  initPrefs() async {

    this._prefs = await SharedPreferences.getInstance();
  }

  // GET & SET para hasAcceptedDisclaimer

  get hasAcceptedDisclaimer{
    return _prefs.getBool('hasAcceptedDisclaimer') ?? false;
  }

  set hasAcceptedDisclaimer(bool value){
    _prefs.setBool('hasAcceptedDisclaimer', value);
  }

  // GET & SET para hasCreatedQR

  get hasCreatedQR{
    return _prefs.getBool('hasCreatedQR') ?? false;
  }

  set hasCreatedQR(bool value){
    _prefs.setBool('hasCreatedQR', value);
  }

  // GET & SET para dataID

  get dataID{
    return _prefs.getString('dataID') ?? '';
  }

  set dataID(String value){
    _prefs.setString('dataID', value);
  }

  // GET & SET para idToken

  get idToken{
    return _prefs.getString('idToken') ?? '';
  }

  set idToken(String value){
    _prefs.setString('idToken', value);
  }

  // GET & SET para uId

  get uid{
    return _prefs.getString('uid') ?? '';
  }

  set uid(String value){
    _prefs.setString('uid', value);
  }

}