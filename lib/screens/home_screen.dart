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
                  _TabRegistro(appState: widget.appState, iconos: _iconosComida),
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
                    Text('ALIMENTATE', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
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

// ── Tab de Registro de Comidas ───────────────────────────────
class _TabRegistro extends StatefulWidget {
  final AppState appState;
  final Map<String, IconData> iconos;
  const _TabRegistro({required this.appState, required this.iconos});

  @override
  State<_TabRegistro> createState() => _TabRegistroState();
}

class _TabRegistroState extends State<_TabRegistro> {
  static const Color _naranja = Color(0xFFE8943A);

  final List<Comida> _comidas = [];
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _calCtrl = TextEditingController();
  bool _cargandoCalorias = false;

  static final List<Comida> _sugerencias = [
    Comida(nombre: 'Desayuno', calorias: 350, icono: Icons.free_breakfast),
    Comida(nombre: 'Almuerzo', calorias: 600, icono: Icons.lunch_dining),
    Comida(nombre: 'Cena',     calorias: 500, icono: Icons.dinner_dining),
    Comida(nombre: 'Snack',    calorias: 150, icono: Icons.cookie),
    Comida(nombre: 'Fruta',    calorias: 80,  icono: Icons.apple),
    Comida(nombre: 'Batido',   calorias: 250, icono: Icons.local_drink),
  ];

  // ── Tabla local de respaldo (calorías por porción típica) ──
  static const Map<String, int> _tablaLocal = {
    // Desayunos / panes
    'arepa': 160, 'arepa con huevo': 280, 'arepa con queso': 240,
    'pan': 80, 'pan integral': 70, 'tostada': 75, 'croissant': 230,
    'empanada': 250, 'pandebono': 180, 'buñuelo': 210,
    'tamal': 380, 'changua': 150, 'caldo': 120,
    // Frutas
    'manzana': 80, 'banano': 90, 'banana': 90, 'platano': 90,
    'naranja': 60, 'mandarina': 45, 'uvas': 70, 'pera': 85,
    'mango': 100, 'piña': 50, 'papaya': 55, 'melón': 40,
    'sandía': 30, 'fresa': 35, 'fresas': 35, 'kiwi': 60,
    // Proteínas
    'pollo': 165, 'pechuga': 165, 'pechuga de pollo': 165,
    'carne': 250, 'res': 250, 'carne de res': 250,
    'cerdo': 240, 'costilla': 290, 'chuleta': 220,
    'pescado': 150, 'tilapia': 120, 'salmon': 180, 'salmón': 180,
    'atun': 130, 'atún': 130, 'huevo': 78, 'huevos': 155,
    'chorizo': 290, 'salchicha': 180,
    // Lácteos
    'leche': 150, 'yogurt': 100, 'yogur': 100, 'queso': 110,
    'kumis': 120, 'kéfir': 100,
    // Carbohidratos / granos
    'arroz': 200, 'papa': 130, 'papas fritas': 320,
    'pasta': 220, 'espagueti': 220, 'fideos': 200,
    'lentejas': 230, 'frijoles': 220, 'fríjoles': 220,
    'garbanzos': 270, 'quinua': 220, 'avena': 150,
    'yuca': 160, 'plátano maduro': 120, 'patacón': 180,
    // Verduras
    'ensalada': 50, 'lechuga': 15, 'tomate': 20, 'zanahoria': 40,
    'brócoli': 55, 'espinaca': 25, 'cebolla': 40, 'pepino': 15,
    // Comidas completas
    'bandeja paisa': 1200, 'sancocho': 400, 'ajiaco': 380,
    'sopa': 200, 'hamburguesa': 550, 'pizza': 285,
    'burrito': 450, 'wrap': 350, 'sándwich': 300,
    'hot dog': 290, 'perro caliente': 290,
    // Bebidas
    'jugo': 120, 'jugo de naranja': 110, 'café': 5,
    'café con leche': 80, 'tinto': 5, 'chocolate': 200,
    'gaseosa': 140, 'agua': 0,
    // Snacks / dulces
   'galletas': 140, 'chips': 160,
    'maní': 170, 'almendras': 160, 'nueces': 185,
    'brownie': 240, 'torta': 350, 'helado': 200,
    'obleas': 150, 'chocoramo': 320,
  };

  int get _totalCalorias => _comidas.fold(0, (sum, c) => sum + c.calorias);

  // ── Busca en tabla local primero, luego en Open Food Facts ──
  Future<void> _estimarCalorias(String nombre) async {
    if (nombre.trim().isEmpty) return;
    setState(() {
      _cargandoCalorias = true;
      _calCtrl.clear();
    });

    final query = nombre.trim().toLowerCase();

    try {
      // 1️⃣ Busca coincidencia exacta en tabla local
      if (_tablaLocal.containsKey(query)) {
        final cals = _tablaLocal[query]!;
        if (mounted) setState(() => _calCtrl.text = cals.toString());
        return;
      }

      // 2️⃣ Busca coincidencia parcial en tabla local
      for (final entry in _tablaLocal.entries) {
        if (query.contains(entry.key) || entry.key.contains(query)) {
          if (mounted) setState(() => _calCtrl.text = entry.value.toString());
          return;
        }
      }

      // 3️⃣ Open Food Facts API (gratuita, sin key)
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl'
        '?search_terms=${Uri.encodeComponent(nombre.trim())}'
        '&search_simple=1&action=process&json=1&page_size=5'
        '&fields=product_name,nutriments',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'CaloriasApp/1.0'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productos = data['products'] as List? ?? [];

        for (final prod in productos) {
          final nutriments = prod['nutriments'];
          if (nutriments == null) continue;

          // Calorías por 100g → estimamos porción de ~150g
          final kcalPor100g =
              (nutriments['energy-kcal_100g'] ??
               nutriments['energy-kcal'] ??
               0)
              .toDouble();

          if (kcalPor100g > 0) {
            final porcion = (kcalPor100g * 1.5).round(); // ~150g
            if (mounted) setState(() => _calCtrl.text = porcion.toString());
            return;
          }
        }
      }

      // 4️⃣ Si todo falla, avisa al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No encontré "$nombre". Ingresa las calorías manualmente.'),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error estimando calorías: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sin conexión. Ingresa las calorías manualmente.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargandoCalorias = false);
    }
  }

  void _agregarComida({String? nombre, int? calorias, IconData? icono}) {
    final n = nombre ?? _nombreCtrl.text.trim();
    final c = calorias ?? int.tryParse(_calCtrl.text.trim());
    if (n.isEmpty || c == null || c <= 0) return;

    setState(() {
      _comidas.add(Comida(
        nombre: n,
        calorias: c,
        icono: icono ?? Icons.restaurant,
      ));
    });
    _nombreCtrl.clear();
    _calCtrl.clear();
  }

  void _eliminarComida(int index) {
    HapticFeedback.lightImpact();
    setState(() => _comidas.removeAt(index));
  }

  void _mostrarFormulario() {
    _nombreCtrl.clear();
    _calCtrl.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            20, 20, 20,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Agregar comida',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              // ── Sugerencias rápidas ──────────────────────
              const Text('Acceso rápido',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sugerencias.map((s) => GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _agregarComida(
                        nombre: s.nombre,
                        calorias: s.calorias,
                        icono: s.icono);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _naranja.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _naranja.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(s.icono, size: 14, color: _naranja),
                        const SizedBox(width: 6),
                        Text('${s.nombre} · ${s.calorias} kcal',
                            style: TextStyle(
                                fontSize: 12,
                                color: _naranja,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              const Text('Personalizada',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),




              // ── Campo nombre + botón buscar ──────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        hintText: 'Nombre (ej. Arepa con huevo)',
                        prefixIcon:
                            const Icon(Icons.restaurant, color: _naranja),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
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
                      disabledBackgroundColor: _naranja.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _cargandoCalorias
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search, size: 15),
                              SizedBox(width: 4),
                              Text('Buscar',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                  ),
                ],
              ),





              
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  'Escribe el nombre y toca "Buscar" para estimar las calorías',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
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
                      hintText: 'Calorías (kcal)',
                      prefixIcon: const Icon(
                          Icons.local_fire_department,
                          color: _naranja),
                      suffixIcon: _calCtrl.text.isNotEmpty
                          ? const Icon(Icons.check_circle_rounded,
                              color: Colors.green, size: 20)
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
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // ── Botón agregar ────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _agregarComida();
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
                  child: const Text('Agregar',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
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
    const int metaCalorias = 2000;
    final double pct = (_totalCalorias / metaCalorias).clamp(0.0, 1.0);
    final bool superada = _totalCalorias > metaCalorias;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarFormulario,
        backgroundColor: _naranja,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add),
        label: const Text('Agregar',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────────────
            const Text('Registro de comidas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Lleva el control de lo que comes hoy',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            const SizedBox(height: 24),

            // ── Tarjeta calorías totales ─────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: superada
                      ? [Colors.red.shade400, Colors.red.shade600]
                      : [_naranja, const Color(0xFFD4782A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: (superada ? Colors.red : _naranja).withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          superada ? 'Meta superada' : 'Calorías consumidas',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$_totalCalorias',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text('kcal',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Meta: $metaCalorias kcal',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(72, 72),
                          painter: _RingPainter(
                            progress: pct,
                            color: Colors.white,
                            strokeWidth: 7,
                          ),
                        ),
                        Text(
                          '${(pct * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Barra de progreso ────────────────────────────
            Row(
              children: [
                Text(
                  '${_comidas.length} comida${_comidas.length == 1 ? '' : 's'} registrada${_comidas.length == 1 ? '' : 's'}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  'Restan ${(metaCalorias - _totalCalorias).abs()} kcal'
                  '${superada ? ' de más' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: superada ? Colors.red.shade400 : _naranja,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.grey.shade100,
                color: superada ? Colors.red.shade400 : _naranja,
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 24),

            // ── Lista de comidas ─────────────────────────────
            if (_comidas.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_menu,
                          size: 52, color: Colors.grey.shade200),
                      const SizedBox(height: 12),
                      Text('Aún no has registrado comidas',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Toca "Agregar" para empezar',
                          style: TextStyle(
                              color: Colors.grey.shade300, fontSize: 12)),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(_comidas.length, (i) {
                final c = _comidas[i];
                return _ComidaItem(
                  comida: c,
                  isLast: i == _comidas.length - 1,
                  onEliminar: () => _eliminarComida(i),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ── Item de comida ───────────────────────────────────────────
class _ComidaItem extends StatelessWidget {
  final Comida comida;
  final bool isLast;
  final VoidCallback onEliminar;

  static const Color _naranja = Color(0xFFE8943A);

  const _ComidaItem({
    required this.comida,
    required this.isLast,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
      ),
      onDismissed: (_) => onEliminar(),
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _naranja.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _naranja.withOpacity(0.2)),
              ),
              child: Icon(comida.icono, size: 22, color: _naranja),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comida.nombre,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D))),
                  const SizedBox(height: 2),
                  Text('Desliza para eliminar',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _naranja.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department, size: 14, color: _naranja),
                  const SizedBox(width: 4),
                  Text(
                    '${comida.calorias} kcal',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _naranja,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text('Eliminar comida',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                    content: Text(
                        '¿Quieres eliminar "${comida.nombre}" del registro?',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600)),
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
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.delete_outline_rounded,
                    size: 17, color: Colors.red.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

    canvas.drawArc(
      rect, -1.5708, 6.2832, false,
      Paint()
        ..color = color.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      canvas.drawArc(
        rect, -1.5708, 6.2832 * progress, false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) {
    return old.progress != progress || old.color != color;
  }
}











// ════════════════════════════════════════════════════════════
//  Retos Section - Con Iconos
// ════════════════════════════════════════════════════════════
class _TabRetos extends StatelessWidget {
  final AppState appState;
  final Map<String, IconData> iconos;
  final Map<String, int> pts;
  const _TabRetos({required this.appState, required this.iconos, required this.pts});
  
  static const Color _verdeClaro = Color(0xFF7BC47F);
  
  @override
  Widget build(BuildContext context) {
    final completados = appState.retos.values.where((v) => v).length;
    final total = appState.retos.length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Retos de hoy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Completa para ganar puntos', style: TextStyle(fontSize: 13, color: Color(0xFF4A5568))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _verdeClaro.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 18, color: _verdeClaro),
                    const SizedBox(width: 6),
                    Text('$completados/$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _verdeClaro)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completados / total,
              backgroundColor: Colors.grey.shade200,
              color: _verdeClaro,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemCount: appState.retos.length,
            itemBuilder: (_, i) {
              final key = appState.retos.keys.elementAt(i);
              final val = appState.retos[key]!;
              return _RetoCard(
                key: ValueKey(key),
                icono: iconos[key] ?? Icons.flag,
                label: key,
                puntos: pts[key] ?? 0,
                completado: val,
                onTap: () {
                  HapticFeedback.lightImpact();
                  appState.toggleReto(key);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          const _TipDelDia(),
        ],
      ),
    );
  }
}

class _RetoCard extends StatelessWidget {
  final IconData icono;
  final String label;
  final int puntos;
  final bool completado;
  final VoidCallback onTap;
  
  const _RetoCard({
    super.key,
    required this.icono, 
    required this.label, 
    required this.puntos, 
    required this.completado, 
    required this.onTap
  });
  
  static const Color _verde = Color(0xFF7BC47F);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: completado
              ? LinearGradient(
                  colors: [_verde, _verde.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: completado ? null : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: completado ? _verde.withOpacity(0.3) : Colors.black.withOpacity(0.06),
              blurRadius: completado ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: completado ? null : Border.all(color: Colors.grey.shade100, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icono, size: 36, color: completado ? Colors.white : _verde),
                if (completado)
                  const Icon(Icons.check_circle, color: Colors.white, size: 24),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: completado ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: completado ? Colors.white24 : _verde.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '+$puntos pts',
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

// ════════════════════════════════════════════════════════════
//  Tip del Día
// ════════════════════════════════════════════════════════════
class _TipDelDia extends StatelessWidget {
  const _TipDelDia();
  
  static const List<String> _tips = [
    '💧 Beber agua antes de cada comida ayuda a comer con más consciencia y reduce el apetito.',
    '🍎 Una manzana al día aporta fibra y vitaminas esenciales para tu sistema inmune.',
    '🌅 Desayunar activa tu metabolismo y mejora tu concentración durante toda la mañana.',
    '🍬 Reducir el azúcar añadido mejora tu energía estable y previene picos de glucosa.',
    '🍽️ Comer despacio permite registrar la saciedad a tiempo y evitar el sobrepeso.',
  ];
  
  static const Color _verde = Color(0xFF4A9B6E);
  static const Color _verdeClaro = Color(0xFF7BC47F);
  
  @override
  Widget build(BuildContext context) {
    final tip = _tips[DateTime.now().day % _tips.length];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_verde.withOpacity(0.05), _verdeClaro.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _verde.withOpacity(0.15), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_verde, _verdeClaro]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lightbulb, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_verde, _verdeClaro]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'TIP DEL DÍA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _verde,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tip,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D3748),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}