import 'package:app_projeto/model/user.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_projeto/model/lembrete.dart';
import 'package:app_projeto/database/lembrete_db.dart';
import 'package:location/location.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:place_picker/place_picker.dart';

class LembreteScreen extends StatefulWidget {
  int index;
  Lembrete lembrete;
  User user;
  LembreteScreen({Lembrete lembrete, User user}) {
    this.user = user;
    if (lembrete == null) {
      this.index = -1;
    } else {
      this.index = lembrete.id;
      this.lembrete = lembrete;
    }
  }

  @override
  _LembreteScreenState createState() => _LembreteScreenState();
}

class _LembreteScreenState extends State<LembreteScreen> {
  final TextEditingController _nomeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  User _user;
  Lembrete _lembrete;
  bool _isUpdate = false;

  @override
  Widget build(BuildContext context) {
    if (widget.index >= 0 && this._isUpdate == false) {
      debugPrint('editar index = ' + widget.index.toString());
      this._user = widget.user;
      this._lembrete = widget.lembrete;
      this._nomeController.text = this._lembrete.nome;
      this._datahora = this._lembrete.datahora;
      this._local = this._lembrete.local;

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
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Nome do Lembrete"),
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(children: [
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
                        width: MediaQuery.of(context).size.width * 0.7,
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
                            child: Text(_getTextDate()),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
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
                        width: MediaQuery.of(context).size.width * 0.7,
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
                            child: Text(_getTextLocal()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                            borderRadius: BorderRadius.circular(30)),
                        shadowColor: Colors.white10),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        debugPrint('olaaaaaaaaaaaaa');
                        debugPrint(widget.user.toString());
                        Lembrete l = new Lembrete(
                            widget.index,
                            widget.user,
                            this._nomeController.text,
                            this._datahora,
                            this._local);

                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                                id: l.id,
                                channelKey: 'key1',
                                title: l.nome,
                                body: 'pfv funcione'));

                        if (widget.index >= 0) {
                          LembreteDAO().atualizar(l);
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
  DateTime dateTime, dateTimeI, dateTimeF;

  String _getTextDate() {
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
      if (inicio)
        this._datahora = DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
      //else this._datafim = DateFormat('MM/dd/yyyy HH:mm').format(dateTime);

      if (inicio)
        dateTimeI = dateTime;
      else
        dateTimeF = dateTime;
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
    final initialTime = TimeOfDay(
        hour: int.parse(DateFormat('HH').format(DateTime.now())),
        minute: int.parse(DateFormat('mm').format(DateTime.now())));
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

// #region LocationPicker
  String _local = '';

  String _getTextLocal() {
    if (_local == '') {
      return 'Selecione uma localizacao';
    } else {
      return _local;
    }
  }

  void _showPlacePicker() async {
    double lat = 37.42796133580664, long = -122.085749655962;
    var location = await getLocation();
    if (location != null) {
      lat = location[0];
      long = location[1];
      debugPrint('LAT = ${lat.toString()}');
      debugPrint('LONG = ${long.toString()}');
    }
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlacePicker(
          "",
          displayLocation: LatLng(lat, long)),
    ));

    _local = result.formattedAddress;
    debugPrint(_local);
  }

  getLocation() async {
    var location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return [
      _locationData.latitude.toDouble(),
      _locationData.longitude.toDouble()
    ];
  }
}
// #endregion


// #region Notifications



// #endregion