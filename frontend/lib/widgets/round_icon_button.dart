import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RoundIconButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Color(0xFF7A5AF8),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: const FaIcon(
        FontAwesomeIcons.angleDoubleRight,
        color: Colors.white,
      ),
    );
  }
}
