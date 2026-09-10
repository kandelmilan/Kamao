import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/brand/domain/entities/brand_entity.dart';
import '../entities/brand_detail_entity.dart';

abstract class BrandRepository {
  Future<Either<Failure, BrandDetailEntity>> getBrandDetail(String brandId);
  Future<Either<Failure, List<BrandEntity>>> getPopularBrands({int take = 12});
  Future<Either<Failure, List<BrandEntity>>> getFeaturedBrands({int take = 12});
}
