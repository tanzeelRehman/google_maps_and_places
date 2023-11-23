import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/get_direction_request_model.dart';
import '../models/get_direction_response_model.dart';

abstract class DirectionRepository {
  Future<Either<Failure, GetDirectionResponseModel>> getDirection(
      GetDirectionRequestModel params);
}
