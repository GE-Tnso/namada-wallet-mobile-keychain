import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// A widget that wraps the SeedWordsWidget and toggles blur on tap,
/// with a centered overlay text ("Tap to see") when blurred.

class AnimatedDotsOverlay extends StatefulWidget {
  const AnimatedDotsOverlay({Key? key}) : super(key: key);

  @override
  _AnimatedDotsOverlayState createState() => _AnimatedDotsOverlayState();
}

class _AnimatedDotsOverlayState extends State<AnimatedDotsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // animatedBuilder rebuilds every frame to update the dot pattern.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DotPatternPainter(animationValue: _controller.value),
          child: Container(), // expand to cover the parent.
        );
      },
    );
  }
}

/// A CustomPainter that draws animated dots.
class DotPatternPainter extends CustomPainter {
  final double animationValue;

  DotPatternPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Color(0xFF03FFFF).withOpacity(0.4);
    final double spacing = 10.0; // Spacing between dots.
    final double radius = 2.0; // Dot radius.

    for (double x = -spacing; x <= size.width + spacing; x += spacing) {
      for (double y = -spacing; y <= size.height + spacing; y += spacing) {
        // compute an offset for each dot using sine and cosine for gentle oscillation.
        double dx = 4.0 * sin((animationValue * 2 * pi) + (x / 5.0));
        double dy = 4.0 * cos((animationValue * 2 * pi) + (y / 5.0));

        final Offset offset = Offset(x + dx, y + dy);
        canvas.drawCircle(offset, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotPatternPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// This widget wraps your grid of seed words and toggles a blur effect.
/// When blurred, it shows the animated dots overlay and center text.
class TappableSeedWordsWidget extends StatefulWidget {
  final List<String> seedWords;

  const TappableSeedWordsWidget({Key? key, required this.seedWords})
      : super(key: key);

  @override
  _TappableSeedWordsWidgetState createState() =>
      _TappableSeedWordsWidgetState();
}

class _TappableSeedWordsWidgetState extends State<TappableSeedWordsWidget> {
  bool isSeedHidden = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // toggle the blurred/unblurred state on tap.
        setState(() {
          isSeedHidden = !isSeedHidden;
        });
      },
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animate the blur effect.
            TweenAnimationBuilder<double>(
              tween: Tween<double>(end: isSeedHidden ? 30.0 : 0.0),
              duration: const Duration(milliseconds: 0),
              builder: (context, sigma, child) {
                return ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: child,
                );
              },
              child: SeedWordsWidget(seedWords: widget.seedWords),
            ),
            // when blurred, overlay the animated dots and center text.
            if (isSeedHidden) ...[
              const AnimatedDotsOverlay(),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Tap to see your seed phrase",
                  style: TextStyle(
                    color: Color(0xFFFFFF00),
                    fontSize: 20,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that displays seed words in a grid with colored index numbers.
class SeedWordsWidget extends StatelessWidget {
  final List<String> seedWords;

  const SeedWordsWidget({
    Key? key,
    required this.seedWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // Let the grid size itself
      shrinkWrap: true,
      itemCount: seedWords.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        crossAxisSpacing: 8.0, // space between columns
        mainAxisSpacing: 8.0, // space between rows
        childAspectRatio: 3.5, // each tile is wide and short
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${index + 1}. ',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Seed word in white.
                TextSpan(
                  text: seedWords[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
