import 'package:doctoradmin/data/network/network_api_services.dart';
import 'package:doctoradmin/data/response/api_response.dart';
import 'package:doctoradmin/res/widgets/app_urls.dart';

class TestRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> createMedicalRecords(dynamic data) async {
    try {
      final response = await _network.getPostApiResponse(
          AppUrls.createMedicalRecords, data,
          isTokenRequired: false);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }

  Future<ApiResponse> createTestResults(dynamic data) async {
    try {
      final response = await _network.getPostApiResponse(
          AppUrls.createTestResults, data,
          isTokenRequired: false);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }

  Future<ApiResponse> uploadTestResults(
      String id, dynamic data, dynamic image) async {
    try {
      final response = await _network.getPostApiResponseOnlyFile(
          AppUrls.uploadTestResults(id), "result-file", data, image,
          isTokenRequired: false);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }


  Future<ApiResponse> getTestResults(String id) async {
    try {
      final response = await _network.getGetApiResponse(AppUrls.getTestResult(id), false);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }
}
