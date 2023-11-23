import 'package:dartz/dartz.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_request_model.dart';

import '../../../../core/error/failures.dart';
import '../models/get_query_place_response_model.dart';

abstract class PlaceRepository {
  Future<Either<Failure, GetQueryPlaceResponseModel>> getQueryPlace(
      GetQueryPlaceRequestModel params);
}
