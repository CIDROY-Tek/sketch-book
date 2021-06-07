import 'dart:math' as math;
import 'dart:ui' as dartUI;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SketchPage(),
    );
  }
}

// POC success, complete painting working
class SketchPage extends StatefulWidget {
  const SketchPage({Key? key}) : super(key: key);

  @override
  _SketchPageState createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final List<Offset> points = [];
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sketch Book"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  points.clear();
                });
              },
              icon: Icon(Icons.replay_rounded))
        ],
      ),
      body: Column(
        children: [
          /// Sketch area
          SizedBox(
            width: 300,
            height: 300,
            child: ClipRect(
              child: SketchArea(
                points: points,
              ),
            ),
          ),

          /// textfield
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.black)),
            child: EditableText(
                controller: _textEditingController,
                focusNode: _focusNode,
                style: TextStyle(fontSize: 12, color: Colors.black),
                cursorColor: Colors.black87,
                backgroundCursorColor: Colors.amber),
          ),
        ],
      ),
    );
  }
}

class SketchArea extends StatefulWidget {
  final List<Offset> points;
  const SketchArea({Key? key, required this.points}) : super(key: key);

  @override
  _SketchAreaState createState() => _SketchAreaState();
}

class _SketchAreaState extends State<SketchArea> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        setState(() {
          widget.points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanUpdate: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        setState(() {
          widget.points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (DragEndDetails details) {
        widget.points.add(Offset.infinite);
      },
      child: CustomPaint(
        foregroundPainter: Painter(points: widget.points, radian: math.pi),
        child: Container(
          color: Colors.blue[50],
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  final double radian;
  final List<Offset> points;

  Painter({required this.points, required this.radian});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // print("Points are ========> $points");
    // dartUI.ParagraphBuilder paragraphBuilder =
    //     dartUI.ParagraphBuilder(dartUI.ParagraphStyle(fontSize: 24))
    //       ..pushStyle(dartUI.TextStyle(color: Colors.black))
    //       ..addText("text");
    // dartUI.Paragraph paragraph = paragraphBuilder.build();
    // canvas.drawParagraph(paragraph, Offset(size.width / 2, size.height / 2));

    // final textStyle = TextStyle(
    //   color: Colors.black,
    //   fontSize: 30,
    // );
    // final textSpan = TextSpan(
    //   text: 'Hello, world.',
    //   style: textStyle,
    // );
    // final textPainter = TextPainter(
    //   text: textSpan,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout(
    //   minWidth: 0,
    //   maxWidth: size.width,
    // );
    // textPainter.paint(canvas, Offset(0, size.height / 2));

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
