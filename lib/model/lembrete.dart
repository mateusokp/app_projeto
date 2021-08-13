class Lembrete {

  int _id;
  String _datahora;
  String _datafim;
  String _nome;

  Lembrete(this._id, this._nome, this._datahora, this._datafim);

  Map<String, dynamic> toMap(){
    return{
      'id': _id,
      'nome': _nome,
      'datahora': _datahora,
      'datafim': _datafim,
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

  String get datafim{
    return this._datafim;
  }  

  @override
  String toString() {
    return 'Lembrete{id: $id, nome: $nome, datahora: $datahora, datafim: $datafim}';
  }
}