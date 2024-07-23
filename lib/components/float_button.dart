import 'package:flutter/material.dart';

class FloatButton extends StatelessWidget {
  final String text;
  final Color color;
  final Object heroTag;
  final VoidCallback onPressed;
  final IconData icon;

  const FloatButton({
    super.key,
    required this.text,
    required this.color,
    required this.heroTag,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      heroTag: heroTag,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon color set to white
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}
