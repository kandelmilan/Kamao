import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:remixicon/remixicon.dart';
import '../../domain/entities/brand_profile_entity.dart';
// This file only needs BrandEntity for the tile itself — swap the
// import below for wherever your existing BrandEntity actually lives.
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import '../bindings/brand_detail_binding.dart';
import '../views/brand_detail_view.dart';

/// Square tile for a "Popular Brands" rail — same visual language as
/// HomeView's `_CampaignSquareItem`. Tapping it opens the full brand
/// detail screen.
class BrandSquareItem extends StatelessWidget {
  const BrandSquareItem({super.key, required this.brand});

  final BrandEntity brand;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openBrandDetail(brand.id),
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 79,
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFF4F4F4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: brand.logoImageUrl == null
                  ? const Icon(
                      RemixIcons.store_2_line,
                      size: 28,
                      color: AppColors.heading,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        brand.logoImageUrl!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              RemixIcons.store_2_line,
                              size: 28,
                              color: AppColors.heading,
                            ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              brand.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation helper — call this from wherever a brand gets tapped
/// (this tile, a favourites list, etc.) instead of duplicating the
/// Get.to/binding pair at each call site.
///
/// TODO: if the app already uses named routes (Get.toNamed with a
/// Routes/AppPages table) rather than direct Get.to, register
/// BrandDetailView + BrandDetailBinding there instead and replace
/// this with a Get.toNamed call, so back-button/deep-link behavior
/// stays consistent with the rest of the app.
void openBrandDetail(String brandId) {
  Get.to(
    () => BrandDetailView(brandId: brandId),
    binding: BrandDetailBinding(brandId: brandId),
  );
}
