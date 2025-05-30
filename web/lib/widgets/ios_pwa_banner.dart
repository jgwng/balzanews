import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showInstallPrompt(BuildContext context) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: ClipPath(
          clipper: BubbleWithPointerClipper(),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App icon
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/app_icon.png'), // ✅ Replace with your icon
                ),
                const SizedBox(height: 12),
                // Title
                const Text(
                  'Install Employee Directory',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                // Subtitle
                const Text(
                  'Add this app to your home screen for easy access and a better experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                // Instructions
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Tap '),
                    Icon(CupertinoIcons.share, size: 18,color: Color(0xFF007AFF),),
                    Text(' then "Add to Home Screen"'),
                  ],
                ),
                const SizedBox(height: 8),
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
class BubbleWithPointerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 16;
    const double pointerWidth = 20;
    const double pointerHeight = 10;

    final Path path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - pointerHeight - radius);
    path.quadraticBezierTo(size.width, size.height - pointerHeight, size.width - radius, size.height - pointerHeight);

    // Bottom pointer
    path.lineTo(size.width / 2 + pointerWidth / 2, size.height - pointerHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - pointerWidth / 2, size.height - pointerHeight);

    path.lineTo(radius, size.height - pointerHeight);
    path.quadraticBezierTo(0, size.height - pointerHeight, 0, size.height - pointerHeight - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
