import 'package:doctoradmin/data/network/network_api_services.dart';
import 'package:doctoradmin/data/response/api_response.dart';
import 'package:doctoradmin/res/widgets/app_urls.dart';

class PrescriptionRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> getAllMedicine() async {
    try {
      final response = await _network.getGetApiResponse(
          AppUrls.getAllMedicine, false);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> getMedicalRecordsByAppointment(String appointmentId) async {
    try {
      final response = await _network.getGetApiResponse(
          AppUrls.getMedicalRecordsByAppointment(appointmentId), false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<ApiResponse> createDosages(dynamic data) async {
    try {
      final response = await _network.getPostApiResponse(
          AppUrls.createDosages, data,
          isTokenRequired: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<ApiResponse> createPrescriptions(dynamic data) async {
    try {
      final response = await _network.getPostApiResponse(
          AppUrls.createPrescription, data,
          isTokenRequired: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
