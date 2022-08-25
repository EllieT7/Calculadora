import 'package:flutter/material.dart';
import 'package:calculadora/botones.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String anterior = "";
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
        title: const Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          Text("$anterior"),
          Expanded(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 100,
                        child: TextField(
                          style: TextStyle(fontSize: 40.0, color: Colors.black),
                          controller: myController,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 40.0),
                            border: OutlineInputBorder(),
                            enabled: false,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: (() => {
                      setState(() {
                        myController.text = "";
                        anterior = "";
                      })
                    }),
                child: Container(
                  color: Colors.amber,
                  height: 100,
                  child: const Center(
                    child: const Text(
                      "C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: (() => {
                      setState(() {
                        myController.text = myController.text
                            .substring(0, myController.text.length - 1);
                      })
                    }),
                child: Container(
                  color: Color.fromARGB(255, 31, 185, 185),
                  height: 100,
                  child: const Center(
                    child: const Text(
                      "DEL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: GridView.builder(
                  itemCount: botones.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Boton(
                      presionado: () {
                        setState(() {
                          //TODO funciones
                          String valor = myController.text;
                          if (valor.isEmpty) {
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
      if (validar(cadena)) {
        String mult = operacion("*", cadena);
        String div = operacion("/", mult);
        String sum = operacion("+", div);
        String res = operacion("-", sum);
        print("Resultado final: ${res}");
        anterior = myController.text;
        myController.text = res;
      }
    }
  }

  bool validar(String cadena) {
    bool flag = true;
    //Ultimo valor --- no x / + - o .
    if (esOperador(cadena[cadena.length - 1]) ||
        cadena[cadena.length - 1] == ".") {
      flag = false;
      mensaje("Revise la ecuación, debe finalizar con un número");
    } else if (cadena[0] == "/" || cadena[0] == "*") {
      flag = false;
      mensaje("Revise la ecuación, no puede iniciar con un operador * o /");
    } else if (cadena.isEmpty) {
      flag = false;
    } else if (combinacionesConsecutivas(cadena)) {
      flag = false;
      mensaje("Revise la ecuación");
    }
    return flag;
  }

  bool combinacionesConsecutivas(String cadena) {
    bool flag = false;
    List<String> posibilidades = [
      "-*",
      "+*",
      "-/",
      "+/",
      "..",
      "+.",
      "-.",
      "/.",
      "*.",
      ".+",
      ".-",
      "./",
      ".*",
      "**",
      "//",
      "++",
      "-+",
      "*+",
      "/+"
    ];
    for (int i = 0; i < posibilidades.length; i++) {
      if (cadena.contains(posibilidades[i])) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  String operacion(String signo, String cadena) {
    String res = "";
    double resultadoParcial = 0;
    for (int k = 0; k < cadena.length; k++) {
      if (cadena[k] == signo && k != 0) {
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

        if (v1 < 0 && resultadoParcial >= 0) {
          cadena = cadena.replaceAll("${v1}$signo${v2}", "+$resultadoParcial");
        } else {
          cadena = cadena.replaceAll("${v1}$signo${v2}", "$resultadoParcial");
        }
        print("parcial: ${resultadoParcial}");

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
          if (cadena[l] == "-") {
            posAnterior = l - 1;
          } else {
            posAnterior = l;
          }
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
              cadena[m1] == "/") {
            if (m1 != pos + 1) {
              break;
            } else {
              aux += cadena[m1];
            }
          } else {
            aux += cadena[m1];
          }
        }
        break;
      }
    }
    print("auxDer: $aux");
    res = double.parse(aux);
    return res;
  }
}

bool esOperador(String dato) {
  bool flag = false;
  if (dato == "+" || dato == "-" || dato == "*" || dato == "/") {
    flag = true;
  }
  return flag;
}

void mensaje(String msg) => Fluttertoast.showToast(msg: msg);
