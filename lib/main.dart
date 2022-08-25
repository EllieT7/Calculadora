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
                            if (botones[index] != "=") {
                              myController.text = valor + botones[index];
                            }
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
      String mult = operacion("*", cadena);
      String div = operacion("/", mult);
      String sum = operacion("+", div);
      String res = operacion("-", sum);
      print("Resultado final: ${res}");
    }
  }

  String operacion(String signo, String cadena) {
    String res = "";
    double resultadoParcial = 0;
    for (int k = 0; k < cadena.length; k++) {
      if (cadena[k] == signo) {
        double v1 = encontrarValorIzq(k, cadena);
        double v2 = encontrarValorDer(k, cadena);
        print(v1);
        print(v2);
        switch (signo) {
          case "+":
            resultadoParcial = v1 + v2;
            break;
          case "-":
            resultadoParcial = v1 - v2;
            break;
          case "*":
            resultadoParcial = v1 * v2;
            break;
          case "/":
            resultadoParcial = v1 / v2;
            break;
        }
        cadena = cadena.replaceAll("${v1}$signo${v2}", "$resultadoParcial");
        //print(cadena);
        k = 0;
      }
    }
    res = cadena;
    print("Resultado: ${res}");
    return res;
  }

  double encontrarValorIzq(int pos, String cadena) {
    double res = 0;
    String aux = '';
    int posAnterior = -1;
    for (int l = 0; l < cadena.length; l++) {
      if (l == pos) {
        for (int m = posAnterior + 1; m < l; m++) {
          aux += cadena[m];
        }
        break;
      } else {
        if (cadena[l] == "+" ||
            cadena[l] == "-" ||
            cadena[l] == "*" ||
            cadena[l] == "/") {
          posAnterior = l;
        }
      }
    }
    res = double.parse(aux);
    return res;
  }

  double encontrarValorDer(int pos, String cadena) {
    double res = 0;
    String aux = '';
    for (int l1 = 0; l1 < cadena.length; l1++) {
      if (l1 == pos) {
        for (int m1 = pos + 1; m1 < cadena.length; m1++) {
          if (cadena[m1] == "+" ||
              cadena[m1] == "-" ||
              cadena[m1] == "*" ||
              cadena[m1] == "/" ||
              cadena[m1] == "=") {
            break;
          } else {
            aux += cadena[m1];
          }
        }
        break;
      }
    }
    res = double.parse(aux);
    return res;
  }
}
