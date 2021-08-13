import 'package:app_projeto/database/openDatabaseDB.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class LembreteDAO {
  static final List<Lembrete> _lembretes = [];

  static const String _nomeTabela = 'lembrete';
  static const String _col_id = 'id';
  static const String _col_datahora = 'datahora';
  static const String _col_datafim = 'datafim';
  static const String _col_nome = 'nome';

  static const String sqlTabelaPaciente = 'CREATE TABLE $_nomeTabela ('
    '$_col_id INTEGER PRIMARY KEY, '
    '$_col_nome TEXT, '
    '$_col_datahora TEXT, '
    '$_col_datafim TEXT, )';

  adicionar(Lembrete l) async{
    _lembretes.add(l);

    final Database db = await getDatabase();
    await db.insert(_nomeTabela, l.toMap());
  }

  static Lembrete getLembrete(int index) {
    return _lembretes.elementAt(index);
  }

  static void atualizar(Lembrete l) {
    debugPrint('novo lembrete ' + l.toString());
    debugPrint('lista antiga $_lembretes');
    _lembretes.replaceRange(l.id, l.id + 1, [l]);
    debugPrint('lista nova $_lembretes');
  }

  static get listarLembretes {
    return _lembretes;
  }
}


