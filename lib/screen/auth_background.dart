
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _AuthBackgroundPainter(),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _AuthBackgroundPainter extends CustomPainter {
  const _AuthBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final lightBlue = Paint()
      ..color = const Color(0xFFB9D8FF).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    final mediumBlue = Paint()
      ..color = const Color(0xFF76B2FF).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final strongBlue = Paint()
      ..color = const Color(0xFF3989E8).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    // Gelombang di pojok kiri atas
    final topWave1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.58, 0)
      ..cubicTo(
        size.width * 0.40, 25,
        size.width * 0.30, 65,
        0, 100,
      )
      ..close();

    final topWave2 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.40, 0)
      ..cubicTo(
        size.width * 0.28, 30,
        size.width * 0.20, 45,
        0, 68,
      )
      ..close();

    canvas.drawPath(topWave1, lightBlue);
    canvas.drawPath(topWave2, mediumBlue);

    // Gelombang di pojok kanan bawah
    final bottomWave1 = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.42, size.height)
      ..cubicTo(
        size.width * 0.60, size.height - 25,
        size.width * 0.75, size.height - 55,
        size.width, size.height - 95,
      )
      ..close();

    final bottomWave2 = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.65, size.height)
      ..cubicTo(
        size.width * 0.80, size.height - 20,
        size.width * 0.90, size.height - 38,
        size.width, size.height - 58,
      )
      ..close();

    canvas.drawPath(bottomWave1, lightBlue);
    canvas.drawPath(bottomWave2, mediumBlue);

    // Kotak-kotak kecil di pojok atas
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 62, 35, 13, 13),
        const Radius.circular(3),
      ),
      strongBlue,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 39, 22, 10, 10),
        const Radius.circular(3),
      ),
      mediumBlue,
    );

    // Kotak-kotak kecil di pojok bawah
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 62, size.height - 70, 12, 12),
        const Radius.circular(3),
      ),
      mediumBlue,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 42, size.height - 48, 10, 10),
        const Radius.circular(3),
      ),
      strongBlue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
