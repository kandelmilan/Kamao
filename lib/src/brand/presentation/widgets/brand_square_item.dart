import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:remixicon/remixicon.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import '../bindings/brand_detail_binding.dart';
import '../views/brand_detail_view.dart';

/// Circular brand tile for home brand rails (Figma 673:2593).
class BrandCircleItem extends StatelessWidget {
  const BrandCircleItem({
    super.key,
    required this.brand,
    this.onTap,
    this.width = 79,
  });

  final BrandEntity brand;
  final VoidCallback? onTap;

  /// Total tile width. Logo circle scales with this (design base: 79 / 72).
  final double width;

  @override
  Widget build(BuildContext context) {
    final circle = (width * 72 / 79).clamp(56.0, 72.0);
    final image = circle - 8;
    final iconSize = circle * 28 / 72;

    return InkWell(
      onTap: onTap ?? () => openBrandDetail(brand.id),
      borderRadius: BorderRadius.circular(circle / 2),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: circle,
              height: circle,
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
                  ? Icon(
                      RemixIcons.store_2_line,
                      size: iconSize,
                      color: AppColors.heading,
                    )
                  : SizedBox(
                      width: image,
                      height: image,
                      child: Image.network(
                        brand.logoImageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          RemixIcons.store_2_line,
                          size: iconSize,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              brand.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.15,
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
