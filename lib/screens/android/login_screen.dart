import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_projeto/screens/android/menu_screen.dart';
import 'package:app_projeto/database/user_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_projeto/model/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus {notSignIn, signIn}

class _LoginState extends State<Login> implements LoginCallBack {
  LoginStatus _loginStatus = LoginStatus.notSignIn;  


  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _username, _password;

  LoginResponse _response;

  _LoginState() {
    _response = new LoginResponse(this);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.doLogin(_username, _password);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  var value;  
  getPref() async {  
    SharedPreferences preferences = await SharedPreferences.getInstance();  
    setState(() {  
      value = preferences.getInt("value");  
    
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;  
    });  
  } 

  signOut() async {  
  SharedPreferences preferences = await SharedPreferences.getInstance();  
  setState(() {  
    preferences.setInt("value", null);  
    preferences.commit();  
    _loginStatus = LoginStatus.notSignIn;  
  });  
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {  
    case LoginStatus.notSignIn:  
    _ctx = context;  

    return Scaffold(
      backgroundColor: Colors.black87,
      
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black87,
            padding: EdgeInsets.all(25.0),
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontStyle: FontStyle.italic),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(filled: true, fillColor: Color(0xFF292929), hintStyle: TextStyle(color: Colors.white), hintText: 'E-mail'),
                    onSaved: (val) => _username = val,
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(filled: true, fillColor: Color(0xFF292929), hintStyle: TextStyle(color: Colors.white), hintText: 'Senha'),
                    onSaved: (val) => _password = val,                  
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        ),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                                colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                              ),),
                        child: const Icon(Icons.arrow_forward, size: 40,)),
                      ),
                  ),
                  
                  RichText(text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'Novo usuário?    ' , style: TextStyle(color: Colors.white, fontSize: 18)),
                      TextSpan(text: 'Criar conta', 
                        style: TextStyle(color: Color(0xFF4158D0), fontSize: 18, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Menu()));
                          })
                    ]
                  ))

                   
                ],
              ),
            ),
          ),
        ),
      ),
    );

    case LoginStatus.signIn:  
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Menu()));
    break;
  }
  }

  savePref(int value,String user, String pass) async {  
    SharedPreferences preferences = await SharedPreferences.getInstance();  
    setState(() {  
      preferences.setInt("value", value);  
      preferences.setString("user", user);  
      preferences.setString("pass", pass);  
      preferences.commit();  
    });  
  } 

  @override  
  void onLoginError(String error) {  
    _showSnackBar(error);  
    setState(() {  
      _isLoading = false;  
    });  
  }  
  
  @override  
  void onLoginSuccess(User user) async {      
  
    if(user != null){  
      savePref(1,user.username, user.password);  
      _loginStatus = LoginStatus.signIn;  
    }else{  
      _showSnackBar("Login efetuado com sucesso");  
      setState(() {  
        _isLoading = false;  
      });  
    }  
  }
}