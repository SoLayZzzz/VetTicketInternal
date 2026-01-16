import 'package:flutter/material.dart';

class DimmedOverlayWithHole extends CustomPainter {
  final Rect hole;

  DimmedOverlayWithHole({required this.hole});

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final inner = Path()..addRect(hole);
    final combined = Path.combine(PathOperation.difference, outer, inner);

    canvas.drawPath(
      combined,
      Paint()..color = Colors.black.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ScanBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;

    // Corners
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(cornerLength, size.height), paint);

    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ScanAreaClipper extends CustomClipper<Rect> {
  final Offset center;
  final Size size;

  ScanAreaClipper({required this.center, required this.size});

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
        center: center, width: this.size.width, height: this.size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}

class InvertedClipper extends CustomClipper<Path> {
  final Rect holeRect;

  InvertedClipper({required this.holeRect});

  @override
  Path getClip(Size size) {
    final fullRect = Offset.zero & size;
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(fullRect),
      Path()..addRect(holeRect),
    );
  }

  @override
  bool shouldReclip(InvertedClipper oldClipper) =>
      holeRect != oldClipper.holeRect;
}
