import 'package:flutter/material.dart';
import 'package:kamao/app/app.dart';
import 'package:remixicon/remixicon.dart';

/// Visual tokens for a creator rank (Seed / Rising / Proven / Elite).
/// Specs from Figma Creator Tiers (nodes 919:4418 / 919:4358).
class CreatorLevelStyle {
  const CreatorLevelStyle({
    required this.icon,
    required this.iconColor,
    required this.shadowColor,
    required this.cardShadow,
    required this.iconBoxBg,
    required this.titleColor,
    required this.headlineColor,
    required this.tierLabel,
    required this.currentCardEnd,
    required this.currentCardStop,
    required this.progressTrack,
    required this.progressFill,
    this.solidColor,
    this.gradient,
  });

  final IconData icon;
  final Color iconColor;
  final Color shadowColor;

  /// Soft drop shadow for the current-tier / level list card.
  final BoxShadow cardShadow;

  /// 40×40 icon container on the levels list.
  final Color iconBoxBg;

  /// Accent for tier labels / icons.
  final Color titleColor;

  /// Current-card title e.g. "Seed Creator".
  final Color headlineColor;

  /// Short label on the levels list, e.g. "ELITE CREATOR".
  final String tierLabel;

  /// Soft end color for the current-tier card gradient.
  final Color currentCardEnd;

  /// Where white stops before the tint (0–1).
  final double currentCardStop;
  final Color progressTrack;
  final Color progressFill;
  final Color? solidColor;
  final Gradient? gradient;

  static const border = Color(0xFFEDECED);
  static const ink = Color(0xFF4A434D);
  static const nprChipText = Color(0xFFF59E0B);
  static const nprChipBorder = Color(0xFFE6F0E4);
  static const progressTrackColor = Color(0xFFE6F0E4);
  static const postsProgressFill = Color(0xFF426340);
  static const nprProgressFill = Color(0xFFF59E0B);

  static CreatorLevelStyle forCode(String code) {
    switch (code.toLowerCase()) {
      case 'seed':
        return const CreatorLevelStyle(
          icon: RemixIcons.leaf_line,
          iconColor: Color(0xFF16A34A),
          shadowColor: Color(0xFF009D3A),
          // 0px 4px 12px 0px #557F5233
          cardShadow: BoxShadow(
            color: Color(0x33557F52),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
          iconBoxBg: Color(0xFFF7FAF6),
          titleColor: Color(0xFF16A34A),
          headlineColor: Color(0xFF426340),
          tierLabel: 'ENTRY TIER',
          currentCardEnd: Color(0xFFF0FFCD),
          currentCardStop: 0.1737,
          progressTrack: Color(0xFFE6F0E4),
          progressFill: Color(0xFF426340),
          solidColor: Color(0xFF01B945),
        );
      case 'proven':
        return const CreatorLevelStyle(
          icon: RemixIcons.shield_line,
          iconColor: Color(0xFF2563EB),
          shadowColor: Color(0xFF07018C),
          // 0px 4px 4px 0px #537E962B
          cardShadow: BoxShadow(
            color: Color(0x2B537E96),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
          iconBoxBg: Color(0xFFEEF9FF),
          titleColor: Color(0xFF2563EB),
          headlineColor: Color(0xFF2563EB),
          tierLabel: 'PROVEN CREATOR',
          currentCardEnd: Color(0xFFDCF1FC),
          currentCardStop: 0.5337,
          progressTrack: Color(0xFFE6F0E4),
          progressFill: Color(0xFF426340),
          gradient: LinearGradient(
            begin: Alignment(-0.55, -1),
            end: Alignment(1, 0.85),
            colors: [Color(0xFF130CB7), Color(0xFF52E5E7)],
            stops: [0.4365, 1.0],
          ),
        );
      case 'elite':
        return const CreatorLevelStyle(
          icon: RemixIcons.vip_crown_line,
          iconColor: Color(0xFFAC00C1),
          shadowColor: Color(0xFF7F02CA),
          // 0px 4px 4px 0px #FAF0FF
          cardShadow: BoxShadow(
            color: Color(0xFFFAF0FF),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
          iconBoxBg: Color(0xFFFAF0FF),
          titleColor: Color(0xFFAC00C1),
          headlineColor: Color(0xFFAC00C1),
          tierLabel: 'ELITE CREATOR',
          currentCardEnd: Color(0xFFFAF0FF),
          currentCardStop: 0.4862,
          progressTrack: Color(0xFFE6F0E4),
          progressFill: Color(0xFF426340),
          gradient: RadialGradient(
            center: Alignment(-0.915, -0.375),
            radius: 2.2,
            colors: [Color(0xFF7700B3), Color(0xFFE200CF)],
          ),
        );
      case 'rising':
      default:
        return const CreatorLevelStyle(
          icon: RemixIcons.arrow_right_up_line,
          iconColor: Color(0xFFFF7B39),
          shadowColor: Color(0xFFFE421C),
          // 0px 4px 4px 0px #8A590617
          cardShadow: BoxShadow(
            color: Color(0x178A5906),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
          iconBoxBg: Color(0xFFFEF5E7),
          titleColor: Color(0xFFFF7B39),
          headlineColor: Color(0xFFF15000),
          tierLabel: 'RISING CREATOR',
          currentCardEnd: Color(0xFFFFE5D1),
          currentCardStop: 0.5172,
          progressTrack: Color(0xFFE6F0E4),
          progressFill: Color(0xFF426340),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFF7B39), Color(0xFFFF3E1A)],
          ),
        );
    }
  }
}

/// Creator rank pill — Figma home + profile level badges.
///
/// Styles by [code]: seed / rising / proven / elite.
class CreatorLevelBadge extends StatelessWidget {
  const CreatorLevelBadge({
    super.key,
    required this.label,
    required this.code,
    this.compact = true,
    this.onTap,
  });

  /// Display text, e.g. "Rising" or "Seed Creator".
  final String label;

  /// Level code from profile progress, e.g. "seed".
  final String code;

  /// Home header uses compact (16px). Profile uses the larger variant.
  final bool compact;

  final VoidCallback? onTap;

  static const _iconWrapBg = Color(0xFFFFF7ED);

  @override
  Widget build(BuildContext context) {
    final style = CreatorLevelStyle.forCode(code);
    final height = compact ? 16.0 : 22.0;
    final iconWrap = compact ? 9.0 : 12.0;
    final iconSize = compact ? 5.5 : 7.0;
    final fontSize = compact ? 10.0 : 12.0;
    final lineHeight = compact ? 12.0 : 16.0;
    final hPadLeft = compact ? 6.0 : 8.0;
    final hPadRight = compact ? 8.0 : 10.0;
    final vPad = compact ? 2.0 : 3.0;

    final badge = Container(
      height: height,
      padding: EdgeInsets.fromLTRB(hPadLeft, vPad, hPadRight, vPad),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: style.solidColor,
        gradient: style.gradient,
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            offset: const Offset(0, 1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconWrap,
            height: iconWrap,
            decoration: const BoxDecoration(
              color: _iconWrapBg,
              borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
            alignment: Alignment.center,
            child: Icon(style.icon, size: iconSize, color: style.iconColor),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: lineHeight / fontSize,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return badge;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: badge,
    );
  }
}
