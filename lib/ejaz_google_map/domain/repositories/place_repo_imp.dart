import 'package:dartz/dartz.dart';
import 'package:sb_myreports/features/google_map/data/data_sources/place_remote_data_source.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_request_model.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_response_model.dart';
import 'package:sb_myreports/features/google_map/data/repositories/place_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/network/network_info.dart';

class PlaceRepoImp extends PlaceRepository {
  final NetworkInfo networkInfo;

  final PlaceRemoteDataSource remoteDataSource;

  PlaceRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, GetQueryPlaceResponseModel>> getQueryPlace(
      GetQueryPlaceRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getQueryPlace(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
}

/// Status codes
/// 200
/// 400, 500
