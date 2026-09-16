import 'package:dartz/dartz.dart';
import 'package:kamao/core/core.dart';
import '../entities/submission_entity.dart';
import '../repositories/post_repository.dart';

class GetPendingSubmissionsUseCase
    implements UseCase<List<SubmissionEntity>, NoParams> {
  GetPendingSubmissionsUseCase(this._repository);
  final PostRepository _repository;

  @override
  Future<Either<Failure, List<SubmissionEntity>>> call(NoParams params) {
    return _repository.getPendingSubmissions();
  }
}
