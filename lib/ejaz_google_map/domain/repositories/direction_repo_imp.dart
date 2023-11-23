import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/network/network_info.dart';
import '../../data/data_sources/direction_remote_data_source.dart';
import '../../data/models/get_direction_request_model.dart';
import '../../data/models/get_direction_response_model.dart';
import '../../data/repositories/direction_repository.dart';

class DirectionRepoImp extends DirectionRepository {
  final NetworkInfo networkInfo;

  final DirectionRemoteDataSource remoteDataSource;

  DirectionRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, GetDirectionResponseModel>> getDirection(
      GetDirectionRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getDirection(params));
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
