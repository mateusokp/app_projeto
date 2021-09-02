// @dart=2.9
import 'dart:io';
import 'package:app_projeto/database/lembrete_db.dart';
import 'package:app_projeto/database/user_db.dart';
import 'package:app_projeto/model/user.dart';
import 'package:app_projeto/screens/android/login/login_screen.dart';
import 'package:app_projeto/screens/user/user_add.dart';
import 'package:app_projeto/screens/lembrete/lembrete_add.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class Menu extends StatefulWidget {
  User user;
  Menu({User user}) {
    this.user = user;
  }
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    //List<Lembrete> _lembretes = LembreteDAO.listarLembretes;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Alarmes Demo'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(padding: EdgeInsets.all(50.0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 85.0),
              child: _fotoAvatar(context),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                widget.user.nome,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  User logado = widget.user;
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => UserScreen(user: logado)))
                      .then((value) {});
                }),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context)
                      .push(
                          MaterialPageRoute(builder: (context) => LoginPage()))
                      .then((value) {});
                })
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black87,
            child: TextField(
              style: TextStyle(fontSize: 15, color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.black87,
              child: _futureBuilderLembrete(widget.user),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint(widget.user.toString());
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      LembreteScreen(lembrete: null, user: widget.user)))
              .then((value) {
            setState(() {
              AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
                if (!isAllowed) {
                  AwesomeNotifications().requestPermissionToSendNotifications();
                }
              });
              debugPrint('retornou do add lembrete');
            });
          });
        },
        child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
              ),
            ),
            child: const Icon(Icons.add)),
      ),
    );
  }
}

Widget _fotoAvatar(BuildContext context) {
  return CircleAvatar(
      backgroundImage: AssetImage('images/avatar.png'),
      radius: 60,
      child: ClipOval(
        child: SizedBox(
          height: double.infinity,
          width: 60,
        ),
      ));
}

List<Lembrete> _list = [];
Widget _futureBuilderLembrete(User user) {
  return FutureBuilder<List<Lembrete>>(
    initialData: _list,
    future: LembreteDAO().getLembretes(user),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          break;
        case ConnectionState.waiting:
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator(), Text('Loading')],
            ),
          );
        case ConnectionState.active:
          break;
        case ConnectionState.done:
          List<Lembrete> lembretes = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              final Lembrete l = lembretes[index];
              return ItemLembrete(l, onClick: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            LembreteScreen(lembrete: l, user: user)))
                    .then((value) {});
              }, onTapDelete: () {
                LembreteDAO().deletar(l);
              });
            },
            itemCount: lembretes.length,
          );
          break;
      }
      return Text('Problemas em gerar a lista');
    },
  );
}

class ItemLembrete extends StatefulWidget {
  final Lembrete _lembrete;
  final Function onClick;
  final Function onTapDelete;

  ItemLembrete(this._lembrete,
      {@required this.onClick, @required this.onTapDelete});

  @override
  _ItemLembreteState createState() => _ItemLembreteState();
}

class _ItemLembreteState extends State<ItemLembrete> {
  Widget _leadingLembrete() {
    DateTime dataHoraInicio =
        DateFormat('MM/dd/yyyy HH:mm').parse(this.widget._lembrete.datahora);
    // DateTime dataHoraFim = DateFormat('MM/dd/yyyy HH:mm').parse(this._lembrete.datafim);
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${dataHoraInicio.day}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${DateFormat('MMM').format(dataHoraInicio)}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        VerticalDivider(
          color: Colors.grey,
          indent: 10,
          endIndent: 10,
        ),
        Text(
          '${DateFormat('HH:mm').format(dataHoraInicio)}',
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _trailingLembrete(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: CircleBorder(),
      ),
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black26,
            // gradient: LinearGradient(
            //       colors: [Color(0xFFC850C0), Color(0xFF4158D0)],),
          ),
          child: Icon(Icons.delete, color: Colors.white)),
      onPressed: () {
        _showAlertDialog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
            ),
          ),
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: InkWell(
                      onTap: () {
                        AwesomeNotifications()
                            .isNotificationAllowed()
                            .then((isAllowed) {
                          if (!isAllowed) {
                            AwesomeNotifications()
                                .requestPermissionToSendNotifications();
                          }
                        });
                        this.widget.onClick();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _leadingLembrete(),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  this.widget._lembrete.nome,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  _trailingLembrete(context),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
              color: Colors.white30,
              indent: 10,
              endIndent: 10,
              thickness: 1.0,
              height: 0),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(45, 45, 45, 0.9),
            title:
                Text('Deletar Lembrete', style: TextStyle(color: Colors.white)),
            content: Text('Deseja mesmo excluir o lembrete?',
                style: TextStyle(color: Colors.white)),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Não'),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Color.fromRGBO(111, 0, 173, 1),
                  )),
              ElevatedButton(
                  onPressed: () {
                    this.widget.onTapDelete();
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Sim'),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Color.fromRGBO(111, 0, 173, 1),
                  ))
            ],
          );
        });
  }
}
