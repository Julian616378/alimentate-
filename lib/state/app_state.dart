import 'package:flutter/material.dart';

// ── MODELOS ───────────────────────────────────────────────
class Comida {
  final String nombre;
  final int calorias;
  final IconData icono;

  const Comida({
    required this.nombre,
    required this.calorias,
    required this.icono,
  });
}

class SeccionComida {
  final String nombre;
  final IconData icono;
  final int metaCalorias;
  final List<Comida> comidas;

  SeccionComida({
    required this.nombre,
    required this.icono,
    required this.metaCalorias,
    List<Comida>? comidas,
  }) : comidas = comidas ?? [];

  int get totalCalorias =>
      comidas.fold<int>(0, (s, c) => s + c.calorias);

  double get progreso =>
      (totalCalorias / metaCalorias).clamp(0.0, 1.0);

  Color get colorEstado {
    if (totalCalorias == 0) return const Color(0xFFBDBDBD);
    final pct = totalCalorias / metaCalorias;
    if (pct <= 1.0) return const Color(0xFF4CAF50);
    if (pct <= 1.30) return const Color(0xFFE8943A);
    return const Color(0xFFE53935);
  }

  String get etiquetaEstado {
    if (totalCalorias == 0) return 'Sin registros';
    final pct = totalCalorias / metaCalorias;
    if (pct <= 0.7) return 'Pocas calorías';
    if (pct <= 1.0) return 'Bien equilibrado';
    if (pct <= 1.30) return 'Un poco alto';
    return 'Muy alto';
  }
}

// ── APP STATE ─────────────────────────────────────────────
class AppState extends ChangeNotifier {

  // ── CHECKLIST ───────────────────────────────────────────
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

  // ── RETOS ───────────────────────────────────────────────
  final Map<String, bool> _retos = {
    'Sin Gaseosa': false,
    'Desayunar': false,
    'Fruta Diaria': false,
    'Menos Frituras': false,
    'Beber 2L de agua': false,
    'No comida chatarra': false,
    'Cocinar en casa': false,
    'Comer sin celular': false,
    'Dormir 8 horas': false,
    'No comer tarde': false,
  };

  Map<String, bool> get retos => _retos;

  // ── PUNTOS ──────────────────────────────────────────────
  final Map<String, int> _pts = {
    'Sin Gaseosa': 30,
    'Desayunar': 40,
    'Fruta Diaria': 20,
    'Menos Frituras': 20,
    'Beber 2L de agua': 25,
    'No comida chatarra': 30,
    'Cocinar en casa': 25,
    'Comer sin celular': 15,
    'Dormir 8 horas': 20,
    'No comer tarde': 25,
  };

  Map<String, int> get puntos => _pts;

  void toggleReto(String key) {
    _retos[key] = !_retos[key]!;
    notifyListeners();
  }

  int get puntosTotal {
    int total = 0;
    _retos.forEach((k, v) {
      if (v) total += _pts[k] ?? 0;
    });
    return total;
  }

  // ── BONUS PRO: AGREGAR RETOS DINÁMICAMENTE ──────────────
  void agregarReto(String nombre, {int puntos = 20}) {
    _retos[nombre] = false;
    _pts[nombre] = puntos;
    notifyListeners();
  }

  // ── SECCIONES DE COMIDA ─────────────────────────────────
// ── SECCIONES DE COMIDA ─────────────────────────────────
final List<SeccionComida> _secciones = [
  SeccionComida(
    nombre: 'Desayuno',
    icono: Icons.free_breakfast,
    metaCalorias: 400,
  ),
  SeccionComida(
    nombre: 'Media mañana',
    icono: Icons.coffee,
    metaCalorias: 200,
  ),
  SeccionComida(
    nombre: 'Almuerzo',
    icono: Icons.lunch_dining,
    metaCalorias: 700,
  ),
  SeccionComida(
    nombre: 'Media tarde',
    icono: Icons.apple,
    metaCalorias: 200,
  ),
  SeccionComida(
    nombre: 'Cena',
    icono: Icons.dinner_dining,
    metaCalorias: 500,
  ),
];

List<SeccionComida> get secciones => _secciones;

int get seccionesCompletadas =>
    _secciones.where((s) => s.comidas.isNotEmpty).length;

  static const int metaDiaria = 2000;

  int get totalCalorias =>
      _secciones.fold<int>(0, (s, sec) => s + sec.totalCalorias);

  double get progresoCalorias =>
      (totalCalorias / metaDiaria).clamp(0.0, 1.0);

  ({String mensaje, Color color, IconData icono}) get estadoDia {
    final total = totalCalorias;

    if (total == 0) {
      return (
        mensaje: 'Aún no has registrado comidas',
        color: Colors.grey,
        icono: Icons.wb_sunny_outlined,
      );
    }

    final pct = total / metaDiaria;

    if (pct < 0.5) {
      return (
        mensaje: 'Muy pocas calorías hoy',
        color: Colors.blue,
        icono: Icons.sentiment_dissatisfied_outlined,
      );
    }

    if (pct <= 0.85) {
      return (
        mensaje: 'Vas muy bien',
        color: Colors.green,
        icono: Icons.sentiment_satisfied_alt,
      );
    }

    if (pct <= 1.0) {
      return (
        mensaje: 'Excelente balance',
        color: Colors.green,
        icono: Icons.sentiment_very_satisfied,
      );
    }

    if (pct <= 1.2) {
      return (
        mensaje: 'Un poco alto',
        color: const Color(0xFFE8943A),
        icono: Icons.sentiment_neutral_outlined,
      );
    }

    return (
      mensaje: 'Exceso de calorías',
      color: Colors.red,
      icono: Icons.sentiment_very_dissatisfied_outlined,
    );
  }

  // ── CRUD COMIDAS ────────────────────────────────────────
  void agregarComida(SeccionComida seccion, Comida comida) {
    seccion.comidas.add(comida);
    notifyListeners();
  }

  void eliminarComida(SeccionComida seccion, int index) {
    seccion.comidas.removeAt(index);
    notifyListeners();
  }

  // ── TEST ────────────────────────────────────────────────
  int? _resultadoTest;
  int? get resultadoTest => _resultadoTest;

  void setResultadoTest(int val) {
    _resultadoTest = val;
    notifyListeners();
  }
}