import 'dart:ui';
import 'package:flutter/material.dart';

class GlossyCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double opacity;
  final VoidCallback? onTap;

  const GlossyCard({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.opacity = 0.1,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color glassColor = isDark ? Colors.white : Colors.white; 
    Color borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: glassColor.withOpacity(isDark ? opacity : 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}