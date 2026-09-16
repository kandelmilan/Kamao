import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';

/// Anything that can hand back a page of items of type [T] — Popular,
/// New, Featured, category-filtered, brand-filtered search — satisfies
/// this signature, regardless of which concrete entity it returns.
typedef CampaignPageFetcher<T> =
    Future<Either<Failure, List<T>>> Function({
      required int page,
      required int take,
      String? search,
    });
