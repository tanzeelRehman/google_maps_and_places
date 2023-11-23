import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/models/get_direction_request_model.dart';
import '../../data/models/get_direction_response_model.dart';
import '../../data/repositories/direction_repository.dart';

class GetDirectionUsecase
    extends UseCase<GetDirectionResponseModel, GetDirectionRequestModel> {
  DirectionRepository repository;
  GetDirectionUsecase(this.repository);

  @override
  Future<Either<Failure, GetDirectionResponseModel>> call(
      GetDirectionRequestModel params) async {
    return await repository.getDirection(params);
  }
}
