import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import '../entities/brand_detail_entity.dart';

class BrandQueryParams {
  const BrandQueryParams({this.take = 48, this.category, this.sort});

  final int take;
  final String? category;
  final String? sort;
}

abstract class BrandRepository {
  Future<Either<Failure, BrandDetailEntity>> getBrandDetail(String brandId);

  Future<Either<Failure, List<BrandEntity>>> getBrands(BrandQueryParams params);

  Future<Either<Failure, List<BrandEntity>>> getPopularBrands({int take = 12});

  Future<Either<Failure, List<BrandEntity>>> getFeaturedBrands({int take = 12});

  Future<Either<Failure, List<BrandEntity>>> getRecentBrands({int take = 12});

  Future<Either<Failure, List<BrandEntity>>> getFavouriteBrands({
    int take = 48,
  });

  /// Records a brand view so it appears in recent brands.
  Future<Either<Failure, bool>> viewBrand(String brandId);

  /// Favourites the brand. Returns the new `isFavourite` value (true).
  Future<Either<Failure, bool>> favouriteBrand(String brandId);

  /// Removes favourite. Returns the new `isFavourite` value (false).
  Future<Either<Failure, bool>> unfavouriteBrand(String brandId);
}
