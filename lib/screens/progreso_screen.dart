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
        final porcentajeComidas = appState.registro.isEmpty
            ? 0.0
            : appState.comidasCompletadas / appState.registro.length;
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
              decoration: BoxDecoration(
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
                // Tarjeta de puntos mejorada
                _buildPointsCard(),
                const SizedBox(height: 20),

                // Sección de progreso general
                _buildSectionTitle('📊', 'Resumen General'),
                const SizedBox(height: 12),
                _buildStatsGrid(porcentajeComidas, porcentajeRetos),
                const SizedBox(height: 24),

                // Gráfica de progreso semanal
                _buildSectionTitle('📈', 'Progreso Semanal'),
                const SizedBox(height: 12),
                _buildWeeklyProgressChart(),
                const SizedBox(height: 24),

                // Gráfica de distribución de comidas
                _buildSectionTitle('🍽️', 'Distribución de Comidas'),
                const SizedBox(height: 12),
                _buildMealDistributionChart(),
                const SizedBox(height: 24),

                // Retos completados con gráfica circular
                _buildSectionTitle('🎯', 'Retos Completados'),
                const SizedBox(height: 12),
                _buildChallengesCard(retosCompletos, appState.retos.length),
                const SizedBox(height: 24),

                // Tarjetas de progreso individuales
                _buildSectionTitle('📋', 'Progreso Detallado'),
                const SizedBox(height: 12),
                _buildProgressCard(
                  '🍽️',
                  'Registro Diario',
                  appState.comidasCompletadas,
                  appState.registro.length,
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
              ],
            ),
          ),
        );
      },
    );
  }

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
              '¡Sigue así! 🚀',
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

  Widget _buildStatCard(String emoji, String label, String value, double progress, Color color) {
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
    // Datos de ejemplo - reemplazar con datos reales de appState
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
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 30,
              title: 'Desayuno',
              color: _verde,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 25,
              title: 'Almuerzo',
              color: _verdeClaro,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 20,
              title: 'Merienda',
              color: _naranja,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            PieChartSectionData(
              value: 25,
              title: 'Cena',
              color: _azul,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
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