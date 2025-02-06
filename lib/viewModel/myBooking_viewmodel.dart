import 'package:doctoradmin/models/appointmentModel.dart';
import 'package:doctoradmin/repository/mybooking_repository.dart';
import 'package:doctoradmin/viewModel/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class MyBookingViewModel with ChangeNotifier {
  final MyBookingRepository _myBookingRepository = MyBookingRepository();
  final List<Appointment> _appointments = [];
  bool _loading = false;
  bool _isQuerying = false;

  bool get loading => _loading;
  bool get isQuerying => _isQuerying;

  List<Appointment> get appointments => _appointments;

  List<Appointment> get confirmedAppointments =>
      _appointments.where((element) => element.status == "confirmed").toList();

  List<Appointment> get pendingAppointments =>
      _appointments.where((element) => element.status == "pending").toList();

  List<Appointment> get completedAppointments =>
      _appointments.where((element) => element.status == "completed").toList();

  List<Appointment> get cancelledAppointments =>
      _appointments.where((element) => element.status == "cancelled").toList();

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setQuerying(bool value) {
    _isQuerying = value;
    notifyListeners();
  }

  Future<void> getAllBooking(BuildContext context) async {
    setLoading(true);
    _myBookingRepository
        .getAllBookingByPatientId(context.read<UserViewModel>().user!.id)
        .then((value) {
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.description ?? "", context);
        setLoading(false);
        return;
      }
      value.data.forEach((appointment) {
        _appointments.add(Appointment.fromJson(appointment));
      });
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  Future<void> updateStatus(
      BuildContext context, String appointmentId, dynamic status) async {
    setQuerying(true);
    _myBookingRepository
        .updateCompletedStatus(appointmentId, status)
        .then((value) {
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.description ?? "", context);
        setQuerying(false);
        return;
      }
      _appointments
          .firstWhere((element) => element.id == appointmentId)
          .status = value.data['status'];
      if (value.data['status'] == "completed") {
        Utils.flushBarSuccessMessage(value.message ?? "", context,
            isBottom: false);
      } else {
        Utils.flushBarErrorMessage(value.message ?? "", context,
            isBottom: false);
      }

      setQuerying(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setQuerying(false);
    });
  }
}
