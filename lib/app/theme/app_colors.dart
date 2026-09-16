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

  // ── Home (Figma 659:2023) — soft green wallet / brand rails ─────
  static const Color homeBg = Color(0xFFFAFAF9);
  static const Color walletGradientStart = Color(0xFFDDE8D6);
  static const Color walletGradientEnd = Color(0xFFFAFEEE);
  static const Color walletBorder = Color(0xFFE6F0E4);
  static const Color walletLabel = Color(0xFF495747);
  static const Color walletBalance = Color(0xFF273B26);
  static const Color walletButton = Color(0xFF162616);
  static const Color walletChipBg = Color(0xFFF4FAE8);
  static const Color walletChipBorder = Color(0xFFE6F0E4);
  static const Color seeAllGreen = Color(0xFF426340);
  static const Color chipSelected = Color(0xFF29252A);
  static const Color notificationDot = Color(0xFF557F52);
  static const Color searchBorder = Color(0xFFEDECED);
  static const Color brandName = Color(0xFF433D46);

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

  // ── Onboarding (Figma 711:1104 / 711:1117 / 711:1222) ───────────────
  static const Color onboardingGreen = Color(0xFF426340);
  static const Color onboardingTitle = Color(0xFF29252A);
  static const Color onboardingSubtitle = Color(0xFF433D46);
  static const Color onboardingBadgeDot = Color(0xFF353037);
  static const Color onboardingBgTop = Color(0xFFF7FBEE);
  static const Color onboardingBgBottom = Color(0xFFFFFFFF);
  static const Color onboardingWaveDome = Color(0xFFC9E0C5);
  static const Color onboardingWaveDiagonal = Color(0xFFDAE9D7);
  static const Color onboardingWaveEarn = Color(0xFFDAE9D7);
  static const Color onboardingCardLabel = Color(0xFF6C6C80);
  static const Color onboardingCardValue = Color(0xFF1E1E2F);
  static const Color onboardingCardBorder = Color(0xFFE8E0FF);
  static const Color onboardingGrowthBg = Color(0xFFDCFCE7);
  static const Color onboardingGrowthText = Color(0xFF16A34A);
  static const Color onboardingWeekBg = Color(0xFFE8F6ED);
  static const Color onboardingBarTop = Color(0xFF95BC93);
  static const Color onboardingBarBottom = Color(0xFFDAE9D7);

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
