import 'package:flutter/material.dart';
import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';

/// Renders the "What you need to do" card: one row per checklist item,
/// each with a check icon, an uppercase label, and its value.
///
/// Built entirely from [items] (see [CampaignDetailEntity.checklistItems]),
/// so it stays in sync with whatever directives a campaign has — no
/// hardcoded fields, no page-level changes needed for new directive types.
class CampaignChecklistCard extends StatelessWidget {
  const CampaignChecklistCard({super.key, required this.items});

  final List<CampaignChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 20),
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
          decoration: const BoxDecoration(
            color: Color(0xFFE6FBF3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Color(0xFF10B981), size: 14),
        ),
        const SizedBox(width: 12),
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
