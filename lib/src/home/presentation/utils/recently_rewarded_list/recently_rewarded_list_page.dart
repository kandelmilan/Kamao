import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/rewarded_post_entity.dart';

typedef RecentlyRewardedFetcher =
    Future<Either<Failure, List<RewardedPostEntity>>> Function({
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

class RecentlyRewardedListPage extends StatefulWidget {
  const RecentlyRewardedListPage({
    super.key,
    required this.fetcher,
    this.onPostTap,
    this.title = 'Recently Rewarded',
    this.take = 48,
    this.emptyMessage = 'No rewarded posts yet',
  });

  final String title;
  final RecentlyRewardedFetcher fetcher;
  final void Function(RewardedPostEntity post)? onPostTap;
  final int take;
  final String emptyMessage;

  @override
  State<RecentlyRewardedListPage> createState() =>
      _RecentlyRewardedListPageState();
}

class _RecentlyRewardedListPageState extends State<RecentlyRewardedListPage> {
  final _items = <RewardedPostEntity>[];
  var _loading = true;
  String? _error;
  String _query = '';

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

  List<RewardedPostEntity> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where(
          (p) =>
              p.brandName.toLowerCase().contains(q) ||
              p.campaignName.toLowerCase().contains(q) ||
              p.platform.toLowerCase().contains(q) ||
              (p.caption ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  String _subtitleOf(RewardedPostEntity post) {
    final amount = NumberFormat('#,##0.##').format(post.payoutAmount);
    final symbol = post.currency.toUpperCase() == 'NPR'
        ? 'रू '
        : '${post.currency} ';
    return '$symbol$amount · ${post.campaignName}';
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
              _SearchBar(onChanged: (v) => setState(() => _query = v)),
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
      return Center(
        child: Text(
          _query.trim().isNotEmpty
              ? 'No posts match your search'
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
            final post = items[index];
            return _RewardedRow(
              name: post.brandName,
              subtitle: _subtitleOf(post),
              logoUrl: post.brandLogoImageUrl,
              onTap: widget.onPostTap == null
                  ? null
                  : () => widget.onPostTap!(post),
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
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

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
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != _focused) {
        setState(() => _focused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
                  hintText: 'Search rewarded posts...',
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
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _RewardedRow extends StatelessWidget {
  const _RewardedRow({
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
              if (onTap != null)
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
        Icons.payments_outlined,
        size: 28,
        color: _Palette.subtitleText,
      ),
    );
  }
}
