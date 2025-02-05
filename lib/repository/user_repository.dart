import 'package:doctoradmin/data/network/network_api_services.dart';
import 'package:doctoradmin/res/widgets/app_urls.dart';

import '../data/response/api_response.dart';

class UserRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> getProfile() async {
    try {
      final response = await _network.getGetApiResponse(AppUrls.getMe, true);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }

  Future<ApiResponse> updateProfile(
      Map<String, dynamic> data, dynamic image) async {
    try {
      final response = await _network.getPostApiResponseWithFile(
          AppUrls.updateProfile, data, image,
          isTokenRequired: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> changePassword(Map<String, dynamic> data) async {
    try {
      final response = await _network.getPostApiResponse(
          AppUrls.changePassword, data,
          isTokenRequired: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendOTP(dynamic data) async {
    try {
      final response =
          await _network.getPostApiResponse(AppUrls.sendForgotOTP, data);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }

  Future<dynamic> verifyOTP(dynamic data) async {
    try {
      final response =
          await _network.getPostApiResponse(AppUrls.verifyForgotOTP, data);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }

  Future<ApiResponse> resetPassword(Map<String, dynamic> data) async {
    try {
      final response = await _network.getPostApiResponse(
          AppUrls.resetPassword, data,
          isTokenRequired: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> getWorkSchedule(String id) async {
    try {
      final response = await _network.getGetApiResponse(AppUrls.getWorkSchedule(id), true);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }
  Future<ApiResponse> updateWorkSchedule(Map<String, dynamic> data) async {
    try {
      final response = await _network.getPostApiResponse(AppUrls.updateWorkSchedule, data, isTokenRequired: true);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }
}
