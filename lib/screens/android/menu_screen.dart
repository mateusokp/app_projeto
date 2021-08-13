import 'dart:io';
import 'package:app_projeto/database/lembrete_db.dart';
import 'package:app_projeto/lembrete/lembrete_add.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    
    List<Lembrete> _lembretes = LembreteDAO.listarLembretes;

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
                child: Text('Nome de Usuario',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,),
              ),
              ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    'Lembretes Antigos',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      body: Column(children: [
        Container(
          color: Colors.black87,
          child: TextField(
            style: TextStyle(fontSize: 15, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              hintStyle: TextStyle(fontSize: 15, color: Colors.white),
              prefixIcon: Icon(Icons.search, color: Colors.white,)
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color:Colors.black87,
            child: ListView.builder(
              itemCount: _lembretes.length,
              itemBuilder: (context, index){
                final Lembrete p = _lembretes[index];
                return ItemLembrete(p, onClick: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LembreteScreen(index: index))
                  ).then((value){
                    setState(() {
                      debugPrint('voltou do editar');
                    });
                  });
                },);
              }
            ),
          ),
        ),
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LembreteScreen()
          )).then((value) {
            
            setState(() {
              debugPrint('retornou do add lembrete');
            });
          });
          // Add your onPressed code here!
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                  colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                ),),
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

class ItemLembrete extends StatelessWidget {

  final Lembrete _lembrete;
  final Function onClick;


  ItemLembrete(this._lembrete, {@required this.onClick});

  Widget _leadingLembrete(){
    DateTime dataHoraInicio = DateFormat('MM/dd/yyyy HH:mm').parse(this._lembrete.datahora);
    // DateTime dataHoraFim = DateFormat('MM/dd/yyyy HH:mm').parse(this._lembrete.datafim);
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${dataHoraInicio.day}', style: TextStyle(color: Colors.white, fontSize: 29,fontWeight: FontWeight.bold),),
            Text('${DateFormat('MMM').format(dataHoraInicio)}', style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),
        VerticalDivider(
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
        Text('${DateFormat('HH:mm').format(dataHoraInicio)}', style: TextStyle(color: Colors.white, fontSize: 17,fontWeight: FontWeight.bold),),
      ],
    );
  }

   Widget _trailingLembrete(){
    return TextButton(
      style: TextButton.styleFrom(
        shape: CircleBorder(),),
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
      onPressed: null,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Container(
          
          height: MediaQuery.of(context).size.height*0.15,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                ),),
          child: InkWell(
            onTap: () => this.onClick(),
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                _leadingLembrete(),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Text(this._lembrete.nome,
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                _trailingLembrete(),
                 ]),
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: Colors.white30,
            indent: 10,
            endIndent: 10,
            thickness: 1.0,
            height: 0
          ),
        ),
        
      ],
    );
  }

  
}
