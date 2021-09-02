import 'package:app_projeto/database/user_db.dart';
import 'package:app_projeto/model/user.dart';
import 'package:app_projeto/screens/android/menu_screen.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  int index;
  User user;
  UserScreen({User user}) {

    if (user == null) {
      this.index = -1;
    }else{
      this.index = user.id;
      this.user = user;
    }
  }

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  User _user;
  bool _isUpdate = false;

  @override
  Widget build(BuildContext context) {
    if (widget.index >= 0 && this._isUpdate == false) {
      debugPrint('editar index = ' + widget.index.toString());

      
      this._user = widget.user;
      this._nomeController.text = this._user.nome;
      this._senhaController.text = this._user.senha;
      this._isUpdate = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CRIAR USUARIO'),
        flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                ),
              ),
            ),
      ),


      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Defina o nome do usuario: ',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Nome obrigatorio';
                      }
                      return null;
                    },
                    controller: this._nomeController,
                    decoration: InputDecoration(hintStyle: TextStyle(color: Colors.white), hintText: "Nome do Lembrete"),
                    style: TextStyle(color: Colors.white,fontSize: 18)),
                 
                 Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Text(
                      'Defina a senha: ',
                      style: TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.justify,
                    ),
                 ),
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Senha obrigatoria';
                      }
                      return null;
                    },
                    controller: this._senhaController,
                    decoration: InputDecoration(hintStyle: TextStyle(color: Colors.white), hintText: "Nome do Lembrete"),
                    style: TextStyle(color: Colors.white,fontSize: 18)),
                
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [Color(0xFFC850C0), Color(0xFF4158D0)],
                          ),
                        ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5, 
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                          
                        ),
                        shadowColor: Colors.white10
                      ),

                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          User u = new User(
                              widget.index,
                              this._nomeController.text,
                              this._senhaController.text);

                            if (widget.index >= 0) {
                            User newuser = await UserDAO().atualizar(u);
                            
                            Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(builder: (context) => Menu(user: newuser)));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_user.nome} atualizado com sucesso')));
                          } else {
                            UserDAO().adicionar(u);
                            Navigator.of(context).pop();
                          }
                        } else {
                          debugPrint('formulario invalido');
                        }
                      },
                      
                      child: Center(
                        child: Text('Salvar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
