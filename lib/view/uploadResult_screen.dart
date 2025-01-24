import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:doctoradmin/res/widgets/buttons/whitePrimaryButton.dart";
import "package:doctoradmin/res/widgets/coloors.dart";
import "package:doctoradmin/viewModel/uploadResult_viewmodel.dart";
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

class UploadResultScreen extends StatefulWidget {
  const UploadResultScreen({super.key});

  @override
  State<UploadResultScreen> createState() => _UploadResultScreenState();
}

class _UploadResultScreenState extends State<UploadResultScreen> {
  final ValueNotifier<XFile?> _imageXFile = ValueNotifier<XFile?>(null);

  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _testNameController = TextEditingController();
  final TextEditingController _labNameController = TextEditingController();

  final FocusNode _diagnosisFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();
  final FocusNode _testNameFocus = FocusNode();
  final FocusNode _labNameFocus = FocusNode();

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose Image"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        _imageXFile.value = pickedFile;
                      },
                      icon:
                          SvgPicture.asset('assets/buttons/icons8-gallery.svg'),
                    ),
                    Text("Gallery")
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.camera);
                        _imageXFile.value = pickedFile;
                      },
                      icon:
                          SvgPicture.asset('assets/buttons/icons8-camera.svg'),
                    ),
                    Text("Camera")
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final uploadViewModel = context.read<UploadResultViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Result"),
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
              Align(alignment: Alignment.centerLeft, child: Text("Diagnosis")),
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: _diagnosisController,
                focusNode: _diagnosisFocus,
                keyboardType: TextInputType.name,
                onFieldSubmitted: (value) {
                  Utils.changeNodeFocus(context,
                      current: _diagnosisFocus, next: _notesFocus);
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Diagnosis",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Align(alignment: Alignment.centerLeft, child: Text("Notes")),
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: _notesController,
                focusNode: _notesFocus,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 2,
                onFieldSubmitted: (value) {
                  Utils.changeNodeFocus(context,
                      current: _notesFocus, next: _testNameFocus);
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Notes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Align(alignment: Alignment.centerLeft, child: Text("Test Name")),
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: _testNameController,
                focusNode: _testNameFocus,
                keyboardType: TextInputType.name,
                onFieldSubmitted: (value) {
                  Utils.changeNodeFocus(context,
                      current: _testNameFocus, next: _labNameFocus);
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Test Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Align(alignment: Alignment.centerLeft, child: Text("Lab Name")),
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: _labNameController,
                focusNode: _labNameFocus,
                keyboardType: TextInputType.name,
                onFieldSubmitted: (value) {
                  Utils.changeNodeFocus(context,
                      current: _labNameFocus, next: _labNameFocus);
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Lab Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              ValueListenableBuilder<XFile?>(
                valueListenable: _imageXFile,
                builder: (context, value, child) {
                  if (value != null) {
                    return CircleAvatar(
                      radius: height * 0.08,
                      backgroundImage: FileImage(File(value.path)),
                    );
                  } else {
                    return SizedBox(
                      width: width * 0.5,
                      child: OutlinePrimaryButton(
                          text: "Upload Image",
                          onPressed: () {
                            getLostData();
                          }),
                    );
                  }
                },
              ),
              SizedBox(height: height * 0.02),
              PrimaryButton(
                  text: "Upload Result",
                  loading: uploadViewModel.loading,
                  onPressed: () {
                    if (_diagnosisController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Diagnosis is required", context);
                      _diagnosisFocus.requestFocus();
                      return;
                    }
                    if (_notesController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Notes is required", context);
                      _notesFocus.requestFocus();
                      return;
                    }
                    if (_testNameController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Test Name is required", context);
                      _testNameFocus.requestFocus();
                      return;
                    }
                    if (_labNameController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Lab Name is required", context);
                      _labNameFocus.requestFocus();
                      return;
                    }
                    if (_imageXFile.value == null) {
                      Utils.flushBarErrorMessage("Image is required", context);
                      return;
                    }
                    Map<String, String> data = {
                      "appointmentId":
                          context.read<UploadResultViewModel>().bookingId,
                      "diagnosis": _diagnosisController.text,
                      "notes": _notesController.text,
                    };
                    uploadViewModel.createMedicalRecords(context, data);
                    data = {
                      "medicalRecordId":
                          context.read<UploadResultViewModel>().medicalRecordId,
                      "testName": _testNameController.text,
                      "labDetails": _labNameController.text,
                    };
                    // uploadViewModel.createTestResults(context, data);
                    uploadViewModel.uploadTestResults(
                        context, data, _imageXFile.value);
                  },
                  context: context),
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
