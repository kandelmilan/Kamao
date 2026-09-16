import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import '../controllers/wallet_controller.dart';
import '../widgets/wallet_activity_widgets.dart';

// Soft green backdrop — matches wallet page (Figma 678:5496).
class _Palette {
  const _Palette._();

  static const gradientTop = AppColors.onboardingBgTop;
  static const titleText = AppColors.heading;
}

/// Full transaction history — same tabs and rows as the wallet home page,
/// but with no cap on how many items are shown.
class WalletTransactionsView extends GetView<WalletController> {
  const WalletTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: _Palette.titleText,
            ),
          ),
        ),
        title: const Text(
          'All Transactions',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 24 / 18,
            color: _Palette.titleText,
          ),
        ),
        centerTitle: false,
      ),
      body: SizedBox.expand(
        // Scaffold.body only gives loose constraints, so without this the
        // Stack shrink-wraps its content instead of filling the screen —
        // which is why the Positioned gradient wasn't showing.
        child: Stack(
          children: [
            // Backdrop gradient — matches FeaturedCampaignsPage.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_Palette.gradientTop, Colors.white],
                    stops: [0.0, 0.85],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WalletActivityTabs(controller: controller),
                      const SizedBox(height: 16),
                      WalletActivityList(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
