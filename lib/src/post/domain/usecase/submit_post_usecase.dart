import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/submit_post_params.dart';
import '../repositories/post_repository.dart';

class SubmitPostUseCase implements UseCase<String, SubmitPostParams> {
  SubmitPostUseCase(this._repository);
  final PostRepository _repository;

  @override
  Future<Either<Failure, String>> call(SubmitPostParams params) {
    return _repository.submitPost(params);
  }
}
