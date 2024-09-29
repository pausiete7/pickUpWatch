// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

final client = Supabase.instance.client;

// ignore: must_be_immutable
class ChildrenListPage extends StatefulWidget {
  ChildrenListPage({Key? key, required this.claseArreglada}) : super(key: key);

  String claseArreglada;

  @override
  State<ChildrenListPage> createState() =>
      // ignore: no_logic_in_create_state
      _ChildrenListPageState(claseArreglada);
}

class _ChildrenListPageState extends State<ChildrenListPage> {
  _ChildrenListPageState(this.claseArreglada);
  String claseArreglada;
  Timer? periodicTimer;
  bool timefinised = false;
  List<dynamic> logs = [];
  List<dynamic> alumnos = [];
  List<dynamic> familiares = [];
  int alumnosAuto = 0;
  int alumnosRecollits = 0;
  int alumnosRestants = 0;

  @override
  void initState() {
    super.initState();

    var time = DateTime.now().millisecondsSinceEpoch;
    periodicTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        var futureLogs =
            await client.from('logs').select().gt('time', time).execute();
        logs = (futureLogs.data as List);
        for (var log in logs) {
          final a =
              alumnos.firstWhere((element) => element['id'] == log['id_niño']);
          final f = familiares
              .firstWhere((element) => element['id'] == log['id_familiares']);
          if (alumnos[alumnos.indexOf(a)]['autorizado'] == false) {
            alumnosAuto = alumnosAuto + 1;
          }
          alumnos[alumnos.indexOf(a)]['autorizado'] = true;
          alumnos[alumnos.indexOf(a)]['familiar_autorizado'] =
              '${f['nombre']} ${f['apellidos']} \n (${f['relacion']})';

          // time = DateTime.now();
        }
        setState(() {
          alumnos;
          timefinised = true;
        });
      },
    );
  }

  Future<List> getData() async {
    if (alumnos.isEmpty) {
      var futureAlumnos = await client
          .from('niños')
          .select()
          .eq('clase', claseArreglada)
          .execute();
      var futureFamiliares = await client.from('familiares').select().execute();

      alumnos = (futureAlumnos.data as List);
      alumnosRestants = alumnos.length;
      familiares = (futureFamiliares.data as List);
      return futureAlumnos.data;
    } else {
      return alumnos;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFdbbba6),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          iconSize: height * 0.035,
        ),
        backgroundColor: Color(0xFFb17c54),
        title: Text(claseArreglada,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Futura',
                fontSize: height * 0.025)),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (alumnos.isNotEmpty) {
            alumnos.sort((a, b) => a['apellidos']!.compareTo(b['apellidos']!));
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.04),
                child: Column(
                  children: [
                    Text(
                      "Llista d'alumnes de $claseArreglada",
                      style: TextStyle(
                          fontFamily: 'Futura', fontSize: height * 0.05),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    topBar(height, width, alumnos),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var alumno = alumnos[index];
                          return Container(
                            margin: EdgeInsets.only(
                              left: width * 0.15,
                              right: width * 0.15,
                            ),
                            padding: EdgeInsets.only(
                              top: height * 0.01,
                              bottom: height * 0.01,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFb17c54))),
                            child: itemAlumno(
                              alumno,
                              index,
                              height,
                              width,
                            ),
                          );
                        },
                        itemCount: alumnos.length),
                  ],
                ),
              ),
            );
          } else {
            return !timefinised
                ? Center(
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset('assets/img/lapiz.gif')))
                : Center(
                    child: Text(
                    "No s'ha trobat cap resultat",
                    style: TextStyle(
                        fontFamily: 'Futura',
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ));
          }
        },
      ),
    );
  }

  Widget topBar(double height, double width, var alumnos) {
    return Container(
      height: height * 0.05,
      margin: EdgeInsets.only(
        left: width * 0.15,
        right: width * 0.15,
      ),
      decoration: BoxDecoration(border: Border.all(color: Color(0xFFb17c54))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Número d'alumnes totals: ${alumnos.length}",
            style: TextStyle(fontFamily: 'Futura'),
          ),
          SizedBox(
            width: width * 0.01,
          ),
          Text("Número d'alumnes autoritzats: $alumnosAuto/${alumnos.length}",
              style: TextStyle(fontFamily: 'Futura')),
          SizedBox(
            width: width * 0.01,
          ),
          Text(
              "Número d'alumnes recollits: $alumnosRecollits/${alumnos.length}",
              style: TextStyle(fontFamily: 'Futura')),
          SizedBox(
            width: width * 0.01,
          ),
          Text("Número d'alumnes restants: $alumnosRestants/${alumnos.length}",
              style: TextStyle(fontFamily: 'Futura')),
        ],
      ),
    );
  }

  Widget itemAlumno(
    var alumno,
    int index,
    double height,
    double width,
  ) {
    return Container(
      padding: EdgeInsets.only(left: width * 0.01),
      child: Row(
        children: [
          Text((index + 1).toString(),
              style:
                  TextStyle(fontFamily: 'Futura', fontWeight: FontWeight.bold)),
          SizedBox(
            width: width * 0.02,
          ),
          CircleAvatar(
              radius: height * 0.033,
              // foregroundImage: AssetImage('img/desconocido.png'),
              backgroundImage: NetworkImage(alumno['foto'][0])),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text('Cognoms:',
                    style: TextStyle(
                        fontFamily: 'Futura', fontWeight: FontWeight.bold)),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(alumno['apellidos'],
                    style: TextStyle(fontFamily: 'Futura')),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text('Nom:',
                    style: TextStyle(
                        fontFamily: 'Futura', fontWeight: FontWeight.bold)),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  alumno['nombre'],
                  style: TextStyle(fontFamily: 'Futura'),
                )
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('Autoritzat a sortir',
                      style: TextStyle(
                          fontFamily: 'Futura', fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  !alumno['autorizado']
                      ? Icon(
                          Icons.close,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                ],
              )),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('Recollit?',
                      style: TextStyle(
                          fontFamily: 'Futura', fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  !alumno['autorizado']
                      ? Text('No recollit',
                          style: TextStyle(
                            fontFamily: 'Futura',
                          ))
                      : !alumno['recogido']
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFb17c54)),
                              onPressed: () {
                                setState(() {
                                  alumnosRecollits = alumnosRecollits + 1;
                                  alumnosRestants = alumnosRestants - 1;
                                  alumno['recogido'] = true;
                                });
                              },
                              child: Text('Recollit!'))
                          : Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                ],
              )),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("Familiar a càrrec:",
                      style: TextStyle(
                          fontFamily: 'Futura', fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(alumno['familiar_autorizado'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Futura',
                      )),
                ],
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    periodicTimer?.cancel();
  }
}
