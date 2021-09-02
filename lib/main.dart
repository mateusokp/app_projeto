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

  _geraLembrete() {
    Lembrete l1 = Lembrete(12, 'Tarefa 1 fdhjsakluryewqoihfdas',
        '12/12/2022 13:50', '07/01/2022 01:55');

    LembreteDAO().adicionar(l1);
  }

  _geraUsuario() {
    User u1 = User(1, 'teste@teste', '123');

    UserDAO().adicionar(u1);
  }

  if (Platform.isAndroid) {
    debugPrint('app no android');

    AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
      NotificationChannel(
          channelKey: 'key1',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ]);

    // _geraLembrete();
    // _geraUsuario();
    
    runApp(AppAlarme());
  } else if (Platform.isIOS) {
    debugPrint('app no IOS');
  }
}
