import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

abstract class UseCase<R, P> {
  Future<Either<Failure, R>> call(P params);
}

class Params<T> extends Equatable {
  const Params({required this.data});

  final T data;

  @override
  List<Object?> get props => [data];
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
