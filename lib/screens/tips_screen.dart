import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  TipsScreen({super.key});

  static const Color _verde = Color(0xFF4A8C3F);

  final List<Map<String, dynamic>> _tips = [
    {
      'emoji': '🍳',
      'titulo': 'Nunca te saltes el desayuno',
      'desc': 'Activa tu metabolismo y mejora tu energía.',
      'color': Color(0xFFFFF3E0),
    },
    {
      'emoji': '💧',
      'titulo': 'Hidratación',
      'desc': 'Toma al menos 8 vasos de agua al día.',
      'color': Color(0xFFE3F2FD),
    },
    {
      'emoji': '🥦',
      'titulo': 'Come verduras',
      'desc': 'Aportan vitaminas esenciales.',
      'color': Color(0xFFE8F5E9),
    },
    {
      'emoji': '🚫',
      'titulo': 'Menos ultraprocesados',
      'desc': 'Reduce gaseosas y snacks.',
      'color': Color(0xFFFFEBEE),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: _verde,
        title: const Text('Tips',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _tips.length,
        itemBuilder: (context, i) {
          final tip = _tips[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tip['color'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(tip['emoji'],
                    style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['titulo'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(tip['desc']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}