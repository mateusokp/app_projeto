class Lembrete {

  int _id;
  String _datahora;
  String _local;
  String _nome;

  Lembrete(this._id, this._nome, this._datahora, this._local);

  Map<String, dynamic> toMap(){
    return{
      //'id': _id,
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
    return 'Paciente{id: $id, nome: $nome, datahora: $datahora, local: $local}';
  }
}