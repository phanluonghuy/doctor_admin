import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:doctoradmin/models/qualificationModel.dart";
import "package:doctoradmin/res/texts/app_text.dart";
import "package:doctoradmin/res/widgets/coloors.dart";
import "package:doctoradmin/utils/List_Helper.dart";
import "package:doctoradmin/viewModel/editSpecialization_viewmodel.dart";
import "package:doctoradmin/viewModel/user_viewmodel.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";
import "package:image_picker/image_picker.dart";
import "package:phone_form_field/phone_form_field.dart";
import "package:provider/provider.dart";

import "../res/widgets/buttons/backButton.dart";
import "../res/widgets/buttons/primaryButton.dart";
import "../res/widgets/datePicker.dart";
import "../utils/regex.dart";
import "../utils/utils.dart";

class EditSpecializationScreen extends StatefulWidget {
  const EditSpecializationScreen({super.key});

  @override
  State<EditSpecializationScreen> createState() =>
      _EditSpecializationScreenState();
}

class _EditSpecializationScreenState extends State<EditSpecializationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpecializationViewModel>().getCurrentDoctorInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final doctorViewModel = context.watch<SpecializationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Specialization"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: CustomBackButton(
            onPressed: () {
              context.pop(); // This will navigate to the 'Bookings' screen
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Specialization")),
              SizedBox(height: height * 0.01),
              doctorViewModel.isQueue
                  ? CircularProgressIndicator()
                  : DropdownMenu(
                      hintText: "Select Your Category",
                      width: double.infinity,
                      initialSelection: doctorViewModel
                          .doctorBooking
                          ?.specialization
                          .specializations
                          .first, // Default selection
                      dropdownMenuEntries: CategoryList.entries.map((entry) {
                        return DropdownMenuEntry(
                            label: entry.key,
                            value: entry.key,
                            leadingIcon: SvgPicture.asset(
                              entry.value,
                              height: 16,
                            ));
                      }).toList(),
                      onSelected: (value) {},
                    ),
              SizedBox(height: height * 0.02),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Qualifications")),
              SizedBox(height: height * 0.01),
              doctorViewModel.isQueue
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: doctorViewModel
                          .doctorBooking?.specialization.qualifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        final qualification = doctorViewModel
                            .doctorBooking?.specialization.qualifications
                            .elementAt(index);
                        return ListTile(
                          title: Text(qualification?.degree ?? "",
                              style: AppTextStyle.subtitle
                                  .copyWith(color: AppColors.primaryColor)),
                          subtitle: Text(qualification?.institution ?? ""),
                          leading: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.school_rounded
                              ),
                              Text(qualification?.year.toString() ?? "")
                            ],
                          ),
                        );
                      }),
              SizedBox(height: height * 0.02),
              // PrimaryButton(
              //     text: "Update Profile",
              //     loading: doctorViewModel.loading,
              //     onPressed: () {},
              //     context: context),
              SizedBox(height: height * 0.02),
            ],
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
