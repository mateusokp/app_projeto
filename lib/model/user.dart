class User {
  int _id;
  String _nome;
  String _senha;

  User(this._id,this._nome, this._senha);

  User.map(dynamic obj){
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._senha = obj['senha'];
  }


  set id(int i){
    this._id = i;
  }
  int get id => this._id;
  String get nome => this._nome;
  String get senha => this._senha;

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      //"id" : _id,
      "nome" : _nome,
      "senha" : _senha,
    };
  }
    @override
  String toString() {
    return 'User{id: $id, nome: $nome}';
  }
}