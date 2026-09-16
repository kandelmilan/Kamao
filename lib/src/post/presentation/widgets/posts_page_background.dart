import 'package:flutter/material.dart';

/// Soft mint wash at the top — matches
/// `linear-gradient(359.15deg, #F9F9F9 90.09%, #F4F9E8 100.81%)`.
class PostsPageBackground extends StatelessWidget {
  const PostsPageBackground({super.key, required this.child});

  static const pageBg = Color(0xFFF9F9F9);
  static const gradientMint = Color(0xFFF4F9E8);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // ~359.15deg ≈ nearly bottom → top, slight tilt.
          begin: Alignment(0.015, 1.0),
          end: Alignment(-0.015, -1.0),
          colors: [
            pageBg,
            pageBg,
            gradientMint,
          ],
          stops: [0.0, 0.9009, 1.0],
        ),
      ),
      child: child,
    );
  }
}
