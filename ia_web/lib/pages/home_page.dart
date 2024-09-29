import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool firstTime = true;
  List<double> widths = [];
  List<String> etapa = ['Curs:', 'Cicle:', 'Classe:'];
  List<String> opciones = [
    'Selecciona el cicle:',
    'Selecciona el curs:',
    'Selecciona la classe:'
  ];
  List<List<String>> info = [
    ['Infantil', 'Primària', 'ESO', 'BTX'],
    ['1r', '2n', '3r', '4t'],
    [
      'A',
      'B',
      'C',
    ]
  ];
  List<String> seleccion = ['Infantil', '1r', 'A'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (firstTime == true) {
      widths = [width * 0.15, width * 0.15, width * 0.15];
      firstTime = false;
    }
    return Scaffold(
      backgroundColor: Color(0xFFdbbba6),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            bigTitle(context),
            SizedBox(
              height: height * 0.1,
            ),
            //
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.1, right: width * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(opciones[index],
                                  style: TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: height * 0.03)),
                            ),
                            Expanded(
                              flex: 8,
                              child: CustomRadioButton(
                                defaultSelected: info[index][0],
                                width: widths[index],
                                height: height * 0.08,
                                elevation: 0,
                                absoluteZeroSpacing: false,
                                buttonLables: info[index],
                                buttonValues: info[index],
                                buttonTextStyle: ButtonTextStyle(
                                    selectedColor: Colors.white,
                                    unSelectedColor: Colors.black,
                                    textStyle: TextStyle(
                                        fontFamily: 'Futura',
                                        fontSize: height * 0.025)),
                                radioButtonValue: (String value) {
                                  if (value == 'Infantil') {
                                    info[1] = [
                                      '1r',
                                      '2n',
                                      '3r',
                                      '4t',
                                    ];
                                    info[2] = [
                                      'A',
                                      'B',
                                      'C',
                                    ];
                                    widths[1] = width * 0.15;
                                  } else if (value == 'Primària') {
                                    info[1] = [
                                      '1r',
                                      '2n',
                                      '3r',
                                      '4t',
                                      '5è',
                                      '6è'
                                    ];
                                    info[2] = [
                                      'A',
                                      'B',
                                      'C',
                                    ];
                                    widths[1] = width * 0.0855;
                                  } else if (value == 'ESO') {
                                    info[1] = [
                                      '1r',
                                      '2n',
                                      '3r',
                                      '4t',
                                    ];
                                    info[2] = [
                                      'A',
                                      'B',
                                      'C',
                                    ];
                                    widths[1] = width * 0.15;
                                  } else if (value == 'BTX') {
                                    info[1] = [
                                      '1r',
                                      '2n',
                                    ];
                                    info[2] = [
                                      'A',
                                      'B',
                                    ];
                                    widths[1] = width * 0.15;
                                  }
                                  setState(() {
                                    info;
                                    widths;
                                  });

                                  seleccion[index] = value;
                                },
                                selectedColor: Color(0xFF804000),
                                unSelectedColor: Color(0xFFb17c54),
                                selectedBorderColor: Colors.black,
                                unSelectedBorderColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                    ],
                  );
                },
                itemCount: 3),
            SizedBox(
              height: height * 0.1,
            ),
            searchButton(context)
          ],
        ),
      ),
    );
  }

  Widget bigTitle(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height * 0.1),
      child: Center(
          child: Text(
        'Selecciona una classe',
        style: TextStyle(
            fontSize: height * 0.08,
            fontFamily: 'Futura',
            fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget searchButton(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.18,
      height: height * 0.09,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFb17c54),
        ),
        onPressed: () {
          String claseArreglada =
              '${seleccion[1]} ${seleccion[0]} ${seleccion[2]}';
          Navigator.pushNamed(context, 'childrenList',
              arguments: [claseArreglada]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: height * 0.045,
              color: Colors.black,
            ),
            SizedBox(
              width: width * 0.01,
            ),
            Text('Buscar',
                style: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: height * 0.045,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
