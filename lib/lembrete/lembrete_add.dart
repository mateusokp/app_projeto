import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:app_projeto/database/lembrete_db.dart';

import 'package:place_picker/place_picker.dart'; // maps API key AIzaSyDge_tLf1UE8FsxZWtzgMgNoOre-ItVU4c
import 'package:geolocator/geolocator.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LembreteScreen extends StatefulWidget {
  int index;
  LembreteScreen({int index}) {
    this.index = index;

    if (this.index == null) {
      this.index = -1;
    }
  }

  @override
  _LembreteScreenState createState() => _LembreteScreenState();
}

class _LembreteScreenState extends State<LembreteScreen> {
  final TextEditingController _nomeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Lembrete _lembrete;
  bool _isUpdate = false;

  @override
  Widget build(BuildContext context) {
    if (widget.index >= 0 && this._isUpdate == false) {
      debugPrint('editar index = ' + widget.index.toString());

      this._lembrete = LembreteDAO.getLembrete(widget.index);
      this._lembrete.id = widget.index;
      this._nomeController.text = this._lembrete.nome;
      this._datahora = this._lembrete.datahora;
      this._datafim = this._lembrete.datafim;

      this._isUpdate = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ADICIONAR LEMBRETE'),
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
                  child: Text(
                    'Defina o nome do lembrete: ',
                    style: TextStyle(color: Colors.white, fontSize: 24),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Escolha uma data e horario: ',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Container(
                            height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [Color(0xFFC850C0), Color(0xFF4158D0)],
                                ),
                              ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                            ),
                              onPressed: () => _pickDateTime(context, true),
                              child: Text(_getText()),
                            ),
                          ),
                        ),
                      ),
                    ]),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Escolha uma localizacao: ',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Container(
                            height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [Color(0xFFC850C0), Color(0xFF4158D0)],
                                ),
                              ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                            ),
                              onPressed: () => _showPlacePicker(),
                              child: Text('Defina uma localizacao'),
                            ),
                          ),
                        ),
                    
                    
                    ],
                  ),
                ),
                
                
                // Text(
                //   'Escolha uma data de fim: ',
                //   style: TextStyle(color: Colors.white, fontSize: 24),
                // ),
                
                // Container(
                //   child: ElevatedButton(
                //     onPressed: () => _pickDateTime(context, true),
                //     child:  Text(getTextF()),
                //   ),
                // ),
                
                Container(
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

                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Lembrete l = new Lembrete(
                            widget.index,
                            this._nomeController.text,
                            this._datahora,
                            this._datafim);
      
                        if (widget.index >= 0) {
                          LembreteDAO.atualizar(l);
                          Navigator.of(context).pop();
                        } else {
                          LembreteDAO().adicionar(l);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

// #region DateTimePicker
  String _datahora = '';
  String _datafim = '';
  DateTime dateTime, dateTimeI, dateTimeF;

  String _getText() {

    if (dateTimeI == null) {
      return 'Selecione uma data';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(dateTimeI);
    }
  }
  String getTextF() {

  if (dateTimeF == null) {
    return 'Selecione uma data';
  } else {
    return DateFormat('MM/dd/yyyy HH:mm').format(dateTimeF);
  }
}

  Future _pickDateTime(BuildContext context, bool inicio) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;


    
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        
      );
      if (inicio) this._datahora = DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
      else this._datafim = DateFormat('MM/dd/yyyy HH:mm').format(dateTime);

      if (inicio) dateTimeI = dateTime;
      else dateTimeF = dateTime;
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: int.parse(DateFormat('HH').format(DateTime.now())), minute: int.parse(DateFormat('mm').format(DateTime.now())));
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }
// #endregion


void _showPlacePicker() async {
    // Position ultimaLocalizacao = await Geolocator.getLastKnownPosition();

    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyDge_tLf1UE8FsxZWtzgMgNoOre-ItVU4c",
                        displayLocation: LatLng(37.42796133580664, -122.085749655962),
                        )));

    // Handle the result in your way
    print(result);
}

// void _getLastKnownPosition() async {
//     final position = await _geolocatorPlatform.getLastKnownPosition();
//     if (position != null) {
//       _updatePositionList(
//         _PositionItemType.position,
//         position.toString(),
//       );
//     } else {
//       _updatePositionList(
//         _PositionItemType.log,
//         'No last known position available',
//       );
//     }
//   }

}
