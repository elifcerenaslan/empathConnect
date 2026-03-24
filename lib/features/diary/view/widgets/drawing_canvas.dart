import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset> _points = [];
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isDrawing = true;
              _points.add(details.localPosition);
            });
          },
          onPanUpdate: (details) {
            if (_isDrawing) {
              setState(() {
                _points.add(details.localPosition);
              });
            }
          },
          onPanEnd: (details) {
            setState(() {
              _isDrawing = false;
            });
          },
          child: CustomPaint(
            painter: DrawingPainter(_points),
            child: Container(),
          ),
        ),
      ),
    );
  }

  void clearCanvas() {
    setState(() {
      _points.clear();
    });
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
