import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/core/core.dart';

/// Logo + "kamao" wordmark, reused across the pre-auth screens
/// (login, register, forgot password, splash).
///
/// No background/circle/shadow behind the mark — the asset itself
/// is the full graphic already, so this just lays out the image and
/// the wordmark with the correct spacing and typography.
///
/// Note: the SVG asset has built-in whitespace around the mark, which
/// is why the visible gap under it is larger than any spacing set
/// here. [pullUp] compensates for that by nudging the wordmark
/// upward instead of relying on the asset's real bounds.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96, this.pullUp = 24});

  final double size;

  /// How far to pull the "kamao" text up to close the visual gap
  /// left by whitespace baked into the SVG asset. Tune this if the
  /// asset changes.
  final double pullUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.appLogo, width: size, height: size),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(0, -pullUp),
            child: Text(
              'kamao',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: const Color(0xFF4B0070),
                fontWeight: FontWeight.w500,
                fontSize: 20,
                height: 1.0,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
