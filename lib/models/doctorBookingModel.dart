import 'package:doctoradmin/models/reviewModel.dart';
import 'package:doctoradmin/models/specializationModel.dart';
import 'package:doctoradmin/models/userModel.dart';
import 'package:doctoradmin/models/workScheduleModel.dart';

class DoctorBooking {
  final User doctor;
  final Specialization specialization;
  final WorkSchedule workSchedule;
  final Review review;

  DoctorBooking({
    required this.doctor,
    required this.specialization,
    required this.workSchedule,
    required this.review,
  });

  factory DoctorBooking.fromJson(Map<String, dynamic> json) {
    return DoctorBooking(
      doctor: User.fromJson(json['doctor']),
      specialization: Specialization.fromJson(json['specializations']),
      workSchedule: WorkSchedule.fromJson(json['workSchedule']),
      review: Review.fromJson(json['review']),
    );
  }
}
