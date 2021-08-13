import 'package:flutter/material.dart';
import 'dart:io';
import 'package:app_projeto/screens/android/appalarme.dart';
import 'package:app_projeto/database/lembrete_db.dart';
import 'package:app_projeto/model/lembrete.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  
  _geraLembrete(){

        Lembrete l1 = Lembrete(12, 'Tarefa 1 fdhjsakluryewqoihfdas', '12/12/2022 13:50', '07/01/2022 01:55');

    LembreteDAO().adicionar(l1);
  }


  if(Platform.isAndroid){
    debugPrint('app no android');
    _geraLembrete();
    runApp(AppAlarme());
  }
  else if(Platform.isIOS){
    debugPrint('app no IOS');
  }

  //runApp(MyApp());
}