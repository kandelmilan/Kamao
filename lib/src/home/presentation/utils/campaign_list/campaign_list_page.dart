import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/app/theme/app_colors.dart';
import 'package:kamao/core/core.dart';
import 'campaign_list_controller.dart';
import 'campaign_list_types.dart';

class _Palette {
  const _Palette._();

  static const pageBg = Color(0xFFFFFFFF);
  static const gradientMint = Color(0xFFF4FAE9);
  static const titleText = AppColors.heading;
  static const searchBorder = AppColors.searchBorder;
  static const searchHint = AppColors.filterChipInactiveText;
  static const cardBorder = AppColors.chipUnselectedBorder;
  static const subtitleText = AppColors.bodyGrey;
  static const chevron = AppColors.bodyGrey;
  static const logoFallback = AppColors.brandLogoBg;
}

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

  final String Function(T campaign) idOf;
  final String Function(T campaign) nameOf;
  final String? Function(T campaign) logoUrlOf;

  @override
  State<CampaignListPage<T>> createState() => _CampaignListPageState<T>();
}

class _CampaignListPageState<T> extends State<CampaignListPage<T>> {
  late final CampaignListController<T> controller;

  static const _defaultSubtitle = 'Fast and reliable delivery and ride.';

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
      backgroundColor: _Palette.pageBg,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          // Figma: linear-gradient(0.11deg, #FFFFFF 82.65%, #F4FAE9 101.33%)
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [_Palette.pageBg, _Palette.gradientMint],
            stops: [0.8265, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(title: widget.title),
              if (widget.enableSearch) ...[
                const SizedBox(height: 16),
                _SearchBar(
                  onChanged: controller.onSearchChanged,
                  onClear: controller.clearSearch,
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Obx(() => _buildBody()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value && controller.campaigns.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error.value != null && controller.campaigns.isEmpty) {
      return Center(
        child: TextButton(
          onPressed: controller.loadFirstPage,
          child: Text(
            controller.error.value!,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.seeAllGreen,
            ),
          ),
        ),
      );
    }
    if (controller.campaigns.isEmpty) {
      return Center(
        child: Text(
          controller.emptyMessage,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _Palette.subtitleText,
          ),
        ),
      );
    }

    final items = controller.campaigns;
    final showLoader = controller.hasMore.value;

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
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
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
              return _CampaignRow(
                name: widget.nameOf(campaign),
                subtitle:
                    widget.subtitleBuilder?.call(campaign) ?? _defaultSubtitle,
                logoUrl: widget.logoUrlOf(campaign),
                onTap: () => widget.onCampaignTap?.call(campaign),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: _Palette.titleText,
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 24 / 18,
                color: _Palette.titleText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.onChanged,
    required this.onClear,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _hasText = false;
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onText);
    _focusNode.addListener(_onFocus);
  }

  void _onText() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _onFocus() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onText)
      ..dispose();
    _focusNode
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? AppColors.seeAllGreen.withValues(alpha: 0.55)
        : _Palette.searchBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: borderColor, width: _focused ? 1.5 : 1),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: AppColors.seeAllGreen.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            SvgPicture.asset(
              AppImages.iconSearch,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                _focused ? AppColors.seeAllGreen : _Palette.searchHint,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _focusNode.unfocus(),
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _Palette.titleText,
                ),
                cursorColor: AppColors.seeAllGreen,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search campaigns, brands...',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _Palette.searchHint,
                  ),
                ),
              ),
            ),
            if (_hasText)
              IconButton(
                onPressed: _clear,
                tooltip: 'Clear',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: _Palette.searchHint,
                ),
              ),
            InkWell(
              onTap: () => _focusNode.unfocus(),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  AppImages.iconFilter,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    _Palette.searchHint,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _CampaignRow extends StatelessWidget {
  const _CampaignRow({
    required this.name,
    required this.subtitle,
    required this.logoUrl,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String? logoUrl;
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
                  color: Colors.white,
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
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: _Palette.chevron,
              ),
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
      color: _Palette.logoFallback,
      child: Icon(
        Icons.storefront_outlined,
        size: 28,
        color: _Palette.subtitleText,
      ),
    );
  }
}
