import 'package:flutter/material.dart';
import '../state/app_state.dart';
class TestHabitosScreen extends StatefulWidget {
  final AppState appState;

  const TestHabitosScreen({super.key, required this.appState});

  @override
  State<TestHabitosScreen> createState() => _TestHabitosScreenState();
}

class _TestHabitosScreenState extends State<TestHabitosScreen> {
  static const Color _verde = Color(0xFF4A8C3F);
  static const Color _amarillo = Color(0xFFF5A623);
  static const Color _rojo = Color(0xFFE05252);

  final List<Map<String, dynamic>> _preguntas = [
    {
      'pregunta': '¿Cuántas veces omites el desayuno?',
      'opciones': ['Nunca', '1-2 veces por semana', 'Casi todos los días'],
      'puntajes': [2, 1, 0],
    },
    {
      'pregunta': '¿Cuántas frutas o verduras comes al día?',
      'opciones': ['3 o más', '1-2', 'Casi ninguna'],
      'puntajes': [2, 1, 0],
    },
    {
      'pregunta': '¿Con qué frecuencia consumes gaseosas o dulces?',
      'opciones': ['Rara vez', 'Algunas veces', 'Todos los días'],
      'puntajes': [2, 1, 0],
    },
    {
      'pregunta': '¿Cuántos vasos de agua tomas al día?',
      'opciones': ['8 o más', '4-7', 'Menos de 4'],
      'puntajes': [2, 1, 0],
    },
    {
      'pregunta': '¿Con qué frecuencia comes comida rápida o ultraprocesada?',
      'opciones': ['Casi nunca', '1-2 veces por semana', 'Más de 3 veces'],
      'puntajes': [2, 1, 0],
    },
  ];

  final List<int?> _respuestas = List.filled(5, null);
  int _preguntaActual = 0;
  bool _terminado = false;
  bool _respondiendo = false;

  int get _puntajeTotal =>
      _respuestas.fold(0, (s, r) => s + (r ?? 0));

  String get _clasificacion {
    if (_puntajeTotal >= 8) return 'Hábitos Saludables';
    if (_puntajeTotal >= 5) return 'Hábitos en Riesgo';
    return 'Hábitos Deficientes';
  }

  Color get _clasificacionColor {
    if (_puntajeTotal >= 8) return _verde;
    if (_puntajeTotal >= 5) return _amarillo;
    return _rojo;
  }

  String get _recomendacion {
    if (_puntajeTotal >= 8)
      return '¡Excelente! Mantienes buenos hábitos alimentarios.';
    if (_puntajeTotal >= 5)
      return 'Necesitas mejorar tus hábitos.';
    return 'Empieza por no saltarte el desayuno y tomar más agua.';
  }

  void _seleccionarOpcion(int puntaje) {
    if (_respondiendo) return;

    setState(() {
      _respondiendo = true;
      _respuestas[_preguntaActual] = puntaje;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      if (_preguntaActual < _preguntas.length - 1) {
        setState(() {
          _preguntaActual++;
          _respondiendo = false;
        });
      } else {
        setState(() => _terminado = true);
        widget.appState.setResultadoTest(_puntajeTotal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: _verde,
        title: const Text('Test de Hábitos',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800)),
      ),
      body: _terminado ? _buildResultado(context) : _buildPregunta(),
    );
  }

  Widget _buildPregunta() {
    final pregunta = _preguntas[_preguntaActual];
    final opciones = pregunta['opciones'] as List<String>;
    final puntajes = pregunta['puntajes'] as List<int>;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            pregunta['pregunta'],
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          ...List.generate(opciones.length, (i) {
            return ElevatedButton(
              onPressed: () => _seleccionarOpcion(puntajes[i]),
              child: Text(opciones[i]),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultado(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_clasificacion,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _clasificacionColor)),
          const SizedBox(height: 10),
          Text('Puntaje: $_puntajeTotal'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          )
        ],
      ),
    );
  }
}