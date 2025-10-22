import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardModel {
  final String label; // Transparent | Shielded
  final Color colorA;
  final Color colorB;
  final IconData icon;

  const CardModel({
    required this.label,
    required this.colorA,
    required this.colorB,
    required this.icon,
  });
}

class NamadaCard extends StatefulWidget {
  const NamadaCard({required this.model, required this.active, Key? key})
    : super(key: key);

  final CardModel model;
  final bool active;

  @override
  State<NamadaCard> createState() => _NamadaCardState();
}

class _NamadaCardState extends State<NamadaCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.active) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant NamadaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.active && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShielded = widget.model.label == 'Shielded';

    final borderColor = isShielded
        ? Colors.black.withOpacity(0.15)
        : Colors.white.withOpacity(0.10);
    final titleColor = isShielded ? Colors.black : Colors.white;
    final iconColor = isShielded ? Colors.black87 : Colors.white;

    final cardCore = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.model.colorA, widget.model.colorB],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.model.icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.model.label,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Shield your assets to \nearn shielded set rewards.',
                style: TextStyle(
                  color: titleColor.withOpacity(0.92),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );

    final outerGlowColor = isShielded
        ? const Color(0xFFFF8F00)
        : Colors.white.withOpacity(0.85);
    final midGlowColor = isShielded ? const Color(0xFFFFC107) : Colors.white;

    Widget withAnimatedBorder(Widget child) {
      return AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = _ctrl.value; // 0..1
          final angle = t * 2 * pi;
          final pulse = (sin(angle * 1.5) + 1) / 2;

          final innerStrokeColor = Color.lerp(
            isShielded ? const Color(0xFFFFA000) : Colors.white54,
            isShielded ? const Color(0xFFFFD54F) : Colors.white,
            pulse,
          )!;

          final ringPadding = isShielded ? 3.4 : 2.2;

          return Container(
            padding: EdgeInsets.all(ringPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: SweepGradient(
                startAngle: 0,
                endAngle: 2 * pi,
                transform: GradientRotation(angle),
                colors: [
                  outerGlowColor.withOpacity(0.06),
                  midGlowColor.withOpacity(isShielded ? 0.65 : 0.35),
                  outerGlowColor.withOpacity(0.06),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: midGlowColor.withOpacity(isShielded ? 0.28 : 0.14),
                  blurRadius: isShielded ? 24 : 18,
                  spreadRadius: isShielded ? 2 : 1,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: innerStrokeColor.withOpacity(isShielded ? 0.75 : 0.55),
                  width: isShielded ? 1.6 : 1.2,
                ),
              ),
              child: child,
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: widget.active ? withAnimatedBorder(cardCore) : cardCore,
    );
  }
}

class Dots extends StatelessWidget {
  const Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.white.withOpacity(0.95);
    final base = Colors.white.withOpacity(0.25);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          height: 6,
          width: isActive ? 22 : 6,
          decoration: BoxDecoration(
            color: isActive ? activeColor : base,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
