// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:kamao/app/app.dart';
// import 'package:kamao/core/core.dart';
// import 'package:kamao/src/wallet/domain/entities/response/withdrawal_entity.dart';
// // See wallet_controller.dart — wallet.dart's re-exported WithdrawalStatus
// // collides with the one above, so it's hidden here too.
// import 'package:kamao/src/wallet/wallet.dart' hide WithdrawalStatus;
// import 'package:remixicon/remixicon.dart';

// import '../controllers/wallet_controller.dart';

// class WalletView extends GetView<WalletController> {
//   const WalletView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       type: MaterialType.transparency,
//       child: Container(
//         color: AppColors.background,
//         child: SafeArea(
//           bottom: false,
//           child: RefreshIndicator(
//             onRefresh: controller.refresh,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.only(bottom: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const _WalletHeader(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: _BalanceCard(controller: controller),
//                   ),
//                   Obx(() {
//                     final hint = controller.walletHintMessage;
//                     if (hint == null) return const SizedBox.shrink();
//                     return Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//                       child: Obx(() => _HintBanner(body: controller.hintBody)),
//                     );
//                   }),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
//                     child: _ActivitySectionHeader(controller: controller),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
//                     child: _ActivityTabs(controller: controller),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//                     child: _ActivityContent(controller: controller),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _WalletHeader extends StatelessWidget {
//   const _WalletHeader();

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
//       child: Text(
//         'Wallet',
//         style: TextStyle(
//           fontFamily: 'Roboto',
//           fontSize: 28,
//           fontWeight: FontWeight.w700,
//           color: AppColors.heading,
//         ),
//       ),
//     );
//   }
// }

// class _BalanceCard extends StatelessWidget {
//   const _BalanceCard({required this.controller});

//   final WalletController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       constraints: const BoxConstraints(minHeight: 190),
//       padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(19),
//         border: Border.all(color: AppColors.white, width: 1),
//         gradient: const LinearGradient(
//           begin: Alignment(-0.22, -2.2),
//           end: Alignment.bottomLeft,
//           colors: [Colors.white, Colors.white, Color(0xFFEFD4FF)],
//           stops: [0.0, 0.4, 1.0],
//         ),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.shadow,
//             blurRadius: 8,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             top: 8,
//             right: 16,
//             child: Opacity(
//               opacity: 0.37,
//               child: SvgPicture.asset(
//                 AppImages.walletBackground,
//                 width: 119,
//                 height: 136,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 48,
//             right: -4,
//             child: SvgPicture.asset(
//               AppImages.wallet,
//               width: 70,
//               height: 50,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 90),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'AVAILABLE BALANCE',
//                       style: AppTextStyles.label.copyWith(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.6,
//                         color: const Color(0xFF3F3F46),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     GestureDetector(
//                       onTap: controller.toggleBalanceVisibility,
//                       child: Obx(
//                         () => Icon(
//                           controller.isBalanceHidden.value
//                               ? RemixIcons.eye_off_line
//                               : RemixIcons.eye_line,
//                           size: 18,
//                           color: const Color(0xFF3F3F46),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Obx(() {
//                   if (controller.isLoading.value &&
//                       controller.summary.value == null) {
//                     return const SizedBox(
//                       height: 32,
//                       width: 32,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                         color: AppColors.accentDark,
//                       ),
//                     );
//                   }
//                   return Text(
//                     controller.formattedAvailableBalance,
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 28,
//                       fontWeight: FontWeight.w700,
//                       height: 1.0,
//                       letterSpacing: 0,
//                       color: Color(0xFF4B0070),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 12),
//                 Obx(
//                   () => Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0x42E8F6ED),
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.6),
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           RemixIcons.wallet_3_fill,
//                           size: 13,
//                           color: Color(0xFF16A34A),
//                         ),
//                         const SizedBox(width: 8),
//                         Flexible(
//                           child: Text(
//                             'Withdrawable : '
//                             '${controller.formattedWithdrawableBalance}',
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontFamily: 'Roboto',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               height: 1.0,
//                               letterSpacing: 0,
//                               color: Color(0xFF16A34A),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: 110,
//                   height: 31,
//                   child: ElevatedButton(
//                     onPressed: controller.onWithdrawTap,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFF4B0070),
//                       elevation: 0,
//                       shadowColor: Colors.transparent,
//                       padding: EdgeInsets.zero,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Withdraw',
//                           style: TextStyle(
//                             fontFamily: 'Roboto',
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                             height: 1.0,
//                             letterSpacing: 0.65,
//                             color: Color(0xFF4B0070),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Transform.rotate(
//                           angle: 1.5708,
//                           child: const Icon(
//                             RemixIcons.logout_box_line,
//                             size: 16,
//                             color: Color(0xFF4B0070),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Green "hint" banner — uses the backend-provided
// /// [WalletSummaryEntity.withdrawalHint] when available, and falls back
// /// to a generic encouragement message when the API doesn't send one.
// class _HintBanner extends StatelessWidget {
//   const _HintBanner({this.title, this.body});

//   final String? title;
//   final String? body;

//   static const String _defaultTitle = 'EARNINGS LOOK GOOD!';
//   static const String _defaultBody =
//       "You've earned 15% more this week compared to last month. "
//       'Keep creating!';

//   @override
//   Widget build(BuildContext context) {
//     final resolvedTitle = (title != null && title!.trim().isNotEmpty)
//         ? title!
//         : _defaultTitle;
//     final resolvedBody = (body != null && body!.trim().isNotEmpty)
//         ? body!
//         : _defaultBody;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8F6ED),
//         borderRadius: BorderRadius.circular(9),
//         border: Border.all(color: const Color(0xFF94D5AC)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: const Color(0xFF16A34A),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0x3310B981),
//                   blurRadius: 2,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//             alignment: Alignment.center,
//             child: const Icon(
//               RemixIcons.sparkling_line,
//               size: 17,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   resolvedTitle,
//                   style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     height: 16 / 12,
//                     letterSpacing: 0.3,
//                     color: Color(0xFF16A34A),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   resolvedBody,
//                   style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 10,
//                     fontWeight: FontWeight.w400,
//                     height: 16.5 / 10,
//                     color: Color(0xFF16A34A),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActivitySectionHeader extends StatelessWidget {
//   const _ActivitySectionHeader({required this.controller});

//   final WalletController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Recent Activity',
//           style: TextStyle(
//             fontFamily: 'Roboto',
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             height: 24 / 18,
//             color: Color(0xFF353037),
//           ),
//         ),
//         InkWell(
//           onTap: controller.onSeeAllActivity,
//           child: const Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'See All',
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF4B0070),
//                 ),
//               ),
//               Icon(
//                 RemixIcons.arrow_right_s_line,
//                 size: 16,
//                 color: Color(0xFF4B0070),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ActivityTabs extends StatelessWidget {
//   const _ActivityTabs({required this.controller});

//   final WalletController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEDECED),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Obx(() {
//         final selected = controller.selectedTab.value;
//         return Row(
//           children: [
//             Expanded(
//               child: _ActivityTabButton(
//                 label: 'Withdrawals',
//                 isSelected: selected == WalletActivityTab.withdrawals,
//                 onTap: () =>
//                     controller.selectTab(WalletActivityTab.withdrawals),
//               ),
//             ),
//             Expanded(
//               child: _ActivityTabButton(
//                 label: 'Ledger',
//                 isSelected: selected == WalletActivityTab.ledger,
//                 onTap: () => controller.selectTab(WalletActivityTab.ledger),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// class _ActivityTabButton extends StatelessWidget {
//   const _ActivityTabButton({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: isSelected
//               ? const [
//                   BoxShadow(
//                     color: Color(0x0D000000),
//                     blurRadius: 2,
//                     offset: Offset(0, 1),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontFamily: 'Roboto',
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             height: 16 / 12,
//             color: isSelected
//                 ? const Color(0xFF581C87)
//                 : const Color(0xFF4A434D),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ActivityContent extends StatelessWidget {
//   const _ActivityContent({required this.controller});

//   final WalletController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final tab = controller.selectedTab.value;
//       final isWithdrawals = tab == WalletActivityTab.withdrawals;

//       final isLoading =
//           controller.isLoading.value &&
//           (isWithdrawals
//               ? controller.withdrawals.isEmpty
//               : controller.ledgerEntries.isEmpty);

//       if (isLoading) {
//         return const Padding(
//           padding: EdgeInsets.symmetric(vertical: 32),
//           child: Center(
//             child: SizedBox(
//               width: 24,
//               height: 24,
//               child: CircularProgressIndicator(strokeWidth: 2.4),
//             ),
//           ),
//         );
//       }

//       final isEmpty = isWithdrawals
//           ? controller.isWithdrawalsTabEmpty
//           : controller.isLedgerTabEmpty;

//       if (controller.error.value != null && isEmpty) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 24),
//             child: TextButton(
//               onPressed: controller.refresh,
//               child: const Text("Couldn't load activity — tap to retry"),
//             ),
//           ),
//         );
//       }

//       if (isEmpty) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 32),
//           child: Center(
//             child: Text(
//               isWithdrawals ? 'No withdrawals yet' : 'No ledger entries yet',
//               style: const TextStyle(fontSize: 13, color: AppColors.bodyGrey),
//             ),
//           ),
//         );
//       }

//       if (isWithdrawals) {
//         final items = controller.withdrawals;
//         return Column(
//           children: [
//             for (final withdrawal in items) ...[
//               _WithdrawalRow(controller: controller, withdrawal: withdrawal),
//               if (withdrawal != items.last) const SizedBox(height: 12),
//             ],
//           ],
//         );
//       }

//       final entries = controller.ledgerEntries;
//       return Column(
//         children: [
//           for (final entry in entries) ...[
//             _LedgerRow(controller: controller, entry: entry),
//             if (entry != entries.last) const SizedBox(height: 12),
//           ],
//         ],
//       );
//     });
//   }
// }

// class _ActivityCard extends StatelessWidget {
//   const _ActivityCard({required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFF1F5F9)),
//       ),
//       child: child,
//     );
//   }
// }

// class _StatusPill extends StatelessWidget {
//   const _StatusPill({
//     required this.label,
//     required this.background,
//     required this.foreground,
//   });

//   final String label;
//   final Color background;
//   final Color foreground;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: background,
//         borderRadius: BorderRadius.circular(7),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontFamily: 'Roboto',
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: foreground,
//         ),
//       ),
//     );
//   }
// }

// class _WithdrawalRow extends StatelessWidget {
//   const _WithdrawalRow({required this.controller, required this.withdrawal});

//   final WalletController controller;
//   final WithdrawalEntity withdrawal;

//   _StatusColors get _colors {
//     switch (withdrawal.status) {
//       case WithdrawalStatus.paid:
//         return const _StatusColors(
//           amount: Color(0xFF16A34A),
//           pillBg: Color(0xFFE7F8EE),
//           pillFg: Color(0xFF16A34A),
//         );
//       case WithdrawalStatus.pending:
//       case WithdrawalStatus.processing:
//         return const _StatusColors(
//           amount: Color(0xFFCA8A04),
//           pillBg: Color(0xFFFFF3DA),
//           pillFg: Color(0xFFCA8A04),
//         );
//       case WithdrawalStatus.rejected:
//         return const _StatusColors(
//           amount: Color(0xFFDC2626),
//           pillBg: Color(0xFFFDE7E9),
//           pillFg: Color(0xFFDC2626),
//         );
//       case WithdrawalStatus.unknown:
//         return const _StatusColors(
//           amount: Color(0xFF6F6875),
//           pillBg: Color(0xFFF0F0F0),
//           pillFg: Color(0xFF6F6875),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = _colors;
//     return _ActivityCard(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _DestinationIcon(destinationType: withdrawal.destinationType),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   controller.destinationLabel(withdrawal.destinationType),
//                   style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     height: 16 / 12,
//                     color: Color(0xFF4A434D),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${controller.formatDateTime(withdrawal.requestedAt)} • '
//                   '${withdrawal.accountNumber}',
//                   style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 11,
//                     fontWeight: FontWeight.w400,
//                     height: 16.5 / 11,
//                     color: Color(0xFF6E6971),
//                   ),
//                 ),
//                 if (withdrawal.status == WithdrawalStatus.rejected &&
//                     (withdrawal.adminNote ?? '').isNotEmpty) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     withdrawal.adminNote!,
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                       height: 16.5 / 11,
//                       color: Color(0xFFD92D20),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 controller.formatAmount(withdrawal.amount),
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   height: 16 / 12,
//                   color: colors.amount,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _StatusPill(
//                 label: controller.withdrawalStatusLabel(withdrawal.status),
//                 background: colors.pillBg,
//                 foreground: colors.pillFg,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class _DestinationIcon extends StatelessWidget {
// //   const _DestinationIcon({required this.destinationType});

// //   final String destinationType;

// //   static const double _size = 44;

// //   @override
// //   Widget build(BuildContext context) {
// //     final normalized = destinationType.toLowerCase();

// //     if (normalized.contains('esewa')) {
// //       return Container(
// //         width: _size,
// //         height: _size,
// //         decoration: const BoxDecoration(
// //           shape: BoxShape.circle,
// //           color: Color(0xFF5EBB47),
// //         ),
// //         alignment: Alignment.center,
// //         child: const Text(
// //           'e',
// //           style: TextStyle(
// //             fontSize: 24,
// //             fontWeight: FontWeight.w900,
// //             fontStyle: FontStyle.italic,
// //             color: Colors.white,
// //             height: 1.0,
// //           ),
// //         ),
// //       );
// //     }

// //     if (normalized.contains('khalti')) {
// //       return SizedBox(
// //         width: _size,
// //         height: _size,
// //         child: Center(
// //           child: Transform.rotate(
// //             angle: -0.7,
// //             child: const Icon(
// //               RemixIcons.send_plane_fill,
// //               size: 30,
// //               color: Color(0xFFE9364A),
// //             ),
// //           ),
// //         ),
// //       );
// //     }

// //     // Bank transfer / anything else — plain solid circle, per design.
// //     return Container(
// //       width: _size,
// //       height: _size,
// //       decoration: const BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: Color(0xFFF4595E),
// //       ),
// //     );
// //   }
// // }
// class _DestinationIcon extends StatelessWidget {
//   const _DestinationIcon({required this.destinationType});

//   final String destinationType;

//   static const double _size = 44;

//   @override
//   Widget build(BuildContext context) {
//     final normalized = destinationType.toLowerCase();

//     if (normalized.contains('esewa')) {
//       return _LogoCircle(assetPath: AppImages.esewa);
//     }

//     if (normalized.contains('khalti')) {
//       return _LogoCircle(assetPath: AppImages.khalti);
//     }

//     // Bank transfer / anything else — plain solid circle, per design.
//     return Container(
//       width: _size,
//       height: _size,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Color(0xFFF4595E),
//       ),
//       alignment: Alignment.center,
//       child: const Icon(RemixIcons.bank_line, size: 20, color: Colors.white),
//     );
//   }
// }

// class _LogoCircle extends StatelessWidget {
//   const _LogoCircle({required this.assetPath});

//   final String assetPath;

//   static const double _size = 44;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: _size,
//       height: _size,
//       decoration: BoxDecoration(
//         // shape: BoxShape.circle,
//         color: Colors.white,
//         // border: Border.all(color: const Color(0xFFEDECED)),
//       ),
//       clipBehavior: Clip.antiAlias,
//       alignment: Alignment.center,
//       child: Image.asset(
//         assetPath,
//         width: _size,
//         height: _size,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }

// class _LedgerRow extends StatelessWidget {
//   const _LedgerRow({required this.controller, required this.entry});

//   final WalletController controller;
//   final WalletLedgerEntryEntity entry;

//   @override
//   Widget build(BuildContext context) {
//     final isDebit = controller.isLedgerEntryDebit(entry.entryType);
//     final isReversal =
//         entry.entryType == WalletLedgerEntryType.withdrawalReversal;
//     final amountColor = isDebit
//         ? const Color(0xFFD92D20)
//         : const Color(0xFF16A34A);

//     return Container(
//       width: double.infinity,
//       constraints: const BoxConstraints(minHeight: 104),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFF1F5F9)),
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     controller.ledgerEntryLabel(entry.entryType).toUpperCase(),
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       height: 16 / 12,
//                       color: Color(0xFF4A434D),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     controller.formatDateTime(entry.createdAt),
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 11,
//                       fontWeight: FontWeight.w400,
//                       height: 16.5 / 11,
//                       color: Color(0xFF6E6971),
//                     ),
//                   ),
//                   if (entry.narration.isNotEmpty) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       entry.narration,
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                         height: 16.5 / 11,
//                         color: isReversal
//                             ? const Color(0xFFD92D20)
//                             : const Color(0xFF6E6971),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const _VerticalDivider(),
//             SizedBox(
//               width: 50,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${isDebit ? '-' : ''}${controller.formatAmount(entry.amount)}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       height: 16 / 12,
//                       color: amountColor,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     entry.currency,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 11,
//                       fontWeight: FontWeight.w400,
//                       height: 16.5 / 11,
//                       color: Color(0xFF6E6971),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const _VerticalDivider(),
//             SizedBox(
//               width: 78, // widened from 67 so the caption fits on one line
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     controller.formatAmount(entry.balanceAfter),
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       height: 16 / 12,
//                       color: Color(0xFF16A34A),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Balance After',
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     softWrap: false,
//                     overflow: TextOverflow.visible,
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 11,
//                       fontWeight: FontWeight.w400,
//                       height: 16.5 / 11,
//                       color: Color(0xFF6E6971),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _VerticalDivider extends StatelessWidget {
//   const _VerticalDivider();

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       child: SizedBox(
//         height: 32,
//         child: VerticalDivider(
//           width: 1,
//           thickness: 1,
//           color: Color(0xFFEDECED),
//         ),
//       ),
//     );
//   }
// }

// class _StatusColors {
//   const _StatusColors({
//     required this.amount,
//     required this.pillBg,
//     required this.pillFg,
//   });

//   final Color amount;
//   final Color pillBg;
//   final Color pillFg;
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/wallet_controller.dart';
import '../widgets/wallet_activity_widgets.dart';

// ═════════════════════════════════════════════════════════════
// Palette — soft green backdrop (Campaign App / Figma 678:5496).
// ═════════════════════════════════════════════════════════════
class _Palette {
  const _Palette._();

  static const gradientTop = AppColors.onboardingBgTop;
}

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  static const int _previewCount = 5;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Solid base so this page renders correctly whether it's
          // embedded in MainNav's Scaffold or pushed as its own route
          // (e.g. from Profile) — the gradient below only paints the
          // top 260px, so without this the rest falls through to
          // whatever's behind WalletView, which is black on its own.
          const Positioned.fill(child: ColoredBox(color: Colors.white)),
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
            bottom: false,
            child: RefreshIndicator(
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _WalletHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _BalanceCard(controller: controller),
                    ),
                    Obx(() {
                      final hint = controller.walletHintMessage;
                      if (hint == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Obx(
                          () => _HintBanner(body: controller.hintBody),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: _ActivitySectionHeader(controller: controller),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: WalletActivityTabs(controller: controller),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: WalletActivityList(
                        controller: controller,
                        maxItems: _previewCount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader();

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
      child: Row(
        children: [
          if (canPop)
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                RemixIcons.arrow_left_s_line,
                size: 28,
                color: AppColors.heading,
              ),
            )
          else
            const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
          // Keeps title optically centered with the back button.
          SizedBox(width: canPop ? 48 : 12),
        ],
      ),
    );
  }
}

/// Balance hero — same green card system as home `_WalletCard`
/// (Figma 660:2074), adapted for the wallet page (Figma 678:5496).
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.controller});

  final WalletController controller;

  static const _designW = 372.0;
  static const _designH = 179.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final s = w / _designW;
        final h = _designH * s;

        return Container(
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20 * s),
            border: Border.all(color: AppColors.walletBorder),
            gradient: const LinearGradient(
              begin: Alignment(-0.85, -0.4),
              end: Alignment(0.9, 0.6),
              colors: [
                AppColors.walletGradientStart,
                AppColors.walletGradientEnd,
              ],
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Positioned(
                left: 199 * s,
                top: -16 * s,
                width: 162.045 * s,
                height: 212.077 * s,
                child: SvgPicture.asset(
                  AppImages.walletCardLeafLarge,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 321 * s,
                top: 117 * s,
                width: 60 * s,
                height: 73 * s,
                child: SvgPicture.asset(
                  AppImages.walletCardLeafBr,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 358.04 * s,
                top: 10.75 * s,
                width: 66.924 * s,
                height: 61.779 * s,
                child: Transform.rotate(
                  angle: -70.48 * 3.1415926535 / 180,
                  child: SvgPicture.asset(
                    AppImages.walletCardLeafTr,
                    width: 46.18 * s,
                    height: 54.635 * s,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Positioned(
              //   left: 188 * s,
              //   top: 68 * s,
              //   width: 114 * s,
              //   height: 87 * s,
              //   child: Image.asset(
              //     AppImages.walletCoins,
              //     fit: BoxFit.contain,
              //     alignment: Alignment.bottomCenter,
              //   ),
              // ),
               Positioned(
                left: 172 * s,//188 * s,
                top: 60 * s,//68 * s,
                width: 114 * s,
                height: 87 * s,
                child: Image.asset(
                  AppImages.walletCoins,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                left: 18 * s,
                top: 18 * s,
                right: 120 * s,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR WALLET',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10 * s,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 15 / 10,
                        color: AppColors.walletLabel,
                      ),
                    ),
                    SizedBox(height: 2 * s),
                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.summary.value == null) {
                        return SizedBox(
                          height: 28 * s,
                          width: 28 * s,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.walletBalance,
                          ),
                        );
                      }
                      return Text(
                        controller.formattedAvailableBalance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 28 * s,
                          fontWeight: FontWeight.w600,
                          height: 42 / 28,
                          letterSpacing: -0.7,
                          color: AppColors.walletBalance,
                        ),
                      );
                    }),
                    Text(
                      'Available balance',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11 * s,
                        fontWeight: FontWeight.w500,
                        height: 16.5 / 11,
                        color: AppColors.walletLabel,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 267 * s,
                top: 19 * s,
                child: Obx(
                  () => _WeeklyGrowthBadge(
                    label: controller.weeklyGrowthAmountLabel,
                    scale: s,
                  ),
                ),
              ),
              Positioned(
                left: 19 * s,
                bottom: 34 * s,
                child: InkWell(
                  onTap: controller.onWithdrawTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * s,
                      vertical: 8 * s,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.walletButton,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6 * s,
                          offset: Offset(0, 4 * s),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Withdraw',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12 * s,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 6 * s),
                        SvgPicture.asset(
                          AppImages.walletViewArrow,
                          width: 12 * s,
                          height: 12 * s,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeeklyGrowthBadge extends StatelessWidget {
  const _WeeklyGrowthBadge({required this.label, this.scale = 1});

  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11 * s, vertical: 7 * s),
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF),
        borderRadius: BorderRadius.circular(12 * s),
        border: Border.all(color: const Color(0xE6FFFFFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2 * s,
            offset: Offset(0, 1 * s),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16 * s,
            height: 16 * s,
            decoration: const BoxDecoration(
              color: Color(0xFFDAE9D7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppImages.walletGrowthArrow,
              width: 10 * s,
              height: 10 * s,
            ),
          ),
          SizedBox(width: 6 * s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10 * s,
                  fontWeight: FontWeight.w500,
                  height: 12.5 / 10,
                  color: AppColors.heading,
                ),
              ),
              Text(
                'this week',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 9 * s,
                  fontWeight: FontWeight.w500,
                  height: 11.25 / 9,
                  color: const Color(0xFF6E6971),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Green "hint" banner — uses the backend-provided
/// [WalletSummaryEntity.withdrawalHint] when available, and falls back
/// to a generic encouragement message when the API doesn't send one.
class _HintBanner extends StatelessWidget {
  const _HintBanner({this.body});

  final String? body;

  static const String _defaultTitle = 'EARNINGS LOOK GOOD!';
  static const String _defaultBody =
      "You've earned 15% more this week compared to last month. "
      'Keep creating!';

  @override
  Widget build(BuildContext context) {
    final resolvedBody = (body != null && body!.trim().isNotEmpty)
        ? body!
        : _defaultBody;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6ED),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF94D5AC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.onboardingGreen,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onboardingGreen.withValues(alpha: 0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              RemixIcons.sparkling_line,
              size: 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  _defaultTitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    letterSpacing: 0.3,
                    color: AppColors.onboardingGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  resolvedBody,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 16.5 / 10,
                    color: AppColors.onboardingGreen.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitySectionHeader extends StatelessWidget {
  const _ActivitySectionHeader({required this.controller});

  final WalletController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 24 / 18,
            color: AppColors.heading,
          ),
        ),
        InkWell(
          onTap: controller.onSeeAllActivity,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See All',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onboardingGreen,
                ),
              ),
              Icon(
                RemixIcons.arrow_right_s_line,
                size: 16,
                color: AppColors.onboardingGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
