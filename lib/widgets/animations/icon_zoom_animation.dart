import 'package:flutter/material.dart';

/// Asset animation: .png, .jpg, .jpeg
class IconZoomAnimation extends StatefulWidget {
  const IconZoomAnimation({Key? key}) : super(key: key);

  @override
  _IconZoomAnimationState createState() => _IconZoomAnimationState();
}

class _IconZoomAnimationState extends State<IconZoomAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(
      begin: Color(0xFFFFFF00),
      end: Color(0xFF03FFFF),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Image.asset(
            'assets/images/namada_comb_rgb_white.png',
            fit: BoxFit.cover,
            color: _colorAnimation.value,
            colorBlendMode: BlendMode.modulate,
          ),
        );
      },
    );
  }
}
