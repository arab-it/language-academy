import 'package:flutter/material.dart';

class LanguageFlag extends StatelessWidget {
  final String language;
  final double size;

  const LanguageFlag({super.key, required this.language, this.size = 52});

  @override
  Widget build(BuildContext context) {
    switch (language) {
      case 'English':
        return _flag(
          width: size,
          height: size * 0.68,
          child: Stack(
            children: [
              Column(
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Container(
                      color: index.isEven
                          ? const Color(0xFFB22234)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: size * 0.48,
                  height: size * 0.38,
                  color: const Color(0xFF3C3B6E),
                  child: const Center(
                    child: Text(
                      'âœ¦',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 'Italiano':
        return _flag(
          width: size,
          height: size * 0.68,
          child: Row(
            children: [
              Expanded(child: Container(color: const Color(0xFF009246))),
              Expanded(child: Container(color: Colors.white)),
              Expanded(child: Container(color: const Color(0xFFCE2B37))),
            ],
          ),
        );

      case 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©':
        return _flag(
          width: size,
          height: size * 0.68,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: Container(color: Colors.white)),
                  Expanded(child: Container(color: Colors.black)),
                  Expanded(child: Container(color: const Color(0xFF007A3D))),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ClipPath(
                  clipper: _TriangleClipper(),
                  child: Container(
                    width: size * 0.42,
                    height: size * 0.68,
                    color: const Color(0xFFCE1126),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return _flag(
          width: size,
          height: size * 0.68,
          child: Container(
            color: const Color(0xFF334155),
            child: const Center(
              child: Icon(
                Icons.language_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
    }
  }

  Widget _flag({
    required double width,
    required double height,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

