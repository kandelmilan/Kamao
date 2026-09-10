import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand / primary ──────────────────────────────────────────────
  static const Color primaryDark = Color(0xFF3E0163);
  static const Color primary = Color(0xFF4B0070);
  static const Color primaryLight = Color(0xFF6F338D);

  // static const Color accent = Color(0xFFFF6B6B); // coral
  static const Color accent = Color(0xFFE86161); // coral
  static const Color accentDark = Color(
    0xFFE86161,
  ); // coralDark (Withdraw button)
  static const Color accentLight = Color(0xFFFF8F8F);

  // ── Wallet-card gradient (Splash + Home share this) ──────────────
  static const Color gradientTop = Color(0xFF6F338D);
  static const Color gradientMiddle = Color(0xFF571A78);
  static const Color gradientBottom = Color(0xFF3E0163);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color ink = Color(0xFF17121A);
  static const Color heading = Color(0xFF353037);
  static const Color subtext = Color(0xFF4A434D);
  static const Color bodyGrey = Color(0xFF6F6875);
  static const Color cardTitle = Color(0xFF29252A);

  // ── Status ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF94D5AC);

  // ── Surfaces ─────────────────────────────────────────────────────
  static const Color background = Color(0xFFF6F4F7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color socialCardBg = Color(0xFFFAF8FF);
  static const Color socialCardBorder = Color(0xFFEDE6F1);

  // ── Decorations — Splash's plain white-opacity circles ────────────
  static const Color circleLarge = Color(0xFFFFFFFF);
  static const Color circleBorder = Color(0xFFFFFFFF);

  // ── Glass / shadow ───────────────────────────────────────────────
  static const Color glass = Color(0x144B0070);
  static const Color glassBorder = Color(0x386F338D);
  static const Color shadow = Color(0x264B0070);

  // ── Onboarding screen ───────────────────────────────────────────────
  static const Color onboardingBgTop = Color(0xFFF2FFAF);
  static const Color onboardingBgMid = Color(0xFFF7FFCC);
  static const Color onboardingBgBottom = Color(0xFFFFFFFF);
  static const Color onboardingInk = Color(0xFF121212);
  static const Color onboardingSubtleGrey = Color(0xFF8A8F98);
  static const Color onboardingCardGrey = Color(0xFFF4F4F4);
  static const Color onboardingBorderGrey = Color(0xFFE3E3E6);
  static const Color onboardingLime = Color(0xFFE6F694);

  // ── Featured brands section ────────────────────────────────────
  // Figma node 32:3530 "Featured" chip fill is Foundation/accent
  // color/orange-600 (#E86161) — the *dark* coral, same value as
  // accentDark — not the lighter #FF6B6B this was pointing at before.
  static const Color chipSelectedBg = Color(0xFFE86161);
  static const Color chipUnselectedBorder = Color(0xFFE7E3E9);
  static const Color rewardBadgeBg = Color(0xFFFFF3F3);

  // Unselected filter-chip text/border (Figma "Travel Brand" /
  // "Health & Fitness" pills, node 32:3534–3539) use a *different*
  // grey pair than chipUnselectedBorder above — Foundation/grays/
  // violet-600 for text and Foundation/Grey/grey-100 for the border.
  static const Color filterChipText = Color(0xFF433D46);
  static const Color filterChipBorder = Color(0xFFD6D6D6);
  // Figma's "Offline" chip (same row) is styled distinctly: bold text
  // in Foundation/Grey/grey-500. No inactive/offline concept exists
  // in HomeController's categories yet, so this token is here for
  // when that state is wired up — it isn't consumed anywhere yet.
  static const Color filterChipInactiveText = Color(0xFF7B7B7B);
  //
  // Featured-brand-row logo placeholder (Figma "brand-logo" node
  // 32:3543): #F3F4F6 fill with the existing chipUnselectedBorder
  // (#E7E3E9) outline — distinct from socialCardBg/socialCardBorder,
  // which belong to the "Connect Social Accounts" card only.
  static const Color brandLogoBg = Color(0xFFF3F4F6);

  // ── Recently Rewarded card overlays ────────────────────────────
  static const Color overlayPillBg = Color(0xE6FFFFFF);
  static const Color payoutBadgeBg = Color(0xE6121212);
}
