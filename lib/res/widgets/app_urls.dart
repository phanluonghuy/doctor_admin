class AppUrls {
  static const socketUrl = "ws://192.168.1.13:8080";
  static const baseUrl = "http://192.168.1.13:8080/api";
  static const loginEndPoint = "$baseUrl/user/sign-in";
  static const registerEndPoint = "$baseUrl/user/sign-up";
  static const sendOTP = "$baseUrl/user/getOTP";
  static const sendForgotOTP = "$baseUrl/user/getForgotOTP";
  static const verifyOTP = "$baseUrl/user/verifyOTP";
  static const verifyForgotOTP = "$baseUrl/user/verifyForgotOTP";
  static const getMe = "$baseUrl/user/me";
  static const updateProfile = "$baseUrl/user/update-profile";
  static const changePassword = "$baseUrl/user/reset-password";
  static const resetPassword = "$baseUrl/user/change-password";

  static const getDoctors = "$baseUrl/user/doctorsInfo";

  static const getTopDoctors = "$baseUrl/user/getTopDoctors";
  static var getDoctorById =
      (String id) => "$baseUrl/user/doctor/$id/full-info";
  static const createAppointment = "$baseUrl/appointment";

  static var getMyAppointments =
      (String patientId) => "$baseUrl/appointment/doctor/$patientId";

  static const createPayment = "$baseUrl/payment";
  static const getNearestAppointment =
      "$baseUrl/appointment/appointment/nearest";


  static var getConversationsByUserId = (String userId) => "$baseUrl/conversation/$userId";
  static const uploadFileImage = "$baseUrl/conversation/image";
  static var getUpdateConversation = (String conversationId) => "$baseUrl/conversation/update/$conversationId/update";
  static const createConversation = "$baseUrl/conversation";

  static var updateCompletedStatus =
      (String appointmentId) => "$baseUrl/appointment/$appointmentId/status";

  static const createMedicalRecords = "$baseUrl/medical-record";
  static const createTestResults = "$baseUrl/test-result";
  static var uploadTestResults =
      (String testResultId) => "$baseUrl/test-result/$testResultId/upload";
  static var getTestResult =
      (String testResultId) => "$baseUrl/medical-record/$testResultId";

  static const getAllMedicine = "$baseUrl/medicine";
  static var getMedicalRecordsByAppointment =
      (String appointmentId) => "$baseUrl/medical-record/appointment/$appointmentId";
  static const createDosages = "$baseUrl/dosage";
  static const createPrescription = "$baseUrl/prescription";

  static var getWorkSchedule = (String id) => "$baseUrl/work-schedule/doctor/$id";

  static const updateWorkSchedule = "$baseUrl/work-schedule";

}

//testerpayment@test.com
//Admin@123
