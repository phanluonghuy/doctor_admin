import 'package:doctoradmin/models/workScheduleModel.dart';
import 'package:doctoradmin/repository/user_repository.dart';
import 'package:doctoradmin/utils/utils.dart';
import 'package:doctoradmin/viewModel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkScheduleProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<Map<String, dynamic>> availableTimes = [];
  bool _isLoading = false;
  WorkSchedule? _workSchedule;

  WorkSchedule? get workSchedule => _workSchedule;

  set workSchedule(WorkSchedule? value) {
    _workSchedule = value;
  }

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAvailableTimes(List<Map<String, dynamic>> times) {
    availableTimes = times;
    notifyListeners();
  }

  void updateAvailableTime(int index, String key, dynamic value) {
    availableTimes[index][key] = value;
    notifyListeners();
  }

  void addRestTime(int index, String restTime) {
    availableTimes[index]["restTime"].add(restTime);
    notifyListeners();
  }

  void removeRestTime(int index, String restTime) {
    availableTimes[index]["restTime"].remove(restTime);
    notifyListeners();
  }

  void addAvailableTime() {
    availableTimes.add({
      "dayOfWeek": "Monday",
      "startTime": "09:00",
      "endTime": "17:00",
      "restTime": []
    });
    notifyListeners();
  }

  Future<void> getWorkSchedule(BuildContext context) async {
    _repository
        .getWorkSchedule(context.read<UserViewModel>().user?.id ?? "")
        .then((value) {
      setLoading(false);
      // print(value);
      if (value.acknowledgement == false) {
        Utils.flushBarErrorMessage(value.message ?? "", context);
        return;
      }
      availableTimes = [];
      _workSchedule = WorkSchedule.fromJson(value.data);
      _workSchedule?.availableTimes.forEach((element) {
        availableTimes.add({
          "dayOfWeek": toBeginningOfSentenceCase(element.dayOfWeek),
          "startTime": element.startTime,
          "endTime": element.endTime,
          "restTime": element.restTime
        });
      });
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context, isBottom: false);
      print(error);
      setLoading(false);
    });
  }

  Future<void> updateWorkSchedule(BuildContext context) async {
    setLoading(true);
    List<AvailableTime> times = [];
    availableTimes.forEach((element) {
      times.add(AvailableTime(
          dayOfWeek: element["dayOfWeek"].toLowerCase(),
          startTime: element["startTime"],
          endTime: element["endTime"],
          restTime: List<String>.from(element["restTime"])));
    });
    Map<String, dynamic> data = {
      "doctorId": context.read<UserViewModel>().user?.id,
      "availableTimes": times.map((e) => e.toJson()).toList()
    };
    _repository.updateWorkSchedule(data).then((value) {
      setLoading(false);
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
}
