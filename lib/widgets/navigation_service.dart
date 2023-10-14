import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> showDialog({
    required WidgetBuilder builder,
  }) {
    return navigatorKey.currentState!
        .push(MaterialPageRoute(builder: builder, fullscreenDialog: true));
  }
}

final NavigationService navigationService = NavigationService();

class NotchedRectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 20) // Start of top-right notch
      ..quadraticBezierTo(
          size.width / 2,
          -20, // Approximate midpoint and notch depth
          0,
          20) // End of top-left notch
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
