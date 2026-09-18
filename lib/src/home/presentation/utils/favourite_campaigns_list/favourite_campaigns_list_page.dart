import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';
import 'package:kamao/src/home/domain/entities/campaign/favourite_campaign_entity.dart';
import 'package:remixicon/remixicon.dart';

typedef FavouriteCampaignsFetcher =
    Future<Either<Failure, List<FavouriteCampaignEntity>>> Function({
      required int take,
    });

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

/// Dedicated searchable favourites list — separate from [CampaignListPage].
class FavouriteCampaignsListPage extends StatefulWidget {
  const FavouriteCampaignsListPage({
    super.key,
    required this.fetcher,
    required this.onCampaignTap,
    this.title = 'Favourite Campaigns',
    this.take = 48,
    this.emptyMessage = 'No favourite campaigns yet',
  });

  final String title;
  final FavouriteCampaignsFetcher fetcher;
  final void Function(CampaignEntity campaign) onCampaignTap;
  final int take;
  final String emptyMessage;

  @override
  State<FavouriteCampaignsListPage> createState() =>
      _FavouriteCampaignsListPageState();
}

class _FavouriteCampaignsListPageState
    extends State<FavouriteCampaignsListPage> {
  final _items = <FavouriteCampaignEntity>[];
  var _loading = true;
  String? _error;
  String _query = '';
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.fetcher(take: widget.take);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _loading = false;
      }),
      (list) => setState(() {
        _items
          ..clear()
          ..addAll(list);
        _loading = false;
      }),
    );
  }

  List<String> get _categories {
    final names = <String>{};
    for (final item in _items) {
      final c = item.campaign.brandCategory?.trim();
      if (c != null && c.isNotEmpty) names.add(c);
    }
    final list = names.toList()..sort();
    return list;
  }

  List<FavouriteCampaignEntity> get _filtered {
    final q = _query.trim().toLowerCase();
    return _items.where((item) {
      final c = item.campaign;
      if (_categoryFilter != null &&
          (c.brandCategory ?? '').trim() != _categoryFilter) {
        return false;
      }
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.brandName.toLowerCase().contains(q) ||
          c.objective.toLowerCase().contains(q) ||
          (c.brandCategory ?? '').toLowerCase().contains(q);
    }).toList();
  }

  String _subtitleOf(CampaignEntity campaign) {
    final objective = campaign.objective.trim();
    if (objective.isNotEmpty) return objective;
    final category = campaign.brandCategory?.trim();
    if (category != null && category.isNotEmpty) return category;
    return campaign.earnRangeLabel;
  }

  Future<void> _openFilterSheet() async {
    final categories = _categories;
    if (categories.isEmpty) {
      Get.snackbar(
        'Filter',
        'No categories available yet',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final selected = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _Palette.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Filter by category',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _Palette.titleText,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'All campaigns',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _Palette.titleText,
                  ),
                ),
                trailing: _categoryFilter == null
                    ? const Icon(Icons.check, color: AppColors.seeAllGreen)
                    : null,
                onTap: () => Navigator.pop(context, ''),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == _categoryFilter;
                    return ListTile(
                      title: Text(
                        category,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _Palette.titleText,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColors.seeAllGreen,
                            )
                          : null,
                      onTap: () => Navigator.pop(context, category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() {
      _categoryFilter = selected.isEmpty ? null : selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.pageBg,
      body: DecoratedBox(
        decoration: const BoxDecoration(
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
              const SizedBox(height: 16),
              _SearchBar(
                onChanged: (v) => setState(() => _query = v),
                onFilter: _openFilterSheet,
                filterActive: _categoryFilter != null,
              ),
              if (_categoryFilter != null) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      label: Text(_categoryFilter!),
                      onDeleted: () => setState(() => _categoryFilter = null),
                      deleteIconColor: AppColors.seeAllGreen,
                      backgroundColor: AppColors.walletChipBg,
                      side: const BorderSide(color: AppColors.walletChipBorder),
                      labelStyle: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.seeAllGreen,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items.isEmpty) {
      return Center(
        child: TextButton(
          onPressed: _load,
          child: Text(
            _error!,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.seeAllGreen,
            ),
          ),
        ),
      );
    }

    final items = _filtered;
    if (items.isEmpty) {
      final hasFilters =
          _query.trim().isNotEmpty || _categoryFilter != null;
      return Center(
        child: Text(
          hasFilters
              ? 'No campaigns match your search'
              : widget.emptyMessage,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _Palette.subtitleText,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _Palette.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: _Palette.cardBorder),
          itemBuilder: (context, index) {
            final campaign = items[index].campaign;
            return _CampaignRow(
              name: campaign.brandName.isNotEmpty
                  ? campaign.brandName
                  : campaign.name,
              subtitle: _subtitleOf(campaign),
              logoUrl: resolveImageUrl(campaign.brandLogoUrl),
              onTap: () => widget.onCampaignTap(campaign),
            );
          },
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
    required this.onFilter,
    this.filterActive = false,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;
  final bool filterActive;

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
    widget.onChanged('');
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
            Icon(
              RemixIcons.search_line,
              size: 16,
              color: _focused ? AppColors.seeAllGreen : _Palette.searchHint,
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
                  hintText: 'Search favourite campaigns...',
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
              onTap: () {
                _focusNode.unfocus();
                widget.onFilter();
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  RemixIcons.filter_3_line,
                  size: 16,
                  color: widget.filterActive
                      ? AppColors.seeAllGreen
                      : _Palette.searchHint,
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
        Icons.campaign_outlined,
        size: 28,
        color: _Palette.subtitleText,
      ),
    );
  }
}
