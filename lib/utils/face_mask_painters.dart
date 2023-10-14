import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

enum Detector {
  face,
  text,
}

const List<Point<int>> faceMaskConnections = [
  Point(0, 4),
  Point(0, 55),
  Point(4, 7),
  Point(4, 55),
  Point(4, 51),
  Point(7, 11),
  Point(7, 51),
  Point(7, 130),
  Point(51, 55),
  Point(51, 80),
  Point(55, 72),
  Point(72, 76),
  Point(76, 80),
  Point(80, 84),
  Point(84, 72),
  Point(72, 127),
  Point(72, 130),
  Point(130, 127),
  Point(117, 130),
  Point(11, 117),
  Point(11, 15),
  Point(15, 18),
  Point(18, 21),
  Point(21, 121),
  Point(15, 121),
  Point(21, 25),
  Point(25, 125),
  Point(125, 128),
  Point(128, 127),
  Point(128, 29),
  Point(25, 29),
  Point(29, 32),
  Point(32, 0),
  Point(0, 45),
  Point(32, 41),
  Point(41, 29),
  Point(41, 45),
  Point(45, 64),
  Point(45, 32),
  Point(64, 68),
  Point(68, 56),
  Point(56, 60),
  Point(60, 64),
  Point(56, 41),
  Point(64, 128),
  Point(64, 127),
  Point(125, 93),
  Point(93, 117),
  Point(117, 121),
  Point(121, 125),
];

class FaceMask extends CustomPainter {
  // Face painter for AI face mask
  FaceMask(
    this.absoluteImageSize,
    this.faces,
    this.onEyesClosed,
  );

  final Size absoluteImageSize;
  final List<Face> faces;
  final Function onEyesClosed;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.purple;

    final Paint greenPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0
      ..color = Colors.pink;

    bool _shouldShowDialog = false;

    for (final Face face in faces) {
      // Started a loop to detect eye expression
      final contour = face.getContour((FaceContourType.allPoints));
      canvas.drawPoints(
          ui.PointMode.points,
          contour!.positionsList
              .map((offset) => Offset((offset.dx * scaleX), offset.dy * scaleY))
              .toList(),
          paint);
      String expressionText = '';
      if (face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null &&
          face.leftEyeOpenProbability! < 0.4 &&
          face.rightEyeOpenProbability! < 0.4) {
        expressionText = 'Eyes Closed';
      } else if (face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null &&
          face.leftEyeOpenProbability! > 0.6 &&
          face.rightEyeOpenProbability! > 0.6) {
        // expressionText = 'Eyes Open';
      }
      if (expressionText == 'Eyes Closed') {
        onEyesClosed(); // Triggering the callback
        break; // Exiting the loop if "Eyes Closed" detected
      }

      if (expressionText.isNotEmpty) {
        final textSpan = TextSpan(
          text: expressionText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            background: Paint()..color = Colors.black.withOpacity(0.6),
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        textPainter.paint(
          canvas,
          Offset(
            face.boundingBox.left * scaleX + 10,
            face.boundingBox.top * scaleY - 20,
          ),
        );
      }

      for (final connection in faceMaskConnections) {
        canvas.drawLine(
            contour.positionsList[connection.x].scale(scaleX, scaleY),
            contour.positionsList[connection.y].scale(scaleX, scaleY),
            paint);
      }

      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        greenPaint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceMask oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
