import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:app_projeto/screens/android/appalarme.dart';
import 'package:app_projeto/database/lembrete_db.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:app_projeto/database/user_db.dart';
import 'package:app_projeto/model/user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  _geraPrimeiros(){
    User u1 = User(1, 'teste@teste', '123');
    UserDAO().adicionar(u1);

    Lembrete l1 = Lembrete(12, u1, 'Tarefa 1 fdhjsakluryewqoihfdas',
    '12/12/2022 13:50', '07/01/2022 01:55');
    LembreteDAO().adicionar(l1);
  }
  if (Platform.isAndroid) {
    debugPrint('app no android');

    AwesomeNotifications().initialize('resource://drawable/logo', [
      NotificationChannel(
          channelKey: 'keyCreate',
          channelName: 'Novos Lembretes',
          channelDescription: 'Alertas de criar lembrete',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white),
      NotificationChannel(
          channelKey: 'keyLembrete',
          channelName: 'Lembretes',
          channelDescription: 'Alertas de lembretes',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ]);
    


    // _geraPrimeiros();
    
    runApp(AppAlarme());
  } else if (Platform.isIOS) {
    debugPrint('app no IOS');
  }
}
