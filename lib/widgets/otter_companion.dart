import 'package:flutter/material.dart';

enum OtterPose { welcoming, thinking, celebrating, reflecting }

/// A small, code-drawn learning companion that remains sharp on every screen.
class OtterCompanion extends StatelessWidget {
  const OtterCompanion({
    super.key,
    required this.pose,
    this.size = 112,
  });

  final OtterPose pose;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String poseName = pose.name;
    return Semantics(
      label: '學習小水獺：$poseName',
      image: true,
      child: SizedBox(
        key: ValueKey<String>('otter_companion_$poseName'),
        width: size,
        height: size,
        child: CustomPaint(painter: _OtterPainter(pose)),
      ),
    );
  }
}

class _OtterPainter extends CustomPainter {
  const _OtterPainter(this.pose);

  final OtterPose pose;

  static const Color _fur = Color(0xFF9A654D);
  static const Color _muzzle = Color(0xFFF5DDC6);
  static const Color _ink = Color(0xFF392A2A);
  static const Color _coral = Color(0xFFFFA87D);
  static const Color _yellow = Color(0xFFFFD36E);

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.shortestSide;
    final Offset center = Offset(size.width / 2, s * .54);
    final Paint fur = Paint()..color = _fur;
    final Paint muzzle = Paint()..color = _muzzle;
    final Paint ink = Paint()..color = _ink;

    canvas.drawCircle(center, s * .35, fur);
    canvas.drawCircle(Offset(center.dx - s * .25, s * .24), s * .105, fur);
    canvas.drawCircle(Offset(center.dx + s * .25, s * .24), s * .105, fur);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx, s * .63), width: s * .44, height: s * .30),
      muzzle,
    );
    canvas.drawCircle(Offset(center.dx - s * .13, s * .49), s * .034, ink);
    canvas.drawCircle(Offset(center.dx + s * .13, s * .49), s * .034, ink);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx, s * .60), width: s * .09, height: s * .06),
      ink,
    );
    final Paint smile = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * .018
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(center.dx, s * .65), width: s * .17, height: s * .10),
      0,
      3.14,
      false,
      smile,
    );

    if (pose == OtterPose.thinking) {
      canvas.drawCircle(Offset(center.dx + s * .30, s * .16), s * .07,
          Paint()..color = _yellow);
      canvas.drawCircle(Offset(center.dx + s * .39, s * .08), s * .035,
          Paint()..color = _yellow);
    }
    if (pose == OtterPose.celebrating) {
      _sparkle(canvas, Offset(s * .17, s * .18), s, _yellow);
      _sparkle(canvas, Offset(s * .82, s * .26), s, _coral);
    }
    if (pose == OtterPose.reflecting) {
      final Paint book = Paint()..color = const Color(0xFF7FA5D6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(center.dx, s * .88),
              width: s * .54,
              height: s * .20),
          Radius.circular(s * .035),
        ),
        book,
      );
      canvas.drawLine(
          Offset(center.dx, s * .80),
          Offset(center.dx, s * .96),
          Paint()
            ..color = Colors.white.withValues(alpha: .8)
            ..strokeWidth = s * .012);
    }
    final double pawY = pose == OtterPose.celebrating ? s * .28 : s * .76;
    canvas.drawCircle(Offset(center.dx - s * .30, pawY), s * .105, fur);
    canvas.drawCircle(Offset(center.dx + s * .30, pawY), s * .105, fur);
  }

  void _sparkle(Canvas canvas, Offset center, double s, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = s * .025
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(center.dx - s * .06, center.dy),
        Offset(center.dx + s * .06, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - s * .06),
        Offset(center.dx, center.dy + s * .06), paint);
  }

  @override
  bool shouldRepaint(covariant _OtterPainter oldDelegate) =>
      oldDelegate.pose != pose;
}
