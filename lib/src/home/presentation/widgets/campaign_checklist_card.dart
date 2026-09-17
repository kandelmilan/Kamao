import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';

/// “What you need to do” — Figma todo-card (#E6F0E4).
class CampaignChecklistCard extends StatelessWidget {
  const CampaignChecklistCard({super.key, required this.items});

  final List<CampaignChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0E4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A153B),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What you need to do',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.0,
              color: Color(0xFF353037),
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 18),
              child: _ChecklistRow(item: items[i]),
            ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final CampaignChecklistItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFDAE9D7),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppImages.campaignCheck,
            width: 12,
            height: 12,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF6E6971),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.value,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  height: 22 / 15,
                  color: Color(0xFF4A434D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
