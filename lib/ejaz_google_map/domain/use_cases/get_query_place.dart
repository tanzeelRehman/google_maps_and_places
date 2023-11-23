import 'package:dartz/dartz.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_request_model.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_response_model.dart';
import 'package:sb_myreports/features/google_map/data/repositories/place_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';

class GetQueryPlaceUsecase
    extends UseCase<GetQueryPlaceResponseModel, GetQueryPlaceRequestModel> {
  PlaceRepository repository;
  GetQueryPlaceUsecase(this.repository);

  @override
  Future<Either<Failure, GetQueryPlaceResponseModel>> call(
      GetQueryPlaceRequestModel params) async {
    return await repository.getQueryPlace(params);
  }
}
