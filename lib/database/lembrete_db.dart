import 'package:app_projeto/database/openDatabaseDB.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:app_projeto/model/user.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class LembreteDAO {
  static const String _nomeTabela = 'Lembrete';
  static const String _col_id = 'id';
  static const String _col_iduser = 'iduser';
  static const String _col_nome = 'nome';
  static const String _col_datahora = 'datahora';
  static const String _col_local = 'local';

  static const String sqlTabelaLembrete = 'CREATE TABLE $_nomeTabela ('
      '$_col_id INTEGER PRIMARY KEY, '
      '$_col_iduser INTEGER, '
      '$_col_nome TEXT, '
      '$_col_datahora TEXT, '
      '$_col_local TEXT, '
      'FOREIGN KEY ($_col_iduser) REFERENCES User(id))';

  adicionar(Lembrete l) async {
    final Database db = await DatabaseHelper().initDb();
    await db.insert(_nomeTabela, l.toMap());

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: l.id,
        channelKey: 'keyCreate',
        title: l.nome,
        body: 'Lembrete em ${l.datahora} criado com sucesso!',
        displayOnForeground: true
      ));
    DateTime data = DateFormat('MM/dd/yyyy HH:mm').parse(l.datahora);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: l.id+100,
        channelKey: 'keyLembrete',
        title: l.nome,
        body: 'Lembrete em ${l.datahora} disparou!',
        displayOnForeground: true,
      ),
      schedule: NotificationCalendar.fromDate(date: data)
    );
  }

  atualizar(Lembrete l) async {
    final Database db = await DatabaseHelper().initDb();
    int result = await db
        .update(_nomeTabela, l.toMap(), where: 'id=?', whereArgs: [l.id]);

    return result;
  }

  Future<List<Lembrete>> getLembretes(User u) async {
    final Database db = await DatabaseHelper().initDb();

    final List<Map<String, dynamic>> maps = await db
        .query(_nomeTabela, where: "$_col_iduser = ?", whereArgs: [u.id]);

    return List.generate(maps.length, (i) {
      return Lembrete(
        maps[i][_col_id],
        maps[i][u.id.toString()],
        maps[i][_col_nome],
        maps[i][_col_datahora],
        maps[i][_col_local],
      );
    });
  }

  Future<int> deletar(Lembrete l) async {
    final Database db = await DatabaseHelper().initDb();

    int result =
        await db.delete(_nomeTabela, where: "id = ?", whereArgs: [l.id]);

    return result;
  }
}
