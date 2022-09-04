import 'dart:async';
import 'bloc.dart';
import 'calculadora_bl.dart';

class CalculatorBloc implements Bloc {
  final _calculatorBl = CalculadoraBl();

  final _calculatorController = StreamController<String>();

  Sink<String?> get pressKeySink => _calculatorController.sink;

  late Stream<String?> calculatorStream;

  CalculatorBloc() {
    calculatorStream = _calculatorController.stream.asyncMap((key) {
      return _calculatorBl.onKeyPress(key);
    });
  }

  @override
  void dispose() {
    _calculatorController.close();
  }
}
