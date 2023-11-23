import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sb_myreports/core/utils/globals/globals.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/modals/error_response_model.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../models/get_direction_request_model.dart';
import '../models/get_direction_response_model.dart';

abstract class DirectionRemoteDataSource {
  Future<GetDirectionResponseModel> getDirection(
      GetDirectionRequestModel params);
}

class DirectionRemoteDataSourceImp implements DirectionRemoteDataSource {
  Dio dio;
  DirectionRemoteDataSourceImp({required this.dio});

  @override
  Future<GetDirectionResponseModel> getDirection(
      GetDirectionRequestModel params) async {
    String url = AppUrl.googleApisBaseUrl +
        AppUrl.directionUrl +
        'origin=${params.source.latitude},${params.source.longitude}' +
        '&destination=${params.destination.latitude},${params.destination.longitude}' +
        "&key=" +
        googleApiKey;
    print(url);
    try {
      final response = await dio.get(url);

      // var decryptedResponse = Encryption.decryptObject(response.data['Text']);
      // var jsonResponse = jsonDecode(decryptedResponse);

      if (response.statusCode == 200) {
        var object = GetDirectionResponseModel.fromJson(response.data);

        // var object = GetPaymentRateListResponse.fromJson(jsonResponse);

        return object;
      }

      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().i('returning error');
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        // var decryptedResponse = Encryption.decryptObject(exception.response?.data['Text']);
        // var jsonResponse = jsonDecode(decryptedResponse);
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }
}
