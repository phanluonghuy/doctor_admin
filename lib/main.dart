import 'package:doctoradmin/res/widgets/coloors.dart';
import 'package:doctoradmin/utils/routes.dart';
import 'package:doctoradmin/viewModel/NavigationProvider.dart';
import 'package:doctoradmin/viewModel/auth_viewmodel.dart';
import 'package:doctoradmin/viewModel/doctorBooking_viewmodel.dart';
import 'package:doctoradmin/viewModel/doctor_viewmodel.dart';
import 'package:doctoradmin/viewModel/editSpecialization_viewmodel.dart';
import 'package:doctoradmin/viewModel/myBooking_viewmodel.dart';
import 'package:doctoradmin/viewModel/prescriptions_viewmodel.dart';
import 'package:doctoradmin/viewModel/signup_viewmodel.dart';
import 'package:doctoradmin/viewModel/uploadResult_viewmodel.dart';
import 'package:doctoradmin/viewModel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => DoctorViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (_) => DoctorBookingViewModel(), lazy: true),
        ChangeNotifierProvider(
            create: (_) => UploadResultViewModel(), lazy: true),
        ChangeNotifierProvider(
            create: (_) => SpecializationViewModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => PrescriptionsViewModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => MyBookingViewModel(), lazy: true),
        ChangeNotifierProvider(create: (_) => SignUpViewModel(), lazy: true),
      ],
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: MaterialApp.router(
          title: 'Book Appointment',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            textTheme: GoogleFonts.interTextTheme(),
          ),
          routerConfig: router, // Use the GoRouter instance
        ),
      ),
    );
  }
}
