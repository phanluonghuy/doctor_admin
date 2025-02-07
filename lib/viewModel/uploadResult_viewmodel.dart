import 'package:doctoradmin/models/appointmentModel.dart';
import 'package:doctoradmin/models/medicalRecordModel.dart';
import 'package:doctoradmin/models/testResultModel.dart';
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
  MedicalRecord? _medicalRecord;
  TestResult? _testResult;

  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _testNameController = TextEditingController();
  final TextEditingController _labNameController = TextEditingController();

  TextEditingController get diagnosisController => _diagnosisController;
  TextEditingController get notesController => _notesController;
  TextEditingController get testNameController => _testNameController;
  TextEditingController get labNameController => _labNameController;

  bool get loading => _loading;
  String get bookingId => _bookingId;
  String get medicalRecordId => _medicalRecordId;
  MedicalRecord? get medicalRecord => _medicalRecord;
  TestResult? get testResult => _testResult;

  set medicalRecord(MedicalRecord? value) {
    _medicalRecord = value;
  }

  set testResult(TestResult? value) {
    _testResult = value;
  }

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

  Future<void> createTestResults(BuildContext context, dynamic data) async {
    setLoading(true);
    _testRepository.createTestResults(data).then((value) {
      print(value);
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        setLoading(false);
        return;
      }
      _testResultId = value.data["_id"];
      Utils.flushBarSuccessMessage(value.message ?? "", context);
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  Future<void> uploadTestResults(
      BuildContext context, dynamic data, dynamic image) async {
    setLoading(true);
    print(_testResultId);
    _testRepository.uploadTestResults(_testResultId, data, image).then((value) {
      // print(value);
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

  Future<void> getTestResults(BuildContext context) async {
    setLoading(true);
    _testRepository.getTestResults(bookingId).then((value) {
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        diagnosisController.clear();
        notesController.clear();
        testNameController.clear();
        labNameController.clear();
        testResult = null;
        setLoading(false);
        return;
      }
      medicalRecord = MedicalRecord.fromJson(value.data["medicalRecord"]);
      testResult = TestResult.fromJson(value.data["testResult"]);

      diagnosisController.text = medicalRecord?.diagnosis ?? "";
      notesController.text = medicalRecord?.notes ?? "";
      testNameController.text = testResult?.testName ?? "";
      labNameController.text = testResult?.labDetails ?? "";
      // Utils.flushBarSuccessMessage(value.message ?? "", context);
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    _testNameController.dispose();
    _labNameController.dispose();
  }
}
