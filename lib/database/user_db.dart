import 'package:app_projeto/model/user.dart';
import 'dart:async';
import 'package:app_projeto/database/database_helper.dart';

class LoginCtr {
DatabaseHelper con = new DatabaseHelper();
  //inserir
  Future<int> saveUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }
  //deletar
  Future<int> deleteUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.delete("User");
    return res;
  }
  Future<User> getLogin(String user, String password) async {
    var dbClient = await con.db;
    var res = await dbClient.rawQuery("SELECT * FROM user WHERE username = '$user' and password = '$password'");
    
    if (res.length > 0) {
      return new User.fromMap(res.first);
    }
    return null;
  }
  Future<List<User>> getAllUser() async {
    var dbClient = await con.db;
    var res = await dbClient.query("user");
    
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : null;
    return list;
  }
}

abstract class LoginCallBack {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginResponse {
  LoginCallBack _callBack;
  LoginRequest loginRequest = new LoginRequest();
  LoginResponse(this._callBack);
  doLogin(String username, String password) {
    loginRequest
        .getLogin(username, password)
        .then((user) => _callBack.onLoginSuccess(user))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  } 
}

class LoginRequest {
  LoginCtr con = new LoginCtr();
 Future<User> getLogin(String username, String password) {
    var result = con.getLogin(username,password);
    return result;
  }
}