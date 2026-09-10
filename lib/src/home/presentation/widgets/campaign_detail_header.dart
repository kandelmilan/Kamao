import 'package:flutter/material.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';
import 'package:remixicon/remixicon.dart';

class CampaignDetailHeader extends StatelessWidget {
  const CampaignDetailHeader({
    super.key,
    required this.campaign,
    required this.isFavourite,
    required this.isTogglingFavourite,
    required this.onBack,
    required this.onShare,
    required this.onBookmark,
  });

  final CampaignDetailEntity campaign;
  final bool isFavourite;
  final bool isTogglingFavourite;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onBookmark;

  static const Map<String, IconData> _platformIcons = {
    'instagram': RemixIcons.instagram_line,
    'tiktok': RemixIcons.tiktok_fill,
    'facebook': RemixIcons.facebook_fill,
    'youtube': RemixIcons.youtube_line,
  };

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isBookmarked = campaign.isFavourite;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 28,
        top: topPadding + 12,
      ),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.59, 0.23),
          radius: 1.24,
          colors: [Color(0xFF6F338D), Color(0xFF3E0163)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(icon: RemixIcons.arrow_left_line, onTap: onBack),
              Row(
                children: [
                  _circleButton(icon: RemixIcons.share_2_line, onTap: onShare),
                  const SizedBox(width: 10),
                  _circleButton(
                    icon: isBookmarked
                        ? RemixIcons.bookmark_fill
                        : RemixIcons.bookmark_line,
                    onTap: onBookmark,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            campaign.brandName.isNotEmpty ? campaign.brandName : 'Campaign',
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 26,
              height: 32 / 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (campaign.brandTagline.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              campaign.brandTagline,
              style: const TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                campaign.earnRangeLabel,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF3DFF84),
                  fontSize: 14,
                  height: 1.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (campaign.purchaseProofRequired) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '•',
                    style: TextStyle(
                      color: Color(0xFF3DFF84),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Text(
                  'Receipt required',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFF3DFF84),
                    fontSize: 14,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          if (campaign.platforms.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Post on :  ',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFFEDE6F1),
                    fontSize: 14,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: campaign.platforms.map(_platformChip).toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _platformChip(String platformId) {
    final icon = _platformIcons[platformId.toLowerCase()];
    final label = platformId.isEmpty
        ? ''
        : platformId[0].toUpperCase() + platformId.substring(1).toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 12,
              height: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
