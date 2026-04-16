import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import 'test_habitos_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ════════════════════════════════════════════════════════════
//  HomeScreen - Versión con Iconos en lugar de Emojis
// ════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  final AppState appState;
  const HomeScreen({super.key, required this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;
  
  // Paleta de colores más suave y profesional
  static const Color _verdeSuave = Color(0xFF4A9B6E);
  static const Color _verdeClaro = Color(0xFF7BC47F);
  static const Color _naranja = Color(0xFFFFB347);
  static const Color _crema = Color(0xFFFDF8F0);
  static const Color _grisTexto = Color(0xFF4A5568);
  static const Color _grisClaro = Color(0xFFE2E8F0);
  
  static const Map<String, IconData> _iconosComida = {
    'Desayuno': Icons.free_breakfast,
    'Almuerzo': Icons.lunch_dining,
    'Cena': Icons.dinner_dining,
    'Fruta': Icons.apple,
    'Agua': Icons.water_drop,
  };
  
  static const Map<String, IconData> _iconosReto = {
    'Sin Gaseosa': Icons.local_drink,
    'Desayunar': Icons.bedroom_parent,
    'Fruta Diaria': Icons.apple,
    'Sin Frituras': Icons.kitchen,
    'Beber 2L de agua': Icons.water_drop,
  'No comida chatarra': Icons.fastfood,
  'Cocinar en casa': Icons.restaurant,
  'Comer sin celular': Icons.self_improvement,
  'Dormir 8 horas': Icons.bed,
  'No comer tarde': Icons.nightlight_round,
  };
  
  static const Map<String, int> _ptsReto = {
    'Sin Gaseosa': 30, 'Desayunar': 40, 'Fruta Diaria': 20, 'Sin Frituras': 20,
  };
  
  int get _puntos => widget.appState.retos.entries
      .where((e) => e.value)
      .fold(0, (s, e) => s + (_ptsReto[e.key] ?? 0));

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) => Scaffold(
        backgroundColor: _crema,
        body: Column(
          children: [
            _buildHeader(),
            _buildSegmentedControl(),
            Expanded(
              child: IndexedStack(
                index: _seccion,
                children: [
                  _TabTest(appState: widget.appState),
                  _TabRegistro(),
                  _TabRetos(appState: widget.appState, iconos: _iconosReto, pts: _ptsReto),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_verdeSuave, _verdeClaro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _verdeSuave.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(child: Icon(Icons.eco, color: Colors.white, size: 26)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ALIMENTATE+', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    Text('Tu salud, tu hábito', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: _puntos),
                duration: const Duration(milliseconds: 500),
                builder: (context, int value, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                        const SizedBox(width: 5),
                        Text('$value pts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(0, Icons.assignment, 'Test', _verdeSuave)),
          const SizedBox(width: 12),
          Expanded(child: _buildTabButton(1, Icons.edit_calendar, 'Registro', _naranja)),
          const SizedBox(width: 12),
          Expanded(child: _buildTabButton(2, Icons.emoji_events, 'Retos', _verdeClaro)),
        ],
      ),
    );
  }
  
  Widget _buildTabButton(int index, IconData icon, String label, Color color) {
    final isActive = _seccion == index;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _seccion = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 56,
        decoration: BoxDecoration(
          gradient: isActive 
              ? LinearGradient(
                  colors: [color, color.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive 
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
          border: isActive ? null : Border.all(color: _grisClaro, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isActive ? Colors.white : _grisTexto),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : _grisTexto,
              letterSpacing: 0.3,
            )),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Test Section
// ════════════════════════════════════════════════════════════
// ══════════════════════════════════════════
//  TAB TEST — versión mejorada
// ══════════════════════════════════════════

class _TabTest extends StatelessWidget {
  final AppState appState;
  const _TabTest({required this.appState});

  static const Color _verde = Color(0xFF4A9B6E);
  static const Color _verdeClaro = Color(0xFF6DBF8A);
  static const Color _ambar = Color(0xFFE09030);
  static const Color _rojo = Color(0xFFC94040);

  @override
  Widget build(BuildContext context) {
    if (appState.resultadoTest != null) {
      return _buildResultado(context);
    }
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: _TestInline(),
    );
  }

  Widget _buildResultado(BuildContext context) {
    final puntos = appState.resultadoTest!;
    final scoreNorm = (puntos / 10).round() * 10; // normalizado sobre 100
    final color = puntos >= 60
        ? _verde
        : puntos >= 40
            ? _ambar
            : _rojo;
    final nivel = puntos >= 80
        ? 'Excelente'
        : puntos >= 60
            ? 'Muy bien'
            : puntos >= 40
                ? 'Regular'
                : 'Necesita mejorar';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        children: [
          // ── tarjeta principal con anillo ──
          _ResultCard(puntos: puntos, color: color, nivel: nivel),
          const SizedBox(height: 16),

          // ── 3 métricas ──
          Row(
            children: [
              _StatBox(valor: '$puntos', label: 'puntos', color: color),
              const SizedBox(width: 10),
              _StatBox(valor: '10', label: 'máximo', color: Colors.grey.shade400),
              const SizedBox(width: 10),
              _StatBox(valor: '${(puntos / 10 * 100).round()}%', label: 'logrado', color: color),
            ],
          ),
          const SizedBox(height: 16),

          // ── consejo del día ──
          const _TipDelDia(),
          const SizedBox(height: 16),

          // ── repetir ──
          _ActionRow(
            icon: Icons.refresh_rounded,
            title: 'Repetir el test',
            subtitle: 'Vuelve a evaluarte y compara tu progreso',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TestHabitosScreen(appState: appState)),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── anillo + nivel ──────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final int puntos;
  final Color color;
  final String nivel;
  const _ResultCard(
      {required this.puntos, required this.color, required this.nivel});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: puntos / 10),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // anillo SVG-style con CustomPaint
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(96, 96),
                      painter: _RingPainter(progress: value / 10, color: color),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$puntos',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: color,
                            height: 1,
                          ),
                        ),
                        Text(
                          'de 10',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TU RESULTADO',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nivel,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: color,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: value / 10,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── anillo circular custom ──────────────────────────────────

// ── caja de métrica ─────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;
  const _StatBox(
      {required this.valor, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: color),
            ),
            const SizedBox(height: 2),
            Text(label,
                style:
                    TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

// ── fila de acción (repetir, etc.) ──────────────────────────
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  static const Color _verde = Color(0xFF4A9B6E);

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _verde.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: _verde, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//  TEST INLINE — versión mejorada
// ══════════════════════════════════════════


class _TestInline extends StatefulWidget {
  const _TestInline();

  @override
  State<_TestInline> createState() => _TestInlineState();
}

class _TestInlineState extends State<_TestInline> {
  static const Color _verde = Color(0xFF4A9B6E);
  
  final List<Map<String, dynamic>> _preguntas = const [
    {
      'p': '¿Con qué frecuencia acompañas tus comidas con gaseosas o refrescos azucarados?',
      'o': ['Nunca', '1-2 veces por semana', 'Casi todos los días'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Cuántos vasos de agua pura bebes al día?',
      'o': ['Menos de 3', 'De 4 a 6', '8 o más'],
      'pts': [0.0, 0.41, 0.83]
    },
    {
      'p': '¿Sueles añadir azúcar adicional a tus jugos o bebidas?',
      'o': ['No, prefiero el sabor natural', 'Un poco', 'Sí, bastante'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Cuántas porciones de fruta consumes en un día normal?',
      'o': ['Ninguna', '1-2 porciones', '3 o más porciones'],
      'pts': [0.0, 0.41, 0.83]
    },
    {
      'p': '¿Incluyes verduras o ensaladas en tu almuerzo y cena?',
      'o': ['Siempre', 'A veces', 'Casi nunca'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Qué tipo de snacks consumes durante el descanso escolar?',
      'o': ['Fruta o frutos secos', 'Galletas o lácteos', 'Paquetes, frituras o comida rápida'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Realizas alguna actividad mientras comes (ver TV, usar el celular)?',
      'o': ['No, me concentro en comer', 'A veces', 'Siempre uso una pantalla'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿A qué hora sueles hacer tu última comida del día (cena)?',
      'o': ['Antes de las 8:00 PM', 'Entre 8:00 y 9:30 PM', 'Después de las 10:00 PM'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Sientes cansancio o falta de concentración durante las clases?',
      'o': ['Casi nunca', 'Frecuentemente', 'Todos los días'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Cuántas veces a la semana consumes alimentos de paquete (papas fritas, chitos, etc.)?',
      'o': ['0-1 vez', '2-4 veces', 'Más de 5 veces'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Sabes identificar cuáles alimentos son "ultraprocesados" al leer una etiqueta?',
      'o': ['Sí, perfectamente', 'Tengo dudas', 'No sé qué son'],
      'pts': [0.83, 0.41, 0.0]
    },
    {
      'p': '¿Con qué frecuencia preparas o llevas comida saludable desde casa?',
      'o': ['A diario', '2-3 veces por semana', 'Prefiero comprar en la tienda escolar'],
      'pts': [0.83, 0.41, 0.0]
    },
  ];
  
  final Map<int, int> _resp = {};
  
  bool get _completo => _resp.length == _preguntas.length;
  
  double get _total => _resp.entries
      .fold(0.0, (s, e) => s + (_preguntas[e.key]['pts'] as List<double>)[e.value]);

  @override
  Widget build(BuildContext context) {
    final done = _resp.length;
    final total = _preguntas.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── header ──
        const Text(
          'Test de hábitos',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Descubre cómo están tus hábitos de salud',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 24),

        // ── barra de progreso (aparece desde la 1ra respuesta) ──
        if (done > 0) ...[
          Row(
            children: [
              Text(
                '$done de $total respondidas',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '${(done / total * 100).round()}%',
                style: const TextStyle(
                    fontSize: 12,
                    color: _verde,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: done / total,
              backgroundColor: Colors.grey.shade100,
              color: _verde,
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // ── preguntas ──
        ...List.generate(_preguntas.length, (i) => _buildPregunta(i)),
        const SizedBox(height: 8),

        // ── botón resultado ──
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: _completo
                ? const LinearGradient(
                    colors: [Color(0xFF4A9B6E), Color(0xFF7BC47F)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: _completo ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
            boxShadow: _completo
                ? [
                    BoxShadow(
                      color: _verde.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _completo ? () => _mostrarResultado(context) : null,
              child: Center(
                child: Text(
                  _completo
                      ? 'Ver mi resultado'
                      : 'Completa todas las preguntas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color:
                        _completo ? Colors.white : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPregunta(int i) {
    final p = _preguntas[i];
    final respondida = _resp.containsKey(i);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: respondida
              ? _verde.withOpacity(0.3)
              : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── número + pregunta ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: respondida
                      ? _verde
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: respondida
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 15)
                    : Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  p['p'] as String,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── opciones ──
          ...(p['o'] as List<String>).asMap().entries.map((e) {
            final sel = _resp[i] == e.key;
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _resp[i] = e.key);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: sel
                      ? _verde.withOpacity(0.07)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? _verde : Colors.grey.shade200,
                    width: sel ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // radio custom
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: sel ? _verde : Colors.transparent,
                        border: Border.all(
                          color: sel ? _verde : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: sel
                          ? const Icon(Icons.check_rounded,
                              size: 13, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel ? _verde : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _mostrarResultado(BuildContext context) {
    HapticFeedback.mediumImpact();
    final total = _total;
    final color = total >= 6.0
        ? const Color(0xFF4A9B6E)
        : total >= 4.0
            ? const Color(0xFFE09030)
            : const Color(0xFFC94040);
    final nivel = total >= 8.0
        ? 'Excelente'
        : total >= 6.0
            ? 'Muy bien'
            : total >= 4.0
                ? 'Regular'
                : 'Necesita mejorar';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            // anillo
            SizedBox(
              width: 120,
              height: 120,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: total / 10.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    // Usar el CustomPaint existente o crear uno inline
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: _RingPainter(progress: v, color: color),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          total.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: color,
                            height: 1,
                          ),
                        ),
                        Text('de 10',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              nivel,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
            const SizedBox(height: 8),
            Text(
              'Completaste el test de hábitos',
              style: TextStyle(
                  fontSize: 14, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════════
//  Registro Section - Con Iconos
// ════════════════════════════════════════════════════════════







// ── Modelo de comida ─────────────────────────────────────────
// ── Modelo de comida ─────────────────────────────────────────
// ── Modelo de comida ─────────────────────────────────────────





// ── Modelo de comida ─────────────────────────────────────────
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

// ── Modelo de sección de comida ──────────────────────────────
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

  int get totalCalorias => comidas.fold(0, (s, c) => s + c.calorias);

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

// ── Tab de Registro de Comidas ───────────────────────────────
class _TabRegistro extends StatefulWidget {
  const _TabRegistro();

  @override
  State<_TabRegistro> createState() => _TabRegistroState();
}

class _TabRegistroState extends State<_TabRegistro> {
  static const Color _naranja = Color(0xFFE8943A);

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _calCtrl = TextEditingController();
  bool _cargandoCalorias = false;

  late final List<SeccionComida> _secciones;

  @override
  void initState() {
    super.initState();
    _secciones = [
      SeccionComida(nombre: 'Desayuno',     icono: Icons.free_breakfast,  metaCalorias: 400),
      SeccionComida(nombre: 'Media mañana', icono: Icons.coffee,          metaCalorias: 200),
      SeccionComida(nombre: 'Almuerzo',     icono: Icons.lunch_dining,    metaCalorias: 700),
      SeccionComida(nombre: 'Media tarde',  icono: Icons.apple,           metaCalorias: 200),
      SeccionComida(nombre: 'Cena',         icono: Icons.dinner_dining,   metaCalorias: 500),
    ];
  }

  int get _totalDia =>
      _secciones.fold(0, (s, sec) => s + sec.totalCalorias);

  static const int _metaDia = 2000;

  ({String mensaje, Color color, IconData icono}) get _estadoDia {
    final total = _totalDia;
    if (total == 0) {
      return (
        mensaje: 'Aún no has registrado nada hoy. ¡Empieza tu día!',
        color: const Color(0xFF9E9E9E),
        icono: Icons.wb_sunny_outlined,
      );
    }
    final pct = total / _metaDia;
    if (pct < 0.5) {
      return (
        mensaje: 'Estás comiendo muy poco hoy. Tu cuerpo necesita energía',
        color: const Color(0xFF2196F3),
        icono: Icons.sentiment_dissatisfied_outlined,
      );
    }
    if (pct <= 0.85) {
      return (
        mensaje: '¡Vas muy bien! Estás en el camino correcto',
        color: const Color(0xFF4CAF50),
        icono: Icons.sentiment_satisfied_alt,
      );
    }
    if (pct <= 1.0) {
      return (
        mensaje: 'Casi en tu meta diaria. ¡Excelente balance!',
        color: const Color(0xFF4CAF50),
        icono: Icons.sentiment_very_satisfied,
      );
    }
    if (pct <= 1.2) {
      return (
        mensaje: 'Has superado tu meta. Considera porciones más ligeras',
        color: _naranja,
        icono: Icons.sentiment_neutral_outlined,
      );
    }
    return (
      mensaje: 'Hoy consumiste demasiadas calorías. Descansa y come ligero mañana',
      color: const Color(0xFFE53935),
      icono: Icons.sentiment_very_dissatisfied_outlined,
    );
  }

  static const Map<String, int> _tablaLocal = {
    'arepa': 160, 'arepa con huevo': 280, 'arepa con queso': 240,
    'pan': 80, 'pan integral': 70, 'tostada': 75, 'croissant': 230,
    'empanada': 250, 'pandebono': 180, 'buñuelo': 210,
    'tamal': 380, 'changua': 150, 'caldo': 120,
    'manzana': 80, 'banano': 90, 'banana': 90, 'platano': 90,
    'naranja': 60, 'mandarina': 45, 'uvas': 70, 'pera': 85,
    'mango': 100, 'piña': 50, 'papaya': 55, 'melón': 40,
    'sandía': 30, 'fresa': 35, 'fresas': 35, 'kiwi': 60,
    'pollo': 165, 'pechuga': 165, 'pechuga de pollo': 165,
    'carne': 250, 'res': 250, 'carne de res': 250,
    'cerdo': 240, 'costilla': 290, 'chuleta': 220,
    'pescado': 150, 'tilapia': 120, 'salmon': 180, 'salmón': 180,
    'atun': 130, 'atún': 130, 'huevo': 78, 'huevos': 155,
    'chorizo': 290, 'salchicha': 180,
    'leche': 150, 'yogurt': 100, 'yogur': 100, 'queso': 110,
    'kumis': 120, 'kéfir': 100,
    'arroz': 200, 'papa': 130, 'papas fritas': 320,
    'pasta': 220, 'espagueti': 220, 'fideos': 200,
    'lentejas': 230, 'frijoles': 220, 'fríjoles': 220,
    'garbanzos': 270, 'quinua': 220, 'avena': 150,
    'yuca': 160, 'plátano maduro': 120, 'patacón': 180,
    'ensalada': 50, 'lechuga': 15, 'tomate': 20, 'zanahoria': 40,
    'brócoli': 55, 'espinaca': 25, 'cebolla': 40, 'pepino': 15,
    'bandeja paisa': 1200, 'sancocho': 400, 'ajiaco': 380,
    'sopa': 200, 'hamburguesa': 550, 'pizza': 285,
    'burrito': 450, 'wrap': 350, 'sándwich': 300,
    'hot dog': 290, 'perro caliente': 290,
    'jugo': 120, 'jugo de naranja': 110, 'café': 5,
    'café con leche': 80, 'tinto': 5, 'chocolate': 200,
    'gaseosa': 140, 'agua': 0,
    'galletas': 140, 'chips': 160,
    'maní': 170, 'almendras': 160, 'nueces': 185,
    'brownie': 240, 'torta': 350, 'helado': 200,
    'obleas': 150, 'chocoramo': 320,
  };

  Future<void> _estimarCalorias(String nombre) async {
    if (nombre.trim().isEmpty) return;
    setState(() {
      _cargandoCalorias = true;
      _calCtrl.clear();
    });
    final query = nombre.trim().toLowerCase();
    try {
      if (_tablaLocal.containsKey(query)) {
        if (mounted) setState(() => _calCtrl.text = _tablaLocal[query]!.toString());
        return;
      }
      for (final entry in _tablaLocal.entries) {
        if (query.contains(entry.key) || entry.key.contains(query)) {
          if (mounted) setState(() => _calCtrl.text = entry.value.toString());
          return;
        }
      }
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl'
        '?search_terms=${Uri.encodeComponent(nombre.trim())}'
        '&search_simple=1&action=process&json=1&page_size=5'
        '&fields=product_name,nutriments',
      );
      final response = await http.get(uri, headers: {'User-Agent': 'CaloriasApp/1.0'})
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productos = data['products'] as List? ?? [];
        for (final prod in productos) {
          final nutriments = prod['nutriments'];
          if (nutriments == null) continue;
          final kcal = (nutriments['energy-kcal_100g'] ??
              nutriments['energy-kcal'] ?? 0).toDouble();
          if (kcal > 0) {
            final porcion = (kcal * 1.5).round();
            if (mounted) setState(() => _calCtrl.text = porcion.toString());
            return;
          }
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No encontré "$nombre". Ingresa las calorías manualmente.'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Sin conexión. Ingresa las calorías manualmente.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _cargandoCalorias = false);
    }
  }

  void _agregarComidaASeccion(SeccionComida seccion, {String? nombre, int? calorias, IconData? icono}) {
    final n = nombre ?? _nombreCtrl.text.trim();
    final c = calorias ?? int.tryParse(_calCtrl.text.trim());
    if (n.isEmpty || c == null || c <= 0) return;
    setState(() {
      seccion.comidas.add(Comida(nombre: n, calorias: c, icono: icono ?? Icons.restaurant));
    });
    _nombreCtrl.clear();
    _calCtrl.clear();
  }

  void _eliminarComida(SeccionComida seccion, int index) {
    HapticFeedback.lightImpact();
    setState(() => seccion.comidas.removeAt(index));
  }

  // ── Ejemplos por sección para el banner informativo ──────────
  static const Map<String, String> _ejemplosPorSeccion = {
    'Desayuno': 'pan tostado, mantequilla, huevo revuelto, jugo de naranja',
    'Media mañana': 'manzana, almendras, yogurt',
    'Almuerzo': 'arroz, frijoles, pollo, ensalada, jugo',
    'Media tarde': 'galletas, maní, agua',
    'Cena': 'sopa, pan, queso, leche',
  };

  void _mostrarFormularioSeccion(SeccionComida seccion) {
    _nombreCtrl.clear();
    _calCtrl.clear();

    final sugerenciasPorSeccion = {
      'Desayuno': [
        Comida(nombre: 'Arepa con huevo', calorias: 280, icono: Icons.egg_alt),
        Comida(nombre: 'Avena', calorias: 150, icono: Icons.breakfast_dining),
        Comida(nombre: 'Changua', calorias: 150, icono: Icons.soup_kitchen),
        Comida(nombre: 'Tostada', calorias: 75, icono: Icons.bakery_dining),
      ],
      'Media mañana': [
        Comida(nombre: 'Fruta', calorias: 80, icono: Icons.apple),
        Comida(nombre: 'Almendras', calorias: 160, icono: Icons.spa),
        Comida(nombre: 'Yogurt', calorias: 100, icono: Icons.local_drink),
        Comida(nombre: 'Galletas', calorias: 140, icono: Icons.cookie),
      ],
      'Almuerzo': [
        Comida(nombre: 'Bandeja paisa', calorias: 1200, icono: Icons.set_meal),
        Comida(nombre: 'Sancocho', calorias: 400, icono: Icons.soup_kitchen),
        Comida(nombre: 'Arroz con pollo', calorias: 450, icono: Icons.lunch_dining),
        Comida(nombre: 'Ensalada', calorias: 50, icono: Icons.eco),
      ],
      'Media tarde': [
        Comida(nombre: 'Snack', calorias: 150, icono: Icons.cookie),
        Comida(nombre: 'Batido', calorias: 250, icono: Icons.local_drink),
        Comida(nombre: 'Fruta', calorias: 80, icono: Icons.apple),
        Comida(nombre: 'Maní', calorias: 170, icono: Icons.grain),
      ],
      'Cena': [
        Comida(nombre: 'Sopa', calorias: 200, icono: Icons.soup_kitchen),
        Comida(nombre: 'Sándwich', calorias: 300, icono: Icons.lunch_dining),
        Comida(nombre: 'Ensalada', calorias: 50, icono: Icons.eco),
        Comida(nombre: 'Ajiaco', calorias: 380, icono: Icons.dinner_dining),
      ],
    };

    final sugerencias = sugerenciasPorSeccion[seccion.nombre] ?? [];
    final ejemplo = _ejemplosPorSeccion[seccion.nombre] ?? 'arroz, pollo, ensalada';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 28),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Handle ──────────────────────────────────
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Título ───────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: _naranja.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(seccion.icono, color: _naranja, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seccion.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          '${seccion.comidas.length} alimento${seccion.comidas.length != 1 ? 's' : ''} registrado${seccion.comidas.length != 1 ? 's' : ''}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Banner informativo ────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBBD6F5)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Color(0xFF1976D2), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1565C0),
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'Registra un alimento a la vez.\n',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: 'Para mayor precisión, agrega cada ingrediente por separado. Por ejemplo, en lugar de "sándwich", registra ',
                              ),
                              TextSpan(
                                text: 'pan, jamón y queso',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: ' de forma individual.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── Ejemplo de la sección ─────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    'Ej. para esta comida: $ejemplo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Acceso rápido ────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 3, height: 14,
                      decoration: BoxDecoration(
                        color: _naranja,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Acceso rápido',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sugerencias.map((s) => GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _agregarComidaASeccion(seccion, nombre: s.nombre, calorias: s.calorias, icono: s.icono);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(s.icono, size: 14, color: _naranja),
                          const SizedBox(width: 6),
                          Text(
                            s.nombre,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2D2D2D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 24),

                // ── Separador sección personalizada ───────────
                Row(
                  children: [
                    Container(
                      width: 3, height: 14,
                      decoration: BoxDecoration(
                        color: _naranja,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Agregar personalizado',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Campo nombre + buscar ────────────────────
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nombreCtrl,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (val) async {
                          await _estimarCalorias(val);
                          setSheet(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Nombre del alimento',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: Icon(Icons.restaurant_outlined,
                              color: Colors.grey.shade400, size: 20),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: _naranja.withOpacity(0.5), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _cargandoCalorias
                          ? null
                          : () async {
                              await _estimarCalorias(_nombreCtrl.text);
                              setSheet(() {});
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _naranja,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _naranja.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _cargandoCalorias
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search_rounded, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Campo calorías ───────────────────────────
                StatefulBuilder(
                  builder: (_, setField) {
                    _calCtrl.addListener(() => setField(() {}));
                    return TextField(
                      controller: _calCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Calorías estimadas (kcal)',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.local_fire_department_outlined,
                          color: _calCtrl.text.isNotEmpty
                              ? Colors.green.shade400
                              : Colors.grey.shade400,
                          size: 20,
                        ),
                        suffixIcon: _calCtrl.text.isNotEmpty
                            ? Icon(Icons.check_circle_rounded,
                                color: Colors.green.shade400, size: 18)
                            : null,
                        filled: true,
                        fillColor: _calCtrl.text.isNotEmpty
                            ? Colors.green.shade50
                            : Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _calCtrl.text.isNotEmpty
                                ? Colors.green.shade200
                                : Colors.grey.shade100,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                              color: _naranja.withOpacity(0.5), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // ── Botón agregar ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _agregarComidaASeccion(seccion);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _naranja,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Agregar alimento',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _calCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estadoDia;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            const Text(
              'Registro de comidas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Agrega cada alimento por separado para mayor precisión',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 20),

            // ── Tarjeta mensaje del día ──────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: estado.color.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: estado.color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: estado.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(estado.icono, color: estado.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Solo barra de progreso del día (sin número) ──
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: (_totalDia / _metaDia).clamp(0.0, 1.0),
                            backgroundColor: Colors.grey.shade200,
                            color: estado.color,
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          estado.mensaje,
                          style: TextStyle(
                            fontSize: 12,
                            color: estado.color.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Secciones de comida ──────────────────────────
            ..._secciones.map((sec) => _SeccionCard(
                  seccion: sec,
                  onAgregar: () => _mostrarFormularioSeccion(sec),
                  onEliminar: (i) => _eliminarComida(sec, i),
                )),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta de sección expandible ────────────────────────────
class _SeccionCard extends StatefulWidget {
  final SeccionComida seccion;
  final VoidCallback onAgregar;
  final void Function(int) onEliminar;

  const _SeccionCard({
    required this.seccion,
    required this.onAgregar,
    required this.onEliminar,
  });

  @override
  State<_SeccionCard> createState() => _SeccionCardState();
}

class _SeccionCardState extends State<_SeccionCard>
    with SingleTickerProviderStateMixin {
  bool _expandido = false;
  late AnimationController _animCtrl;
  late Animation<double> _rotacion;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rotacion = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expandido = !_expandido);
    _expandido ? _animCtrl.forward() : _animCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final sec = widget.seccion;
    final color = sec.colorEstado;
    final isEmpty = sec.comidas.isEmpty;
    final progreso = (sec.totalCalorias / sec.metaCalorias).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _expandido ? color.withOpacity(0.3) : Colors.grey.shade100,
          width: _expandido ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Cabecera ──────────────────────────────────────
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icono
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(sec.icono, size: 20, color: color),
                  ),
                  const SizedBox(width: 12),

                  // Nombre + barra + etiqueta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sec.nombre,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // ── Barra de progreso sin número ──────
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progreso,
                            backgroundColor: Colors.grey.shade100,
                            color: color,
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isEmpty ? 'Sin registros' : sec.etiquetaEstado,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                            if (!isEmpty) ...[
                              const SizedBox(width: 6),
                              Text(
                                '${sec.comidas.length} item${sec.comidas.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade400),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Flecha
                  RotationTransition(
                    turns: _rotacion,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade300, size: 22),
                  ),
                ],
              ),
            ),
          ),

          // ── Contenido expandible ───────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                // Separador fino
                Divider(height: 1, color: Colors.grey.shade100),
                const SizedBox(height: 12),

                // Lista de comidas
                if (sec.comidas.isNotEmpty)
                  ...List.generate(sec.comidas.length, (i) {
                    final c = sec.comidas[i];
                    return _ComidaItem(
                      comida: c,
                      isLast: i == sec.comidas.length - 1,
                      onEliminar: () => widget.onEliminar(i),
                      colorAccent: color,
                    );
                  })
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Icon(sec.icono, size: 26, color: Colors.grey.shade200),
                          const SizedBox(height: 8),
                          Text(
                            'Sin alimentos registrados',
                            style: TextStyle(
                                color: Colors.grey.shade300, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),

                // Botón agregar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: widget.onAgregar,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Agregar alimento'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color.withOpacity(0.3)),
                        backgroundColor: color.withOpacity(0.04),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: _expandido
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ── Item de comida ───────────────────────────────────────────
class _ComidaItem extends StatelessWidget {
  final Comida comida;
  final bool isLast;
  final VoidCallback onEliminar;
  final Color colorAccent;

  const _ComidaItem({
    required this.comida,
    required this.isLast,
    required this.onEliminar,
    required this.colorAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300),
      ),
      onDismissed: (_) => onEliminar(),
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colorAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(comida.icono, size: 17, color: colorAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                comida.nombre,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ),
            // ── Solo barra de porción, sin número ──────────
            SizedBox(
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: (comida.calorias / 600).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade100,
                  color: colorAccent.withOpacity(0.6),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'Eliminar alimento',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    content: Text(
                      '¿Quieres eliminar "${comida.nombre}"?',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onEliminar();
                        },
                        child: const Text('Eliminar',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Icon(Icons.delete_outline_rounded,
                    size: 15, color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── RingPainter ───────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 7,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - strokeWidth;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
    canvas.drawArc(rect, -1.5708, 6.2832, false,
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round);
    if (progress > 0) {
      canvas.drawArc(rect, -1.5708, 6.2832 * progress, false,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}








































// ════════════════════════════════════════════════════════════
//  Retos Section - Con Iconos
// ════════════════════════════════════════════════════════════
class _TabRetos extends StatefulWidget {
  final AppState appState;
  final Map<String, IconData> iconos;
  final Map<String, int> pts;

  const _TabRetos({
    required this.appState,
    required this.iconos,
    required this.pts,
  });

  @override
  State<_TabRetos> createState() => _TabRetosState();
}

class _TabRetosState extends State<_TabRetos> {
  static const Color _verde = Color(0xFF7BC47F);
  
  // Sistema de racha (streak)
  int _racha = 0;
  String _retoActivo = '';
  
  // Retos adicionales
  final List<String> _retosAdicionales = [
    'Evitar comida chatarra',
    'Cocinar en casa',
    'Leer etiquetas nutricionales',
    'Comer sin distracciones',
    'Registrar lo que como',
    'Probar una verdura nueva',
    'Reducir porciones',
    'Comer a horario fijo',
  ];

  @override
  void initState() {
    super.initState();
    _calcularRacha();
  }

  void _calcularRacha() {
    // Calcula cuántos retos completó hoy para determinar la racha
    int completadosHoy = widget.appState.retos.values.where((v) => v == true).length;
    if (completadosHoy >= 3) {
      _racha = (_racha + 1).clamp(0, 7);
    } else {
      _racha = 0;
    }
  }

  void _seleccionarRetoActivo() {
    // Selecciona un reto aleatorio no completado como reto activo
    final noCompletados = widget.appState.retos.entries
        .where((e) => e.value == false)
        .map((e) => e.key)
        .toList();
    
    if (noCompletados.isNotEmpty) {
      noCompletados.shuffle();
      _retoActivo = noCompletados.first;
    }
  }

  int _calcularPuntosBonus() {
    // Puntos bonus por racha
    return _racha * 5;
  }

  @override
  Widget build(BuildContext context) {
    final completados = widget.appState.retos.values.where((v) => v == true).length;
    final total = widget.appState.retos.length;
    
    if (_retoActivo.isEmpty) {
      _seleccionarRetoActivo();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER MEJORADO
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sistema de Retos',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Completa metas diarias para mejorar tus habitos',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _verde.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 18, color: _verde),
                    const SizedBox(width: 6),
                    Text('$completados/$total',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _verde)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// PROGRESO GENERAL CON ANIMACION
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: total == 0 ? 0 : completados / total),
            duration: const Duration(milliseconds: 600),
            builder: (_, value, __) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: _verde,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// SISTEMA DE RACHA (NUEVO)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _racha > 0 ? _verde.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _racha > 0 ? _verde : Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _racha > 0 ? Icons.local_fire_department : Icons.bolt_outlined,
                  color: _racha > 0 ? _verde : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _racha > 0 ? "Racha activa: $_racha dias" : "Sin racha activa",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _racha > 0 ? _verde : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _racha > 0 
                            ? "Completa 3 retos diarios para mantener tu racha"
                            : "Completa 3 retos hoy para iniciar una racha",
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (_racha > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _verde,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "+$_racha",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// RETO DESTACADO (NUEVO - MÁS DINÁMICO)
          if (_retoActivo.isNotEmpty && !widget.appState.retos[_retoActivo]!)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_verde, _verde.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _verde.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "RETO DESTACADO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "+${(widget.pts[_retoActivo] ?? 20) + _calcularPuntosBonus()} pts",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        widget.iconos[_retoActivo] ?? Icons.flag,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _retoActivo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          widget.appState.toggleReto(_retoActivo);
                          _calcularRacha();
                          _mostrarMensaje(context, _retoActivo, true);
                          _seleccionarRetoActivo();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _verde,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("COMPLETAR RETO"),
                    ),
                  ),
                ],
              ),
            ),

          /// GRID DE RETOS MEJORADO
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.9,
            ),
            itemCount: widget.appState.retos.length,
            itemBuilder: (_, i) {
              final key = widget.appState.retos.keys.elementAt(i);
              final completado = widget.appState.retos[key]!;
              final esRetoActivo = key == _retoActivo && !completado;
              final puntosBonus = esRetoActivo ? _calcularPuntosBonus() : 0;

              return _RetoCardMejorado(
                key: ValueKey(key),
                icono: widget.iconos[key] ?? Icons.flag,
                label: key,
                puntosBase: widget.appState.puntos[key] ?? 20,
                puntosBonus: puntosBonus,
                completado: completado,
                esDestacado: esRetoActivo,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (!completado) {
                    setState(() {
                      widget.appState.toggleReto(key);
                      _calcularRacha();
                      _mostrarMensaje(context, key, false);
                      if (key == _retoActivo) {
                        _seleccionarRetoActivo();
                      }
                    });
                  }
                },
              );
            },
          ),

          const SizedBox(height: 24),

          /// TIP DEL DIA SIN EMOJIS
          const _TipDelDia(),
        ],
      ),
    );
  }

  void _mostrarMensaje(BuildContext context, String reto, bool esDestacado) {
    final mensajesBase = [
      "Mision completada. Sigue asi con tu progreso",
      "Registro actualizado. Tu constancia esta dando resultados",
      "Objetivo alcanzado. Cada reto completado te acerca a tu meta",
      "Buen trabajo. Manten el ritmo en los siguientes retos",
      "Logro registrado. La disciplina diaria construye habitos duraderos",
    ];
    
    final mensajesRacha = [
      "Racha de $_racha dias. Excelente consistencia",
      "Has mantenido tu racha activa por $_racha dias",
      "Tu disciplina suma $_racha dias consecutivos",
    ];

    mensajesBase.shuffle();
    String mensaje = mensajesBase.first;
    
    if (_racha > 0 && _racha % 3 == 0) {
      mensajesRacha.shuffle();
      mensaje = mensajesRacha.first;
    }
    
    if (esDestacado) {
      mensaje = "Reto destacado completado. +${(widget.pts[reto] ?? 20) + _calcularPuntosBonus()} puntos";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: _verde,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _RetoCardMejorado extends StatelessWidget {
  final IconData icono;
  final String label;
  final int puntosBase;
  final int puntosBonus;
  final bool completado;
  final bool esDestacado;
  final VoidCallback onTap;

  const _RetoCardMejorado({
    super.key,
    required this.icono,
    required this.label,
    required this.puntosBase,
    required this.puntosBonus,
    required this.completado,
    required this.esDestacado,
    required this.onTap,
  });

  static const Color _verde = Color(0xFF7BC47F);
  
  int get puntosTotales => puntosBase + puntosBonus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: completado
              ? LinearGradient(colors: [_verde, _verde.withOpacity(0.85)])
              : (esDestacado && !completado)
                  ? LinearGradient(
                      colors: [_verde.withOpacity(0.15), _verde.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
          color: completado ? null : (esDestacado ? null : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: esDestacado && !completado
              ? Border.all(color: _verde, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: completado
                  ? _verde.withOpacity(0.3)
                  : (esDestacado ? _verde.withOpacity(0.2) : Colors.black.withOpacity(0.05)),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICONO Y ESTADO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icono,
                    size: 32,
                    color: completado ? Colors.white : (esDestacado ? _verde : _verde)),
                if (completado)
                  const Icon(Icons.check_circle, color: Colors.white)
                else if (esDestacado)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _verde,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "ACTIVO",
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const Spacer(),

            /// NOMBRE
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: completado ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            /// PROGRESO
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: completado ? 1 : 0,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: completado ? Colors.white : _verde,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              completado ? "Completado" : "Pendiente",
              style: TextStyle(
                fontSize: 11,
                color: completado ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),

            /// PUNTOS CON BONUS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: completado
                    ? Colors.white24
                    : (esDestacado ? _verde.withOpacity(0.2) : _verde.withOpacity(0.15)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 4),
                  if (puntosBonus > 0 && !completado) ...[
                    Text(
                      '+$puntosBase',
                      style: const TextStyle(
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+$puntosTotales',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: completado ? Colors.white : Colors.orange,
                      ),
                    ),
                  ] else
                    Text(
                      '+${completado ? puntosBase : puntosTotales} pts',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: completado ? Colors.white : _verde,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipDelDia extends StatelessWidget {
  const _TipDelDia();

  static const List<String> _tips = [
    'Beber agua antes de comer reduce el apetito naturalmente',
    'Una fruta diaria mejora significativamente tu digestion',
    'Desayunar adecuadamente mejora tu energia durante el dia',
    'Reducir el consumo de azucar proporciona energia mas estable',
    'Comer despacio ayuda a evitar excesos y mejora la digestion',
    'Las proteinas en el desayuno aumentan la saciedad matutina',
    'Planificar las comidas semanalmente reduce decisiones impulsivas',
    'Masticar cada bocado adecuadamente mejora la absorcion de nutrientes',
    'El te verde acelera el metabolismo naturalmente',
    'Dormir entre 7 y 8 horas regula las hormonas del hambre',
    'Incluir fibra en cada comida mejora la salud digestiva',
    'Cocinar al vapor conserva mejor los nutrientes de los alimentos',
    'Reducir la sal ayuda a controlar la presion arterial',
    'Los frutos secos son un excelente snack energetico y saludable',
  ];

  @override
  Widget build(BuildContext context) {
    final tip = _tips[DateTime.now().day % _tips.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }
}