import 'package:app_projeto/model/user.dart';

class Lembrete {

  int _id;
  User _user;
  String _datahora;
  String _local;
  String _nome;

  Lembrete(this._id, this._user, this._nome, this._datahora, this._local);

  Map<String, dynamic> toMap(){
    return{
      //'id': _id,
      'iduser': this._user.id,
      'nome': _nome,
      'datahora': _datahora,
      'local': _local,
    };
  }
    set id(int i){
    this._id = i;
  }
  int get id{
    return this._id;
  }

  User get user{
    return this._user;
  }

  String get nome{
    return this._nome;
  }
  
  String get datahora{
    return this._datahora;
  }
  
  String get local{
    return this._local;
  }

  @override
  String toString() {
    return 'Lembrete{id: $id, user proprietario: ${user.nome}: $nome, datahora: $datahora, local: $local}';
  }
}