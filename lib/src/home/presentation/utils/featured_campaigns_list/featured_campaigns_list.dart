import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_controller.dart';
import 'package:kamao/src/home/presentation/utils/campaign_list/campaign_list_types.dart';

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
}

// ═════════════════════════════════════════════════════════════
// Page
// ═════════════════════════════════════════════════════════════
class FeaturedCampaignsPage<T> extends StatefulWidget {
  const FeaturedCampaignsPage({
    super.key,
    required this.title,
    required this.fetcher,
    required this.nameOf,
    required this.subtitleOf,
    required this.coverUrlOf,
    this.take = 20,
    this.emptyMessage = 'No campaigns found',
    this.enableSearch = true,
    this.onCampaignTap,
  });

  final String title;
  final CampaignPageFetcher<T> fetcher;
  final int take;
  final String emptyMessage;
  final bool enableSearch;
  final void Function(T campaign)? onCampaignTap;

  /// How to read the fields the card needs off [T].
  final String Function(T campaign) nameOf;
  final String Function(T campaign) subtitleOf;
  final String? Function(T campaign) coverUrlOf;

  @override
  State<FeaturedCampaignsPage<T>> createState() =>
      _FeaturedCampaignsPageState<T>();
}

class _FeaturedCampaignsPageState<T> extends State<FeaturedCampaignsPage<T>> {
  late final CampaignListController<T> controller;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
            child: RefreshIndicator(
              onRefresh: controller.refresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _Header(title: widget.title)),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  if (widget.enableSearch)
                    SliverToBoxAdapter(
                      child: _SearchBar(onChanged: controller.onSearchChanged),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.campaigns.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (controller.error.value != null &&
                        controller.campaigns.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: TextButton(
                            onPressed: controller.loadFirstPage,
                            child: const Text("Couldn't load — tap to retry"),
                          ),
                        ),
                      );
                    }
                    if (controller.campaigns.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text(controller.emptyMessage)),
                      );
                    }

                    final items = controller.campaigns;
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 180 / 240,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final campaign = items[index];
                          return _FeaturedCampaignCard(
                            name: widget.nameOf(campaign),
                            subtitle: widget.subtitleOf(campaign),
                            coverUrl: widget.coverUrlOf(campaign),
                            onTap: () => widget.onCampaignTap?.call(campaign),
                          );
                        }, childCount: items.length),
                      ),
                    );
                  }),
                  Obx(
                    () => SliverToBoxAdapter(
                      child: controller.isLoadingMore.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(height: 12),
                    ),
                  ),
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
// Featured campaign card — 180x240, radius 16, 1px #EAECF0 border
// image area 130h (12 padding), name 16/700, subtitle 13/400
//
// Same look as the reference _FeaturedCampaignCard, but generic:
// takes plain name/subtitle/coverUrl/onTap so this page doesn't need
// to know about MarketplaceCampaignEntity (or AppRoutes) directly.
// ═════════════════════════════════════════════════════════════
class _FeaturedCampaignCard extends StatelessWidget {
  const _FeaturedCampaignCard({
    required this.name,
    required this.subtitle,
    required this.coverUrl,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String? coverUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _Palette.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: coverUrl != null
                    ? Image.network(
                        coverUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => const _ImageFallback(),
                      )
                    : const _ImageFallback(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
                        fontWeight: FontWeight.w700,
                        height: 20 / 16,
                        color: _Palette.titleText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 18 / 13,
                        color: _Palette.subtitleText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

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
