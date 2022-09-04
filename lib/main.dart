import 'package:flutter/material.dart';
import 'package:calculadora/widgets/botones.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/calculadora_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: CalculatorBloc(),
        child: MaterialApp(
          title: 'Flutter Demo',
          home: const Calculadora(),
        ));
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String anterior = "";

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
    final calculatorBloc = BlocProvider.of<CalculatorBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 98, 192, 204),
        title: const Text('Calculadora'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: SizedBox(child: _buildController(calculatorBloc)),
                  ),
                ]),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: (() => {calculatorBloc.pressKeySink.add("C")}),
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 126, 73, 143)),
                height: 40,
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
              onTap: (() => {calculatorBloc.pressKeySink.add("DEL")}),
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 233, 153, 173)),
                height: 40,
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
          flex: 2,
          child: Container(
            child: GridView.builder(
                itemCount: botones.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1.4),
                itemBuilder: (BuildContext context, int index) {
                  return Boton(
                      presionado: () {
                        calculatorBloc.pressKeySink.add(botones[index]);
                      },
                      buttonText: botones[index],
                      color: esOperador(botones[index])
                          ? Color.fromARGB(255, 98, 192, 204)
                          : Colors.white,
                      textColor: esOperador(botones[index])
                          ? Colors.white
                          : Colors.grey);
                }),
          ),
        ),
      ]),
    );
  }

  Widget _buildController(CalculatorBloc bloc) {
    return StreamBuilder<String?>(
        stream: bloc.calculatorStream,
        builder: ((context, snapshot) {
          final myController = TextEditingController();
          if (snapshot.data != null) {
            myController.text = snapshot.data.toString();
          }
          return TextField(
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 40.0,
              color: Color.fromARGB(255, 99, 99, 99),
            ),
            controller: myController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20.0),
              enabled: false,
            ),
          );
        }));
  }

  bool esOperador(String dato) {
    bool flag = false;
    if (dato == "+" ||
        dato == "-" ||
        dato == "*" ||
        dato == "/" ||
        dato == "=") {
      flag = true;
    }
    return flag;
  }
}
