import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../state/app_state.dart';

class ProgresoScreen extends StatelessWidget {
  final AppState appState;

  const ProgresoScreen({super.key, required this.appState});

  static const Color _verde = Color(0xFF4A9B6E);
  static const Color _verdeClaro = Color(0xFF7BC47F);
  static const Color _verdeOscuro = Color(0xFF4A9B6E);
  static const Color _fondo = Color(0xFFFFF8EC);
  static const Color _naranja = Color(0xFFFFA726);
  static const Color _azul = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final retosCompletos = appState.retos.values.where((v) => v).length;
       final porcentajeComidas = appState.secciones.isEmpty
    ? 0.0
    : appState.seccionesCompletadas / appState.secciones.length;
        final porcentajeRetos = appState.retos.isEmpty
            ? 0.0
            : retosCompletos / appState.retos.length;

        return Scaffold(
          backgroundColor: _fondo,
          appBar: AppBar(
            backgroundColor: _verde,
            elevation: 0,
            title: const Text(
              'Mi Progreso',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_verdeOscuro, _verde],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Tarjeta de puntos ──────────────────────
                _buildPointsCard(),
                const SizedBox(height: 20),

                // ── Calorías del día ───────────────────────
                _buildSectionTitle('', 'Calorías del Día'),
                const SizedBox(height: 12),
                _buildCaloriasCard(),
                const SizedBox(height: 24),

                // ── Desglose por sección ───────────────────
                _buildSectionTitle('🍽️', 'Desglose por Comida'),
                const SizedBox(height: 12),
                _buildDesgloseComidas(),
                const SizedBox(height: 24),

                // ── Resumen general ────────────────────────
                _buildSectionTitle('📊', 'Resumen General'),
                const SizedBox(height: 12),
                _buildStatsGrid(porcentajeComidas, porcentajeRetos),
                const SizedBox(height: 24),

                // ── Progreso semanal ───────────────────────
           

                // ── Distribución de comidas ────────────────
                _buildSectionTitle('🍽️', 'Distribución de Comidas'),
                const SizedBox(height: 12),
                _buildMealDistributionChart(),
                const SizedBox(height: 24),

                // ── Retos completados ──────────────────────
                _buildSectionTitle('🎯', 'Retos Completados'),
                const SizedBox(height: 12),
                _buildChallengesCard(retosCompletos, appState.retos.length),
                const SizedBox(height: 24),

                // ── Progreso detallado ─────────────────────
                _buildSectionTitle('📋', 'Progreso Detallado'),
                const SizedBox(height: 12),
               _buildProgressCard(
                '🍽️',
                'Registro Diario',
                appState.seccionesCompletadas,
                appState.secciones.length,
                _verdeClaro,
              ),
                const SizedBox(height: 10),
                _buildProgressCard(
                  '🎯',
                  'Retos',
                  retosCompletos,
                  appState.retos.length,
                  _naranja,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  //  NUEVO: Tarjeta de calorías totales del día
  // ══════════════════════════════════════════════════════════
  Widget _buildCaloriasCard() {
    final total = appState.totalCalorias;
    const meta = AppState.metaDiaria;
    final progreso = (total / meta).clamp(0.0, 1.0);
    final estado = appState.estadoDia;

    Color colorBarra;
    if (progreso <= 0.85) {
      colorBarra = _verde;
    } else if (progreso <= 1.0) {
      colorBarra = _verdeClaro;
    } else if (progreso <= 1.2) {
      colorBarra = _naranja;
    } else {
      colorBarra = Colors.red.shade400;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: estado.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(estado.icono, color: estado.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estado.mensaje,
                      style: TextStyle(
                        fontSize: 13,
                        color: estado.color,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCalStat('Consumidas', '$total kcal', colorBarra),
              _buildCalStat('Meta', '$meta kcal', Colors.grey.shade400),
              _buildCalStat(
                'Restantes',
                '${(meta - total).clamp(0, meta)} kcal',
                _verdeOscuro,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progreso,
              backgroundColor: Colors.grey.shade100,
              color: colorBarra,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progreso * 100).toInt()}% de la meta',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
              Text(
                '$meta kcal / día',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  NUEVO: Desglose por sección de comida
  // ══════════════════════════════════════════════════════════
  Widget _buildDesgloseComidas() {
    final secciones = appState.secciones;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: secciones.map((sec) {
          final progreso = (sec.totalCalorias / sec.metaCalorias).clamp(0.0, 1.0);
          final color = sec.colorEstado;
          final isEmpty = sec.comidas.isEmpty;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(sec.icono, size: 17, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sec.nombre,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                isEmpty
                                    ? '0 / ${sec.metaCalorias} kcal'
                                    : '${sec.totalCalorias} / ${sec.metaCalorias} kcal',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isEmpty
                                      ? Colors.grey.shade300
                                      : color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progreso,
                              backgroundColor: Colors.grey.shade100,
                              color: color,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isEmpty) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 44),
                    child: Text(
                      sec.etiquetaEstado,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  Widgets existentes (sin cambios)
  // ══════════════════════════════════════════════════════════
  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_verdeOscuro, _verdeClaro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _verde.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Text('🏆', style: TextStyle(fontSize: 44)),
          ),
          const SizedBox(height: 12),
          Text(
            '${appState.puntosTotal}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 3,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const Text(
            'Puntos Totales',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '¡Sigue así!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _verdeOscuro,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(double comidasProgress, double retosProgress) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '🍽️',
            'Comidas',
            '${(comidasProgress * 100).toInt()}%',
            comidasProgress,
            _verdeClaro,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🎯',
            'Retos',
            '${(retosProgress * 100).toInt()}%',
            retosProgress,
            _naranja,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String emoji, String label, String value, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressChart() {
    final List<FlSpot> spots = [
      const FlSpot(0, 2),
      const FlSpot(1, 3),
      const FlSpot(2, 5),
      const FlSpot(3, 4),
      const FlSpot(4, 6),
      const FlSpot(5, 7),
      const FlSpot(6, 5),
    ];

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 35),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitles,
                reservedSize: 30,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: _verde,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: _verde.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _bottomTitles(double value, TitleMeta meta) {
    const days = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        days[value.toInt()],
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildMealDistributionChart() {
    // Datos reales: calorías por sección
    final secciones = appState.secciones;
    final totalCal = appState.totalCalorias;

    // Si no hay datos, mostrar placeholder
    if (totalCal == 0) {
      return Container(
        height: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline,
                  size: 48, color: Colors.grey.shade200),
              const SizedBox(height: 12),
              Text(
                'Registra comidas para ver la distribución',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final colores = [_verde, _verdeClaro, _naranja, _azul, Colors.purple.shade300];
    final sections = <PieChartSectionData>[];

    for (int i = 0; i < secciones.length; i++) {
      final sec = secciones[i];
      if (sec.totalCalorias == 0) continue;
      final pct = sec.totalCalorias / totalCal;
      sections.add(
        PieChartSectionData(
          value: sec.totalCalorias.toDouble(),
          title: '${(pct * 100).toInt()}%',
          color: colores[i % colores.length],
          radius: 60,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Leyenda
          Wrap(
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < secciones.length; i++)
                if (secciones[i].totalCalorias > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colores[i % colores.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        secciones[i].nombre,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesCard(int completados, int total) {
    final porcentaje = total == 0 ? 0.0 : completados / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: porcentaje,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade200,
                  color: _naranja,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${(porcentaje * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _verdeOscuro,
                    ),
                  ),
                  const Text(
                    'Completado',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$completados de $total retos completados',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¡Cada reto completado te acerca más a tu meta! 🌟',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    String emoji,
    String titulo,
    int valor,
    int total,
    Color color,
  ) {
    final porcentaje = total == 0 ? 0.0 : valor / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '$valor / $total',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: porcentaje,
            backgroundColor: Colors.grey.shade200,
            color: color,
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
