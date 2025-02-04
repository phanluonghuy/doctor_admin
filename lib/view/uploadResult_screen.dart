import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:doctoradmin/models/testResultModel.dart";
import "package:doctoradmin/res/widgets/buttons/whitePrimaryButton.dart";
import "package:doctoradmin/res/widgets/coloors.dart";
import "package:doctoradmin/viewModel/uploadResult_viewmodel.dart";
import "package:doctoradmin/viewModel/user_viewmodel.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";
import "package:image_picker/image_picker.dart";
import "package:phone_form_field/phone_form_field.dart";
import "package:photo_view/photo_view.dart";
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
    final uploadViewModel = context.read<UploadResultViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      uploadViewModel.getTestResults(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final uploadViewModel = context.watch<UploadResultViewModel>();

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
                controller: uploadViewModel.diagnosisController,
                focusNode: _diagnosisFocus,
                keyboardType: TextInputType.name,
                onFieldSubmitted: (value) {
                  Utils.changeNodeFocus(context,
                      current: _diagnosisFocus, next: _notesFocus);
                },
                onChanged: (value) {
                  uploadViewModel.medicalRecord?.diagnosis = value;
                },
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
                controller: uploadViewModel.notesController,
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
                controller: uploadViewModel.testNameController,
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
                controller: uploadViewModel.labNameController,
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
              Center(
                  child: Stack(
                children: [
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
                          width: height * 0.16,
                          height: height * 0.16,
                          child: CachedNetworkImage(
                            imageUrl:
                                uploadViewModel.testResult?.results?.url ?? "",
                            imageBuilder: (context, imageProvider) => InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            title: Text("Image"),
                                          ),
                                          body: Center(
                                              child: PhotoView(
                                                  imageProvider:
                                                      imageProvider)),
                                        )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                                Icons.document_scanner_rounded,
                                size: height * 0.08,
                                color: Colors.grey.shade800),
                          ),
                        );
                      }
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: height *
                          0.05, // Diameter of the CircleAvatar + border
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        // radius: height * 0.03,
                        backgroundColor: AppColors.primaryColor,
                        child: IconButton(
                            onPressed: () {
                              // Add the code to pick an image from the gallery
                              getLostData();
                            },
                            icon: Icon(
                              Icons.edit_rounded,
                              size: height * 0.02,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(height: height * 0.02),
              PrimaryButton(
                  text: "Upload Result",
                  loading: uploadViewModel.loading,
                  onPressed: () {
                    if (uploadViewModel.diagnosisController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Diagnosis is required", context);
                      _diagnosisFocus.requestFocus();
                      return;
                    }
                    if (uploadViewModel.notesController.text.isEmpty) {
                      Utils.flushBarErrorMessage("Notes is required", context);
                      _notesFocus.requestFocus();
                      return;
                    }
                    if (uploadViewModel.testNameController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Test Name is required", context);
                      _testNameFocus.requestFocus();
                      return;
                    }
                    if (uploadViewModel.labNameController.text.isEmpty) {
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
                      "diagnosis": uploadViewModel.diagnosisController.text,
                      "notes": uploadViewModel.notesController.text,
                    };
                    uploadViewModel.createMedicalRecords(context, data);
                    data = {
                      "medicalRecordId":
                          context.read<UploadResultViewModel>().medicalRecordId,
                      "testName": uploadViewModel.testNameController.text,
                      "labDetails": uploadViewModel.labNameController.text,
                    };
                    uploadViewModel.createTestResults(context, data);
                    // TODO : Bug image required when updating test results
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
    _diagnosisFocus.dispose();
    _notesFocus.dispose();
    _testNameFocus.dispose();
    _labNameFocus.dispose();
    _imageXFile.dispose();
  }
}
