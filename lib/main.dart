import 'package:flutter/material.dart';
import 'package:calculadora/botones.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final myController = TextEditingController();
  final List<String> botones = [
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '0',
    '.',
    '=',
    '/'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabled: false,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: GridView.builder(
                  itemCount: botones.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Boton(
                      presionado: () {
                        setState(() {
                          //TODO funciones
                          String valor = myController.text;
                          if (valor.length == 0) {
                            myController.text = botones[index];
                          } else {
                            myController.text = valor + botones[index];
                          }
                          calcular(botones[index]);
                        });
                      },
                      buttonText: botones[index],
                      color: Colors.green,
                      textColor: Colors.white,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void calcular(String dato) {
    if (dato == "=") {
      String cadena = myController.text;
      for (int i = 0; i < cadena.length; i++) {
        //print(cadena[i] + "\n");
        if (cadena[i] == "+" ||
            cadena[i] == "-" ||
            cadena[i] == "*" ||
            cadena[i] == "/") {
          double primerDato = 0;
          String aux = "";
          for (int j = 0; j < i; j++) {
            aux += cadena[j];
          }
          primerDato = double.parse(aux);
          print(primerDato);
        }
      }
    }
  }
}
