import 'package:doctoradmin/models/doctorBookingModel.dart';
import 'package:doctoradmin/repository/doctor_repository.dart';
import 'package:doctoradmin/utils/utils.dart';
import 'package:doctoradmin/viewModel/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SpecializationViewModel with ChangeNotifier {
  final _doctorRepository = DoctorRepository();

  DoctorBooking? doctorBooking;
  bool _loading = false;
  bool _isQueue = false;

  get loading => _loading;
  get isQueue => _isQueue;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setQueue(bool value) {
    _isQueue = value;
    notifyListeners();
  }

  Future<void> getCurrentDoctorInfo(BuildContext context) async {
    setQueue(true);
    String id =
        Provider.of<UserViewModel>(context, listen: false).user?.id ?? "";
    _doctorRepository.getDoctorById(id).then((value) {
      setQueue(false);
      // print(value.toString());
      if (value.acknowledgement == false) {
        // Utils.flushBarErrorMessage(value.description ?? "", context);
        return;
      }
      print(value);
      doctorBooking = DoctorBooking.fromJson(value.data);
    }).onError((error, stackTrace) {
      // Utils.flushBarErrorMessage(error.toString(), context);
      print(error.toString());
      setQueue(false);
    });
  }
}
