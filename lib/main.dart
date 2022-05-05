import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => const HomeScreen(),
        "/canvas1": (_) => const Canvas1(),
        "/canvas2": (_) => const Canvas2(),
        "/canvas3": (_) => const Canvas3(),
        "/canvas4": (_) => const Canvas4(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas Playground'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).pushNamed('/canvas1');
                }),
                child: const Text("Canvas 1")),
            ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).pushNamed('/canvas2');
                }),
                child: const Text("Canvas 2")),
            ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).pushNamed('/canvas3');
                }),
                child: const Text("Canvas 3")),
            ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).pushNamed('/canvas4');
                }),
                child: const Text("Canvas 4")),
          ],
        ),
      ),
    );
  }
}

class Canvas1 extends StatelessWidget {
  const Canvas1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas 1'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          const Align(alignment: Alignment.bottomCenter, child: BottomBar()),
        ],
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  final _radious = 25.0;
  final _padding = 16.0;
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final beginPosition = widget._radious + widget._padding;
        final endPosition = MediaQuery.of(context).size.width - widget._padding - beginPosition;
        final xPosition = beginPosition + (endPosition - beginPosition) * _animationController.value;
        return CustomPaint(
          painter: BottomBarCustomPainter(xPosition: xPosition, radious: widget._radious),
          size: Size(MediaQuery.of(context).size.width, 56),
        );
      },
    );
  }
}

class BottomBarCustomPainter extends CustomPainter {
  final double xPosition;
  final double radious;

  BottomBarCustomPainter({required this.xPosition, required this.radious});

  final _path = Path();
  final _customPaint = Paint()
    ..isAntiAlias = true
    ..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    generatePath(size);
    canvas.drawPath(_path, _customPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void generatePath(Size size) {
    _path.moveTo(0, 0);
    final initialX = xPosition;
    _path.lineTo(initialX - radious, 0);
    _path.cubicTo(initialX - radious, radious * 0.55, initialX - radious * 0.55, radious, initialX, radious);
    _path.cubicTo(initialX + radious * 0.55, radious, initialX + radious, radious * 0.55, initialX + radious, 0);
    _path.lineTo(size.width, 0);
    _path.lineTo(size.width, size.height);
    _path.lineTo(0, size.height);
    _path.close();
  }
}

class Canvas2 extends StatelessWidget {
  const Canvas2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas 2'),
      ),
      body: const Center(
          child: SizedBox(
        width: 120,
        height: 48,
        child: CutCornerWidget(
          cutCornerRadius: 8,
        ),
      )),
    );
  }
}

class CutCornerWidget extends StatefulWidget {
  final int cutCornerRadius;

  const CutCornerWidget({Key? key, required this.cutCornerRadius}) : super(key: key);
  @override
  _CutCornerWidgetState createState() => _CutCornerWidgetState();
}

class _CutCornerWidgetState extends State<CutCornerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    //_controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double cutCornerRadius = (1 - _controller.value) * widget.cutCornerRadius;
          return GestureDetector(
            onTap: () => _controller.forward(),
            child: CustomPaint(
              painter: CutCornerCustomPainter(cutCornerRadius),
            ),
          );
        });
  }
}

class CutCornerCustomPainter extends CustomPainter {
  final double cutCornerRadius;
  final Paint cutCornerPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xFFFEDBD0);
  final Path path = Path();

  CutCornerCustomPainter(this.cutCornerRadius);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    path.moveTo(cutCornerRadius.toDouble(), 0);
    path.lineTo(size.width - cutCornerRadius, 0);
    path.lineTo(size.width, cutCornerRadius.toDouble());
    path.lineTo(size.width, size.height - cutCornerRadius);
    path.lineTo(size.width - cutCornerRadius.toDouble(), size.height);
    path.lineTo(cutCornerRadius.toDouble(), size.height);
    path.lineTo(0, size.height - cutCornerRadius.toDouble());
    path.lineTo(0, cutCornerRadius.toDouble());
    path.close();
    canvas.drawPath(path, cutCornerPaint);
  }
}

class Canvas3 extends StatelessWidget {
  const Canvas3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas 3'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          const Align(alignment: Alignment.bottomCenter, child: BottomBar2()),
        ],
      ),
    );
  }
}

class BottomBar2 extends StatefulWidget {
  final _radious = 30.0;
  const BottomBar2({Key? key}) : super(key: key);

  @override
  _BottomBarState2 createState() => _BottomBarState2();
}

class _BottomBarState2 extends State<BottomBar2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final beginPosition = widget._radious;
        final endPosition = 0.0;
        final currentRadius = beginPosition + (endPosition - beginPosition) * _animationController.value;
        return GestureDetector(
          child: CustomPaint(
            painter: BottomBarCustomPainter2(xPosition: MediaQuery.of(context).size.width / 2, radious: currentRadius),
            size: Size(MediaQuery.of(context).size.width, 56),
          ),
          onTap: () {
            _animationController.forward();
          },
        );
      },
    );
  }
}

class BottomBarCustomPainter2 extends CustomPainter {
  final double xPosition;
  final double radious;

  BottomBarCustomPainter2({required this.xPosition, required this.radious});

  final _path = Path();
  final _customPaint = Paint()
    ..isAntiAlias = true
    ..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    generatePath(size);
    canvas.drawPath(_path, _customPaint);
    canvas.drawCircle(Offset(size.width / 2, 0), radious - 5, _customPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void generatePath(Size size) {
    _path.moveTo(0, 0);
    final initialX = xPosition;
    _path.lineTo(initialX - radious, 0);
    _path.cubicTo(initialX - radious, radious * 0.55, initialX - radious * 0.55, radious, initialX, radious);
    _path.cubicTo(initialX + radious * 0.55, radious, initialX + radious, radious * 0.55, initialX + radious, 0);
    _path.lineTo(size.width, 0);
    _path.lineTo(size.width, size.height);
    _path.lineTo(0, size.height);
    _path.close();
  }
}

class Canvas4 extends StatelessWidget {
  const Canvas4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas 4'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          const Center(
            child: Ticket(),
          )
        ],
      ),
    );
  }
}

class Ticket extends StatefulWidget {
  const Ticket({Key? key}) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TicketPainter(),
      size: MediaQuery.of(context).size,
    );
  }
}

class TicketPainter extends CustomPainter {
  final _paint = Paint()..color = Colors.white;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()
            ..addRRect(RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(size.width / 2, size.height / 2), width: size.width - 40, height: size.height - 80),
                const Radius.circular(10.0))),
          Path()
            ..addOval(Rect.fromCircle(center: Offset(20, size.height - 150), radius: 20))
            ..addOval(Rect.fromCircle(center: Offset(size.width - 20, size.height - 150), radius: 20)),
        ),
        _paint);
    canvas.drawPath(
        generateDashedPath(size),
        Paint()
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..color = Colors.grey);
  }

  Path generateDashedPath(Size size) {
    final path = Path()
      ..moveTo(50, size.height - 150)
      ..lineTo(size.width - 50, size.height - 150);
    final dashWidth = 10.0;
    final gapWidth = 5.0;
    double distance = 0.0;
    Path dashPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += (dashWidth + gapWidth);
      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate.hashCode == hashCode;
  }
}
