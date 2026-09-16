import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/submission_entity.dart';
import '../repositories/post_repository.dart';

class GetApprovedSubmissionsUseCase
    implements UseCase<List<SubmissionEntity>, NoParams> {
  GetApprovedSubmissionsUseCase(this._repository);
  final PostRepository _repository;

  @override
  Future<Either<Failure, List<SubmissionEntity>>> call(NoParams params) {
    return _repository.getApprovedSubmissions();
  }
}
