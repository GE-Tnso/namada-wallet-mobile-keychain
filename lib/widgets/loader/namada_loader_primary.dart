import 'package:flutter/material.dart';

class NamadaLoaderPrimary extends StatelessWidget {
  final double size;

  const NamadaLoaderPrimary({Key? key, this.size = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/namada_logo_yellow_animated.gif',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
