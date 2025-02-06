import 'package:doctoradmin/data/response/status.dart';
import 'package:doctoradmin/models/medicalRecordModel.dart';
import 'package:doctoradmin/models/medicineModel.dart';
import 'package:doctoradmin/repository/prescription_repository.dart';
import 'package:doctoradmin/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class PrescriptionsViewModel with ChangeNotifier {
  final PrescriptionRepository _prescriptionRepository =
      PrescriptionRepository();
  final List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;
  String _medicineIds = "";
  int _amountPerDose = 0;
  int _frequency = 0;
  String _time = "";
  String _timeDescription = "";
  int _duration = 0;
  bool _loading = false;
  String _bookingId = "";
  MedicalRecord? _medicalRecord;
  bool _error = false;
  List<String> _selectedTimes = [];
  final List<String> _options = ["Morning", "Afternoon", "Evening", "Night"];
  String _dosageId = "";

  List<String> get options => _options;

  List<String> get selectedTimes => _selectedTimes;

  set selectedTimes(List<String> value) {
    _selectedTimes = value;
    notifyListeners();
  }

  Future<void> getAllMedicine(BuildContext context) async {
    if (_medicines.isNotEmpty) {
      return;
    }
    setLoading(true);
    _prescriptionRepository.getAllMedicine().then((value) {
      setLoading(false);
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        return;
      }
      value.data.forEach((element) {
        _medicines.add(Medicine.fromJson(element));
      });
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  Future<void> getMedicalRecordsByAppointment(BuildContext context) async {
    setLoading(true);
    _prescriptionRepository
        .getMedicalRecordsByAppointment(_bookingId)
        .then((value) {
      setLoading(false);
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        return;
      }
      _medicalRecord = MedicalRecord.fromJson(value.data[0]);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  Future<void> createDosages(BuildContext context, dynamic data) async {
    setLoading(true);
    _prescriptionRepository.createDosages(data).then((value) {
      setLoading(false);
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        return;
      }

      // Utils.flushBarSuccessMessage(value.message ?? "", context);
      _dosageId = value.data["_id"];
      // print(_dosageId);
      createPrescriptions(context);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }


  Future<void> createPrescriptions(BuildContext context) async {
    Map<String,dynamic> data = {
      "medicalRecordId": _medicalRecord?.id,
      // TODO : Add the medicine ids
      "dosageDetails" : [_dosageId]
    };
    setLoading(true);
    _prescriptionRepository.createPrescriptions(data).then((value) {
      setLoading(false);
      // print(value);
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        return;
      }

      Utils.flushBarSuccessMessage(value.message ?? "", context);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  // Future<void> getDosages(BuildContext context) async {
  //   setLoading(true);
  //   _prescriptionRepository.getDosages(_bookingId).then((value) {
  //     setLoading(false);
  //     if (value.acknowledgement == false) {
  //       Utils.flushBarErrorMessage(value.message ?? "", context);
  //       return;
  //     }
  //     _dosageId = value.data[0]["_id"];
  //   }).onError((error, stackTrace) {
  //     Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
  //     print(error);
  //     setLoading(false);
  //   });
  // }

  MedicalRecord? get medicalRecord => _medicalRecord;

  set medicalRecord(MedicalRecord? value) {
    _medicalRecord = value;
  }

  String get bookingId => _bookingId;

  set bookingId(String value) {
    _bookingId = value;
  }

  String get medicineIds => _medicineIds;

  set medicineIds(String value) {
    _medicineIds = value;
  }

  int get amountPerDose => _amountPerDose;

  set amountPerDose(int value) {
    _amountPerDose = value;
  }

  int get frequency => _frequency;

  set frequency(int value) {
    _frequency = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get timeDescription => _timeDescription;

  set timeDescription(String value) {
    _timeDescription = value;
  }

  int get duration => _duration;

  set duration(int value) {
    _duration = value;
  }

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
