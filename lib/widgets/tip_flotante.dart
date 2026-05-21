import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TipFlotante extends StatefulWidget {
  const TipFlotante({super.key});

  @override
  State<TipFlotante> createState() => _TipFlotanteState();
}

class _TipFlotanteState extends State<TipFlotante>
    with TickerProviderStateMixin {
  final _random = Random();

  final List<String> _tips = [
    'Toma agua antes de cada comida',
    'Consume fruta todos los días',
    'Incluye verduras en tu almuerzo',
    'Camina 10 minutos después de comer',
    'Dormir bien ayuda a controlar el apetito',
    'Prefiere snacks naturales',
    'Mastica lentamente',
    'Reduce bebidas azucaradas',
  ];

  late String _tipActual;
  bool _bubbleVisible = false;
  bool _dotVisible = false;

  Timer? _rotationTimer;
  Timer? _autoCloseTimer;
  Timer? _dotTimer;

  late AnimationController _bubbleController;
  late Animation<double> _bubbleScale;
  late Animation<double> _bubbleOpacity;

  late AnimationController _dotController;
  late Animation<double> _dotPulse;

  late AnimationController _btnController;
  late Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _tipActual = _tips[_random.nextInt(_tips.length)];

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _bubbleScale = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
    _bubbleOpacity = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _dotPulse = Tween<double>(begin: 0.6, end: 1.4).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeInOut),
    );

    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _btnScale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeIn),
    );

    _rotationTimer = Timer.periodic(
      const Duration(seconds:60),
      (_) => _mostrarNuevoTip(),
    );
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    _autoCloseTimer?.cancel();
    _dotTimer?.cancel();
    _bubbleController.dispose();
    _dotController.dispose();
    _btnController.dispose();
    super.dispose();
  }

  void _mostrarNuevoTip() {
    setState(() {
      _tipActual = _tips[_random.nextInt(_tips.length)];
      _dotVisible = true;
    });
    _abrirBubble(autoCierre: const Duration(seconds: 4));

    _dotTimer?.cancel();
    _dotTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) setState(() => _dotVisible = false);
    });
  }

  void _abrirBubble({Duration? autoCierre}) {
    _autoCloseTimer?.cancel();
    setState(() => _bubbleVisible = true);
    _bubbleController.forward();

    if (autoCierre != null) {
      _autoCloseTimer = Timer(autoCierre, _cerrarBubble);
    }
  }

  void _cerrarBubble() {
    _bubbleController.reverse().then((_) {
      if (mounted) setState(() => _bubbleVisible = false);
    });
  }

  void _onTapBtn() async {
    await _btnController.forward();
    _btnController.reverse();

    if (_bubbleVisible) {
      _autoCloseTimer?.cancel();
      setState(() {
        _tipActual = _tips[_random.nextInt(_tips.length)];
        _dotVisible = false;
      });
      _bubbleController.reverse().then((_) {
        if (mounted) _abrirBubble(autoCierre: const Duration(seconds: 5));
      });
    } else {
      setState(() => _dotVisible = false);
      _abrirBubble(autoCierre: const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_bubbleVisible)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ScaleTransition(
                scale: _bubbleScale,
                alignment: Alignment.bottomRight,
                child: FadeTransition(
                  opacity: _bubbleOpacity,
                  child: _TipBubble(tip: _tipActual),
                ),
              ),
            ),
          GestureDetector(
            onTap: _onTapBtn,
            child: ScaleTransition(
              scale: _btnScale,
              child: _BtnTip(dotVisible: _dotVisible, dotPulse: _dotPulse),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipBubble extends StatelessWidget {
  final String tip;
  const _TipBubble({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF14281C).withOpacity(0.97),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(4),
        ),
        border: Border.all(
          color: const Color(0xFF3D8F65).withOpacity(0.45),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D8F65).withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CONSEJO',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4AA876).withOpacity(0.85),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            tip,
            style: const TextStyle(
              color: Color(0xFFD8EDE2),
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _BtnTip extends StatelessWidget {
  final bool dotVisible;
  final Animation<double> dotPulse;

  const _BtnTip({required this.dotVisible, required this.dotPulse});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF3D8F65),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3D8F65).withOpacity(0.40),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.tips_and_updates_outlined,
            color: Colors.white,
            size: 21,
          ),
        ),
        if (dotVisible)
          Positioned(
            top: -1,
            right: -1,
            child: ScaleTransition(
              scale: dotPulse,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0xFF7FEFB2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}