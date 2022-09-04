import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CalculadoraBl {
  var valorFinal = "";
  String onKeyPress(String keyIndex) {
    if (keyIndex == "DEL") {
      valorFinal = valorFinal.substring(0, valorFinal.length - 1);
    } else if (keyIndex == "C") {
      valorFinal = '';
    } else if (valorFinal.isEmpty) {
      valorFinal = keyIndex;
    } else {
      if (keyIndex == "." && puntoExistente(valorFinal)) {
        mensaje('No se pueden agregar 2 puntos');
      } else if (validarAnterior(valorFinal[valorFinal.length - 1], keyIndex)) {
        if (!signosConsecutivos(valorFinal, keyIndex)) {
          if (valorFinal == "Infinity") {
            valorFinal = keyIndex;
          } else if (keyIndex != "=") {
            valorFinal = valorFinal + keyIndex;
          } else {
            valorFinal = calcular(valorFinal);
          }
        }
      }
    }
    return valorFinal;
  }

  bool signosConsecutivos(String cadena, String ingresar) {
    bool flag = false;
    if (cadena.length > 2) {
      if (esOperador(cadena[cadena.length - 1]) &&
          esOperador(cadena[cadena.length - 2]) &&
          esOperador(ingresar)) {
        flag = true;
      }
    }
    return flag;
  }

  String calcular(String dato) {
    String cadena = dato;
    if (validar(cadena)) {
      String mult = operacion("*", cadena);
      String div = operacion("/", mult);
      String sum = operacion("+", div);
      String res = operacion("-", sum);
      print("Resultado final: ${res}");
      if (res[0] == "+") {
        dato = res.substring(1, res.length);
      } else {
        dato = res;
      }
    }
    return dato;
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
    }
    return flag;
  }

  bool validarAnterior(String anteriorValor, String nuevoValor) {
    bool flag = true;
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
      if ((anteriorValor + nuevoValor) == posibilidades[i]) {
        flag = false;
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

        String combinacion = "${v1}$signo${v2}";
        if (!cadena.contains(combinacion)) {
          if (cadena.contains("${v1}.0$signo${v2}")) {
            combinacion = "${v1}.0$signo${v2}";
          } else {
            combinacion = "${v1}$signo${v2}.0";
          }
        }

        if (v1 < 0 && resultadoParcial >= 0) {
          cadena = cadena.replaceAll(combinacion, "+$resultadoParcial");
        } else {
          cadena = cadena.replaceAll(combinacion, "$resultadoParcial");
        }
        //print("parcial: ${resultadoParcial}");
        k = 0;
      }
    }
    res = cadena;
    //print("Resultado: ${res}");
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

  bool puntoExistente(String cadena) {
    bool flag = false;
    for (int it = cadena.length - 1; it >= 0; it--) {
      if (cadena[it] == ".") {
        flag = true;
      } else if (esOperador(cadena[it])) {
        break;
      }
    }
    return flag;
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
    //print("auxDer: $aux");
    res = double.parse(aux);
    return res;
  }
}

bool esOperador(String dato) {
  bool flag = false;
  if (dato == "+" || dato == "-" || dato == "*" || dato == "/" || dato == "=") {
    flag = true;
  }
  return flag;
}

void mensaje(String msg) => Fluttertoast.showToast(msg: msg);
