import '../data/network/network_api_services.dart';
import '../data/response/api_response.dart';
import '../res/widgets/app_urls.dart';

class MyBookingRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> getAllBookingByPatientId(String doctorId) async {
    try {
      final response = await _network.getGetApiResponse(
          AppUrls.getMyAppointments(doctorId), false);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }

  Future<ApiResponse> updateCompletedStatus(
      String appointmentId, dynamic data) async {
    try {
      final response = await _network.getPatchApiResponse(
          AppUrls.updateCompletedStatus(appointmentId), data,
          isTokenRequired: false);
      return response;
    } catch (e) {
      rethrow; //Big Brain
    }
  }
}
