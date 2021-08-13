import 'package:app_projeto/database/lembrete_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'lembrete_db.dart';

Future<Database> getDatabase() async{
  final String path = join(await getDatabasesPath(), 'dblembretes.db');

  return openDatabase(
    path,
    onCreate: (db, version){
      db.execute(LembreteDAO.sqlTabelaPaciente);
    },
    version: 1);
}

