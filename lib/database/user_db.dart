import 'package:app_projeto/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_projeto/database/openDatabaseDB.dart';



class UserDAO {
  static const String _nomeTabela = 'User';
  static const String _col_id = 'id';
  static const String _col_nome = 'nome';
  static const String _col_senha = 'senha';

  static const String sqlTabelaUser = 'CREATE TABLE $_nomeTabela ('
      '$_col_id INTEGER PRIMARY KEY, '
      '$_col_nome TEXT, '
      '$_col_senha TEXT)';

  adicionar(User u) async {
    final Database db = await DatabaseHelper().initDb();
    await db.insert(_nomeTabela, u.toMap());
  }

  atualizar(User u) async {
    final Database db = await DatabaseHelper().initDb();
    var result = await db
        .update(_nomeTabela, 
        u.toMap(), 
        where: 'id=?', 
        whereArgs: [u.id]);
    if(result == 1){
      var res = await db.query(_nomeTabela,
        where: "$_col_id = ?",
        whereArgs: [u.id],
        limit: 1);
      if (res.length > 0) {
        return User.map(res.first);
      }
    }
    return result;
  }
  

  Future<List<User>> getUsers() async {
    final Database db = await DatabaseHelper().initDb();

    final List<Map<String, dynamic>> maps = await db.query(_nomeTabela);

    return List.generate(maps.length, (i) {
      return User(
        maps[i][_col_id],
        maps[i][_col_nome],
        maps[i][_col_senha],
      );
    });
  }

  Future<User> getUserByName(String nome) async {
    final db = await DatabaseHelper().initDb();
    var res = await db.query(_nomeTabela,
        where: "$_col_nome = ?",
        whereArgs: [nome],
        limit: 1);
    if (res.length > 0) {
      return User.map(res.first);
    }else{
      return null;
    }
  }

  Future<int> deletar(int id) async {
    //returns number of items deleted
    final Database db = await DatabaseHelper().initDb();

    int result = await db.delete("User", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
        );

    return result;
  }

    Future<User> checkLogin(String nome, String senha) async {
    final db = await DatabaseHelper().initDb();
    var res = await db.query(_nomeTabela,
        where: "$_col_nome = ?  AND $_col_senha = ?",
        whereArgs: [nome, senha],
        limit: 1);
    if (res.length > 0) {
      return User.map(res.first);
    }else{
      return null;
    }

    
  }
}
