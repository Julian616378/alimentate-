import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ProgresoScreen extends StatelessWidget {
  final AppState appState;

  const ProgresoScreen({super.key, required this.appState});

  static const Color _verde = Color(0xFF4A8C3F);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final retosCompletos =
            appState.retos.values.where((v) => v).length;

        return Scaffold(
          backgroundColor: const Color(0xFFFFF8EC),
          appBar: AppBar(
            backgroundColor: _verde,
            title: const Text('Mi Progreso',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 Tarjeta de puntos
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3A7034), Color(0xFF6DB560)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      const Text('🏆',
                          style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(
                        '${appState.puntosTotal}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w800),
                      ),
                      const Text('Puntos',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _buildProgressCard(
                  '🍽️',
                  'Registro Diario',
                  appState.comidasCompletadas,
                  appState.registro.length,
                ),

                const SizedBox(height: 10),

                _buildProgressCard(
                  '🎯',
                  'Retos',
                  retosCompletos,
                  appState.retos.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(
      String emoji, String titulo, int valor, int total) {
    final porcentaje = total == 0 ? 0.0 : valor / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji $titulo',
              style:
                  const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: porcentaje),
          const SizedBox(height: 5),
          Text('$valor / $total'),
        ],
      ),
    );
  }
}