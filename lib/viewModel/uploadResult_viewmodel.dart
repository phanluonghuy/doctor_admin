import 'package:doctoradmin/models/appointmentModel.dart';
import 'package:doctoradmin/repository/test_repository.dart';
import 'package:doctoradmin/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UploadResultViewModel with ChangeNotifier {
  final TestRepository _testRepository = TestRepository();
  String _bookingId = "";
  String _medicalRecordId = "";
  String _testResultId = "";
  bool _loading = false;

  bool get loading => _loading;
  String get bookingId => _bookingId;
  String get medicalRecordId => _medicalRecordId;

  set bookingId(String value) {
    _bookingId = value;
  }

  set medicalRecordId(String value) {
    _medicalRecordId = value;
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createMedicalRecords(BuildContext context, dynamic data) async {
    setLoading(true);
    _testRepository.createMedicalRecords(data).then((value) {
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        setLoading(false);
        return;
      }
      medicalRecordId = value.data["_id"];
      // Utils.flushBarSuccessMessage(value.message ?? "", context);
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  // Future<void> createTestResults(BuildContext context, dynamic data) async {
  //   setLoading(true);
  //   _testRepository.createTestResults(data).then((value) {
  //     if (value.acknowledgement == false) {
  //       Utils.flushBarErrorMessage(value.message ?? "", context);
  //       setLoading(false);
  //       return;
  //     }
  //     _testResultId = value.data["_id"];
  //     // Utils.flushBarSuccessMessage(value.message ?? "", context);
  //     setLoading(false);
  //   }).onError((error, stackTrace) {
  //     Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
  //     print(error);
  //     setLoading(false);
  //   });
  // }

  Future<void> uploadTestResults(
      BuildContext context, dynamic data, dynamic image) async {
    setLoading(true);
    _testRepository.uploadTestResults(_testResultId, data, image).then((value) {
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        setLoading(false);
        return;
      }
      Utils.flushBarSuccessMessage(value.message ?? "", context);
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }
}
