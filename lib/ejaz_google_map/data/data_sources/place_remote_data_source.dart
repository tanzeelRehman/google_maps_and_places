import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sb_myreports/core/utils/globals/globals.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_request_model.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_response_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/modals/error_response_model.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/constants/app_url.dart';

abstract class PlaceRemoteDataSource {
  Future<GetQueryPlaceResponseModel> getQueryPlace(
      GetQueryPlaceRequestModel params);
}

class PlaceRemoteDataSourceImp implements PlaceRemoteDataSource {
  Dio dio;
  PlaceRemoteDataSourceImp({required this.dio});

  @override
  Future<GetQueryPlaceResponseModel> getQueryPlace(
      GetQueryPlaceRequestModel params) async {
    String url = AppUrl.googleApisBaseUrl +
        AppUrl.queryPlaceUrl +
        '&input=${params.query}' +
        "&key=" +
        googleApiKey;
    try {
      final response = await dio.get(url);

      // var decryptedResponse = Encryption.decryptObject(response.data['Text']);
      // var jsonResponse = jsonDecode(decryptedResponse);

      if (response.statusCode == 200) {
        var object = GetQueryPlaceResponseModel.fromJson(response.data);

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
