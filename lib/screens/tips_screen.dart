import 'package:flutter/material.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> with SingleTickerProviderStateMixin {
  static const Color _verde = Color(0xFF4A9B6E);
  static const Color _verdeOscuro = Color(0xFF4A9B6E);
  static const Color _verdeClaro = Color(0xFF7BC47F);
  static const Color _fondo = Color(0xFFFFF8EC);
  
  late AnimationController _animationController;
  int _selectedTipIndex = -1;

  final List<Tip> _tips = [
    Tip(
      icon: Icons.free_breakfast,
      titulo: 'Nunca te saltes el desayuno',
      descripcion: 'Activa tu metabolismo y mejora tu energía durante todo el día. Un desayuno balanceado ayuda a controlar el hambre y mejora la concentración.',
      color: Color(0xFFFFF3E0),
      iconColor: Color(0xFFF59E0B),
      categoria: 'Alimentación',
    ),
    Tip(
      icon: Icons.water_drop,
      titulo: 'Hidratación constante',
      descripcion: 'Toma al menos 8 vasos de agua al día. El agua ayuda a transportar nutrientes, regula la temperatura corporal y elimina toxinas.',
      color: Color(0xFFE3F2FD),
      iconColor: Color(0xFF3B82F6),
      categoria: 'Hidratación',
    ),
    Tip(
      icon: Icons.eco,
      titulo: 'Come verduras diariamente',
      descripcion: 'Aportan vitaminas esenciales, fibra y antioxidantes. Intenta consumir al menos 5 porciones de verduras y frutas al día.',
      color: Color(0xFFE8F5E9),
      iconColor: Color(0xFF10B981),
      categoria: 'Nutrición',
    ),
    Tip(
      icon: Icons.warning_amber,
      titulo: 'Reduce ultraprocesados',
      descripcion: 'Disminuye el consumo de gaseosas, snacks y comidas ultraprocesadas. Opta por alimentos naturales y frescos.',
      color: Color(0xFFFFEBEE),
      iconColor: Color(0xFFEF4444),
      categoria: 'Hábitos',
    ),
    Tip(
      icon: Icons.fitness_center,
      titulo: 'Mantente activo',
      descripcion: 'Realiza al menos 30 minutos de actividad física diaria. Camina, baila, o practica tu deporte favorito.',
      color: Color(0xFFF3E8FF),
      iconColor: Color(0xFF8B5CF6),
      categoria: 'Ejercicio',
    ),
    Tip(
      icon: Icons.bedtime,
      titulo: 'Duerme bien',
      descripcion: 'Descansa entre 7 y 8 horas diarias. El sueño reparador es fundamental para la recuperación física y mental.',
      color: Color(0xFFE0F2FE),
      iconColor: Color(0xFF06B6D4),
      categoria: 'Descanso',
    ),
    Tip(
      icon: Icons.restaurant,
      titulo: 'Come conscientemente',
      descripcion: 'Tómate tu tiempo para comer, mastica bien los alimentos y evita distracciones como el teléfono o la televisión.',
      color: Color(0xFFFEF3C7),
      iconColor: Color(0xFFF59E0B),
      categoria: 'Mindfulness',
    ),
    Tip(
      icon: Icons.emoji_emotions,
      titulo: 'Escucha a tu cuerpo',
      descripcion: 'Aprende a identificar las señales de hambre y saciedad. No comas por ansiedad o aburrimiento.',
      color: Color(0xFFFCE7F3),
      iconColor: Color(0xFFEC4899),
      categoria: 'Bienestar',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        backgroundColor: _verde,
        elevation: 0,
        title: const Text(
          'Tips Saludables',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: _showRandomTip,
            tooltip: 'Tip aleatorio',
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner motivacional
          _buildMotivationalBanner(),
          
          // Contador de tips
          _buildTipsCounter(),
          
          // Lista de tips
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _tips.length,
              itemBuilder: (context, index) {
                return _buildTipCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_verdeClaro.withOpacity(0.1), _verde.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _verdeClaro.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _verdeClaro.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.auto_awesome, color: _verde, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Pequeños cambios, grandes resultados!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aplica estos consejos en tu día a día',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCounter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _verde,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_tips.length} tips',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tips_and_updates, size: 14, color: _verde),
                SizedBox(width: 4),
                Text(
                  'Actualizado diariamente',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(int index) {
    final tip = _tips[index];
    final isSelected = _selectedTipIndex == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: tip.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: tip.iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleTipExpansion(index),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icono animado
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tip.iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: tip.iconColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        tip.icon,
                        color: tip.iconColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    // Contenido principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tip.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              // Categoría
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tip.iconColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tip.categoria,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: tip.iconColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tip.descripcion,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                            maxLines: isSelected ? null : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Acciones
                          Row(
                            children: [
                              _buildActionButton(
                                icon: Icons.share_outlined,
                                label: 'Compartir',
                                color: tip.iconColor,
                                onTap: () => _shareTip(tip),
                              ),
                              const SizedBox(width: 12),
                              _buildActionButton(
                                icon: Icons.favorite_border,
                                label: 'Guardar',
                                color: tip.iconColor,
                                onTap: () => _saveTip(tip),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Indicador de expansión
                    AnimatedRotation(
                      turns: isSelected ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade400,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenido expandido
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedContent(tip),
                crossFadeState: isSelected
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(Tip tip) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 12),
          
          // Beneficios adicionales
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 16, color: tip.iconColor),
              const SizedBox(width: 8),
              Text(
                'Beneficios:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: tip.iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tip.getBeneficios().map((beneficio) => Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.circle, size: 4, color: tip.iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    beneficio,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 12),
          
          // Dato curioso
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tip.iconColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tip.iconColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 16, color: tip.iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip.getDatoCurioso(),
                    style: TextStyle(
                      fontSize: 11,
                      color: tip.iconColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTipExpansion(int index) {
    setState(() {
      if (_selectedTipIndex == index) {
        _selectedTipIndex = -1;
        _animationController.reverse();
      } else {
        _selectedTipIndex = index;
        _animationController.forward();
      }
    });
  }

  void _showRandomTip() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _tips.length;
    setState(() {
      _selectedTipIndex = randomIndex;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ Tip: ${_tips[randomIndex].titulo}'),
        backgroundColor: _verde,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareTip(Tip tip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📤 Compartiendo: ${tip.titulo}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveTip(Tip tip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Text('💾 Tip guardado: ${tip.titulo}'),
          ],
        ),
        backgroundColor: _verde,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class Tip {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final Color color;
  final Color iconColor;
  final String categoria;

  const Tip({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.color,
    required this.iconColor,
    required this.categoria,
  });

  List<String> getBeneficios() {
    switch (categoria) {
      case 'Alimentación':
        return [
          'Mejora el metabolismo',
          'Aumenta la concentración',
          'Reduce la ansiedad por comer',
          'Proporciona energía sostenida',
        ];
      case 'Hidratación':
        return [
          'Mejora la salud de la piel',
          'Aumenta los niveles de energía',
          'Ayuda a la digestión',
          'Previene dolores de cabeza',
        ];
      case 'Nutrición':
        return [
          'Fortalece el sistema inmune',
          'Mejora la digestión',
          'Previene enfermedades crónicas',
          'Aporta vitaminas esenciales',
        ];
      case 'Ejercicio':
        return [
          'Mejora la salud cardiovascular',
          'Fortalece músculos y huesos',
          'Reduce el estrés',
          'Mejora la calidad del sueño',
        ];
      case 'Descanso':
        return [
          'Repara tejidos y músculos',
          'Mejora la memoria',
          'Fortalece el sistema inmune',
          'Regula el apetito',
        ];
      default:
        return [
          'Mejora tu bienestar general',
          'Desarrolla hábitos saludables',
          'Resultados a largo plazo',
          'Aumenta tu calidad de vida',
        ];
    }
  }

  String getDatoCurioso() {
    switch (categoria) {
      case 'Alimentación':
        return '💡 Dato: Desayunar aumenta tu metabolismo hasta un 10% durante todo el día.';
      case 'Hidratación':
        return '💡 Dato: La sed ya es un signo de deshidratación. ¡Bebe agua antes de tener sed!';
      case 'Nutrición':
        return '💡 Dato: Las verduras de hoja verde son las más ricas en nutrientes por caloría.';
      case 'Ejercicio':
        return '💡 Dato: 30 minutos de caminata diaria reducen el riesgo de enfermedades cardiacas.';
      case 'Descanso':
        return '💡 Dato: Dormir bien ayuda a regular las hormonas del hambre y la saciedad.';
      default:
        return '💡 Dato: Los hábitos saludables toman 21 días en promedio para formarse.';
    }
  }
}