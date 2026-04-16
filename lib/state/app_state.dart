import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final Map<String, bool> _registro = {
    'Desayuné': false,
    'Almorcé': false,
    'Cené': false,
    'Comí Fruta': false,
    'Tomé Agua': false,
  };

  Map<String, bool> get registro => _registro;

  void toggleRegistro(String key) {
    _registro[key] = !_registro[key]!;
    notifyListeners();
  }

  int get comidasCompletadas =>
      _registro.values.where((v) => v).length;

  final Map<String, bool> _retos = {
    'Sin Gaseosa': false,
    'Desayunar': false,
    'Fruta Diaria': false,
    'Menos Frituras': false,
  };

  Map<String, bool> get retos => _retos;

  void toggleReto(String key) {
    _retos[key] = !_retos[key]!;
    notifyListeners();
  }

  int get puntosTotal {
    const pts = {
      'Sin Gaseosa': 30,
      'Desayunar': 40,
      'Fruta Diaria': 20,
      'Menos Frituras': 20,
    };

    int total = 0;
    _retos.forEach((k, v) {
      if (v) total += pts[k] ?? 0;
    });

    return total;
  }

  int? _resultadoTest;
  int? get resultadoTest => _resultadoTest;

  void setResultadoTest(int val) {
    _resultadoTest = val;
    notifyListeners();
  }
}