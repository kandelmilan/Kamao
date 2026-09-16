import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:remixicon/remixicon.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import '../bindings/brand_detail_binding.dart';
import '../views/brand_detail_view.dart';

/// Circular brand tile for home brand rails (Figma 673:2593).
class BrandCircleItem extends StatelessWidget {
  const BrandCircleItem({super.key, required this.brand, this.onTap});

  final BrandEntity brand;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => openBrandDetail(brand.id),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 79,
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              child: brand.logoImageUrl == null
                  ? const Icon(
                      RemixIcons.store_2_line,
                      size: 28,
                      color: AppColors.heading,
                    )
                  : SizedBox(
                      width: 64,
                      height: 64,
                      child: Image.network(
                        brand.logoImageUrl!,
                        fit: BoxFit.contain,
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.brandName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legacy square tile — kept for callers outside home.
class BrandSquareItem extends StatelessWidget {
  const BrandSquareItem({super.key, required this.brand});

  final BrandEntity brand;

  @override
  Widget build(BuildContext context) => BrandCircleItem(brand: brand);
}

void openBrandDetail(String brandId) {
  Get.to(
    () => BrandDetailView(brandId: brandId),
    binding: BrandDetailBinding(brandId: brandId),
  );
}
