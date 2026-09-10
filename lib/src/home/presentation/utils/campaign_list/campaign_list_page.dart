// //
// // Reusable "See All" campaigns page — used by Popular Campaigns,
// // New Campaigns, Recommended, etc. Pass a different `fetcher` + `title`
// // per entry point; everything else (search, pagination, styling) is shared.
// //
// // Figma spec matched 1:1:
// //  - Title: Roboto 700 18px/24px, #353037
// //  - Search bar: 372x46, radius 12, 1px #EDECED border
// //  - Search hint: Roboto 400 12.98px/19.47px, letter-spacing 0.41, #7B7B7B
// //  - List card: radius 12, 1px #EAECF0 border
// //  - Row: 96px tall, logo 72x72 circle w/ 2px white ring
// //  - Name: Roboto 500 16px/20px, #353037
// //  - Subtitle: Roboto 400 12px/12px, #6F6875
// //  - Chevron: 5x10, 2px stroke, #4B0070

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kamao/core/utils/image_url_resolver.dart';
// import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
// import 'campaign_list_controller.dart';
// import 'campaign_list_types.dart';

// // ═════════════════════════════════════════════════════════════
// // Palette — exact Figma hex values, kept local to this feature
// // ═════════════════════════════════════════════════════════════
// class _Palette {
//   const _Palette._();

//   static const gradientLilac = Color(0xFFF1D9FF); // same recipe as splash
//   static const titleText = Color(0xFF353037);
//   static const searchBorder = Color(0xFFEDECED);
//   static const searchHint = Color(0xFF7B7B7B);
//   static const cardBorder = Color(0xFFEAECF0);
//   static const subtitleText = Color(0xFF6F6875);
//   static const arrowPurple = Color(0xFF4B0070);
// }

// // ═════════════════════════════════════════════════════════════
// // Page
// // ═════════════════════════════════════════════════════════════
// class CampaignListPage extends StatefulWidget {
//   const CampaignListPage({
//     super.key,
//     required this.title,
//     required this.fetcher,
//     this.take = 20,
//     this.emptyMessage = 'No campaigns found',
//     this.enableSearch = true,
//     this.onCampaignTap,
//     this.subtitleBuilder,
//   });

//   final String title;
//   final CampaignPageFetcher fetcher;
//   final int take;
//   final String emptyMessage;
//   final bool enableSearch;
//   final void Function(CampaignEntity campaign)? onCampaignTap;
//   final String Function(CampaignEntity campaign)? subtitleBuilder;

//   @override
//   State<CampaignListPage> createState() => _CampaignListPageState();
// }

// class _CampaignListPageState extends State<CampaignListPage> {
//   late final CampaignListController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CampaignListController(
//       title: widget.title,
//       fetcher: widget.fetcher,
//       take: widget.take,
//       emptyMessage: widget.emptyMessage,
//       enableSearch: widget.enableSearch,
//     );
//     controller.loadFirstPage();
//   }

//   @override
//   void dispose() {
//     controller.onClose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: 260,
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [_Palette.gradientLilac, Colors.white],
//                   stops: [0.0, 0.85],
//                 ),
//               ),
//             ),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _Header(title: widget.title),
//                   const SizedBox(height: 20),
//                   if (widget.enableSearch)
//                     _SearchBar(onChanged: controller.onSearchChanged),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: SizedBox(
//                       height: 672,
//                       child: Obx(() {
//                         if (controller.isLoading.value &&
//                             controller.campaigns.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         if (controller.error.value != null &&
//                             controller.campaigns.isEmpty) {
//                           return Center(
//                             child: TextButton(
//                               onPressed: controller.loadFirstPage,
//                               child: const Text("Couldn't load — tap to retry"),
//                             ),
//                           );
//                         }
//                         if (controller.campaigns.isEmpty) {
//                           return Center(child: Text(controller.emptyMessage));
//                         }
//                         return _CampaignCard(
//                           controller: controller,
//                           onCampaignTap: widget.onCampaignTap,
//                           subtitleBuilder: widget.subtitleBuilder,
//                         );
//                       }),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Header — back button + "New Campaigns" (Roboto 700 18/24, #353037)
// // ═════════════════════════════════════════════════════════════
// class _Header extends StatelessWidget {
//   const _Header({required this.title});

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//       child: Row(
//         children: [
//           InkWell(
//             onTap: () => Navigator.of(context).maybePop(),
//             borderRadius: BorderRadius.circular(20),
//             child: const Padding(
//               padding: EdgeInsets.all(4),
//               child: Icon(
//                 Icons.arrow_back_ios_new,
//                 size: 18,
//                 color: _Palette.titleText,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             title,
//             style: GoogleFonts.roboto(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               height: 24 / 18,
//               color: _Palette.titleText,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Search bar — 372x46, radius 12, 1px #EDECED border
// // hint: Roboto 400 12.98/19.47, letter-spacing 0.41, #7B7B7B
// // ═════════════════════════════════════════════════════════════
// class _SearchBar extends StatelessWidget {
//   const _SearchBar({required this.onChanged});

//   final ValueChanged<String> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         height: 46,
//         constraints: const BoxConstraints(maxWidth: 584),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _Palette.searchBorder, width: 1),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 14),
//             Expanded(
//               child: TextField(
//                 onChanged: onChanged,
//                 style: GoogleFonts.roboto(
//                   fontSize: 12.98,
//                   fontWeight: FontWeight.w400,
//                   height: 19.47 / 12.98,
//                   letterSpacing: 0.41,
//                   color: _Palette.titleText,
//                 ),
//                 decoration: InputDecoration(
//                   isCollapsed: true,
//                   border: InputBorder.none,
//                   hintText: 'Search campaigns or brands...',
//                   hintStyle: GoogleFonts.roboto(
//                     fontSize: 12.98,
//                     fontWeight: FontWeight.w400,
//                     height: 19.47 / 12.98,
//                     letterSpacing: 0.41,
//                     color: _Palette.searchHint,
//                   ),
//                 ),
//               ),
//             ),
//             const Icon(Icons.search, size: 20, color: _Palette.searchHint),
//             const SizedBox(width: 14),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Card — bordered container (radius 12, 1px #EAECF0) holding rows,
// // with infinite-scroll + pull-to-refresh wired to the controller
// // ═════════════════════════════════════════════════════════════
// class _CampaignCard extends StatelessWidget {
//   const _CampaignCard({
//     required this.controller,
//     this.onCampaignTap,
//     this.subtitleBuilder,
//   });

//   final CampaignListController controller;
//   final void Function(CampaignEntity campaign)? onCampaignTap;
//   final String Function(CampaignEntity campaign)? subtitleBuilder;

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: controller.refresh,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _Palette.cardBorder, width: 1),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (n) {
//             if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
//               controller.loadMore();
//             }
//             return false;
//           },
//           child: Obx(() {
//             final items = controller.campaigns;
//             final showLoader = controller.hasMore.value;
//             return ListView.separated(
//               padding: EdgeInsets.zero,
//               itemCount: items.length + (showLoader ? 1 : 0),
//               separatorBuilder: (_, __) =>
//                   const Divider(height: 1, color: _Palette.cardBorder),
//               itemBuilder: (context, index) {
//                 if (index >= items.length) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     child: Center(
//                       child: SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                     ),
//                   );
//                 }
//                 final campaign = items[index];
//                 return _CampaignRow(
//                   campaign: campaign,
//                   subtitle:
//                       subtitleBuilder?.call(campaign) ??
//                       'Fast and reliable delivery and ride.',
//                   onTap: () => onCampaignTap?.call(campaign),
//                 );
//               },
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Row — 96px tall. Logo 72x72 circle w/ 2px white ring.
// // Name: Roboto 500 16/20, #353037. Subtitle: Roboto 400 12/12, #6F6875.
// // ═════════════════════════════════════════════════════════════
// class _CampaignRow extends StatelessWidget {
//   const _CampaignRow({
//     required this.campaign,
//     required this.subtitle,
//     this.onTap,
//   });

//   final CampaignEntity campaign;
//   final String subtitle;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final logoUrl = resolveImageUrl(campaign.brandLogoUrl);

//     return InkWell(
//       onTap: onTap,
//       child: SizedBox(
//         height: 96,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             children: [
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0x14000000),
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: ClipOval(
//                   child: logoUrl == null
//                       ? const _LogoFallback()
//                       : Image.network(
//                           logoUrl,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => const _LogoFallback(),
//                           loadingBuilder: (context, child, progress) {
//                             if (progress == null) return child;
//                             return const Center(
//                               child: SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       campaign.brandName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.roboto(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         height: 20 / 16,
//                         color: _Palette.titleText,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.roboto(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         height: 1.0,
//                         color: _Palette.subtitleText,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const _Chevron(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _LogoFallback extends StatelessWidget {
//   const _LogoFallback();

//   @override
//   Widget build(BuildContext context) {
//     return const ColoredBox(
//       color: Color(0xFFF4F4F4),
//       child: Icon(
//         Icons.storefront_outlined,
//         size: 28,
//         color: _Palette.subtitleText,
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Chevron — exact 5x10, 2px stroke, #4B0070 (CustomPainter, not Icons)
// // ═════════════════════════════════════════════════════════════
// class _Chevron extends StatelessWidget {
//   const _Chevron();

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       width: 5,
//       height: 10,
//       child: CustomPaint(painter: _ChevronPainter()),
//     );
//   }
// }

// class _ChevronPainter extends CustomPainter {
//   const _ChevronPainter();

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = _Palette.arrowPurple
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..isAntiAlias = true;

//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width, size.height / 2)
//       ..lineTo(0, size.height);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// Reusable "See All" campaigns page — used by Popular Campaigns,
// New Campaigns, Featured, category-filtered, etc. Generic over the
// entity type so it works for both CampaignEntity and
// MarketplaceCampaignEntity (or anything else) without either
// pretending to be the other — pass idOf/nameOf/logoUrlOf to tell it
// how to read your entity.
//
// Figma spec matched 1:1:
//  - Title: Roboto 700 18px/24px, #353037
//  - Search bar: 372x46, radius 12, 1px #EDECED border
//  - Search hint: Roboto 400 12.98px/19.47px, letter-spacing 0.41, #7B7B7B
//  - List card: radius 12, 1px #EAECF0 border
//  - Row: 96px tall, logo 72x72 circle w/ 2px white ring
//  - Name: Roboto 500 16px/20px, #353037
//  - Subtitle: Roboto 400 12px/12px, #6F6875
//  - Chevron: 5x10, 2px stroke, #4B0070

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'campaign_list_controller.dart';
import 'campaign_list_types.dart';

// ═════════════════════════════════════════════════════════════
// Palette — exact Figma hex values, kept local to this feature
// ═════════════════════════════════════════════════════════════
class _Palette {
  const _Palette._();

  static const gradientLilac = Color(0xFFF1D9FF);
  static const titleText = Color(0xFF353037);
  static const searchBorder = Color(0xFFEDECED);
  static const searchHint = Color(0xFF7B7B7B);
  static const cardBorder = Color(0xFFEAECF0);
  static const subtitleText = Color(0xFF6F6875);
  static const arrowPurple = Color(0xFF4B0070);
}

// ═════════════════════════════════════════════════════════════
// Page
// ═════════════════════════════════════════════════════════════
class CampaignListPage<T> extends StatefulWidget {
  const CampaignListPage({
    super.key,
    required this.title,
    required this.fetcher,
    required this.idOf,
    required this.nameOf,
    required this.logoUrlOf,
    this.take = 20,
    this.emptyMessage = 'No campaigns found',
    this.enableSearch = true,
    this.onCampaignTap,
    this.subtitleBuilder,
  });

  final String title;
  final CampaignPageFetcher<T> fetcher;
  final int take;
  final String emptyMessage;
  final bool enableSearch;
  final void Function(T campaign)? onCampaignTap;
  final String Function(T campaign)? subtitleBuilder;

  /// How to read the fields this page needs off [T] — decouples the
  /// shared list UI from any one concrete entity type.
  final String Function(T campaign) idOf;
  final String Function(T campaign) nameOf;
  final String? Function(T campaign) logoUrlOf;

  @override
  State<CampaignListPage<T>> createState() => _CampaignListPageState<T>();
}

class _CampaignListPageState<T> extends State<CampaignListPage<T>> {
  late final CampaignListController<T> controller;

  @override
  void initState() {
    super.initState();
    controller = CampaignListController<T>(
      title: widget.title,
      fetcher: widget.fetcher,
      take: widget.take,
      emptyMessage: widget.emptyMessage,
      enableSearch: widget.enableSearch,
    );
    controller.loadFirstPage();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                  colors: [_Palette.gradientLilac, Colors.white],
                  stops: [0.0, 0.85],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Header(title: widget.title),
                  const SizedBox(height: 20),
                  if (widget.enableSearch)
                    _SearchBar(onChanged: controller.onSearchChanged),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 672,
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.campaigns.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.error.value != null &&
                            controller.campaigns.isEmpty) {
                          return Center(
                            child: TextButton(
                              onPressed: controller.loadFirstPage,
                              child: const Text(
                                "Couldn't load — tap to retry",
                              ),
                            ),
                          );
                        }
                        if (controller.campaigns.isEmpty) {
                          return Center(child: Text(controller.emptyMessage));
                        }
                        return _CampaignCard<T>(
                          controller: controller,
                          idOf: widget.idOf,
                          nameOf: widget.nameOf,
                          logoUrlOf: widget.logoUrlOf,
                          onCampaignTap: widget.onCampaignTap,
                          subtitleBuilder: widget.subtitleBuilder,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Header — back button + title (Roboto 700 18/24, #353037)
// ═════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          InkWell(
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
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 24 / 18,
              color: _Palette.titleText,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Search bar — 372x46, radius 12, 1px #EDECED border
// hint: Roboto 400 12.98/19.47, letter-spacing 0.41, #7B7B7B
// ═════════════════════════════════════════════════════════════
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        constraints: const BoxConstraints(maxWidth: 584),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _Palette.searchBorder, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: GoogleFonts.roboto(
                  fontSize: 12.98,
                  fontWeight: FontWeight.w400,
                  height: 19.47 / 12.98,
                  letterSpacing: 0.41,
                  color: _Palette.titleText,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search campaigns or brands...',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 12.98,
                    fontWeight: FontWeight.w400,
                    height: 19.47 / 12.98,
                    letterSpacing: 0.41,
                    color: _Palette.searchHint,
                  ),
                ),
              ),
            ),
            const Icon(Icons.search, size: 20, color: _Palette.searchHint),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Card — bordered container (radius 12, 1px #EAECF0) holding rows,
// with infinite-scroll + pull-to-refresh wired to the controller
// ═════════════════════════════════════════════════════════════
class _CampaignCard<T> extends StatelessWidget {
  const _CampaignCard({
    required this.controller,
    required this.idOf,
    required this.nameOf,
    required this.logoUrlOf,
    this.onCampaignTap,
    this.subtitleBuilder,
  });

  final CampaignListController<T> controller;
  final String Function(T campaign) idOf;
  final String Function(T campaign) nameOf;
  final String? Function(T campaign) logoUrlOf;
  final void Function(T campaign)? onCampaignTap;
  final String Function(T campaign)? subtitleBuilder;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _Palette.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
              controller.loadMore();
            }
            return false;
          },
          child: Obx(() {
            final items = controller.campaigns;
            final showLoader = controller.hasMore.value;
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: items.length + (showLoader ? 1 : 0),
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: _Palette.cardBorder),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                final campaign = items[index];
                return _CampaignRow<T>(
                  campaign: campaign,
                  name: nameOf(campaign),
                  logoUrl: logoUrlOf(campaign),
                  subtitle:
                      subtitleBuilder?.call(campaign) ??
                      'Fast and reliable delivery and ride.',
                  onTap: () => onCampaignTap?.call(campaign),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Row — 96px tall. Logo 72x72 circle w/ 2px white ring.
// Name: Roboto 500 16/20, #353037. Subtitle: Roboto 400 12/12, #6F6875.
// ═════════════════════════════════════════════════════════════
class _CampaignRow<T> extends StatelessWidget {
  const _CampaignRow({
    required this.campaign,
    required this.name,
    required this.logoUrl,
    required this.subtitle,
    this.onTap,
  });

  final T campaign;
  final String name;
  final String? logoUrl;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 96,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: logoUrl == null
                      ? const _LogoFallback()
                      : Image.network(
                          logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _LogoFallback(),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        color: _Palette.titleText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: _Palette.subtitleText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const _Chevron(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF4F4F4),
      child: Icon(
        Icons.storefront_outlined,
        size: 28,
        color: _Palette.subtitleText,
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Chevron — exact 5x10, 2px stroke, #4B0070 (CustomPainter, not Icons)
// ═════════════════════════════════════════════════════════════
class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 5,
      height: 10,
      child: CustomPaint(painter: _ChevronPainter()),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _Palette.arrowPurple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}