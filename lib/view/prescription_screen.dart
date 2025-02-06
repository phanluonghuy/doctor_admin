import 'package:doctoradmin/res/widgets/buttons/backButton.dart';
import 'package:doctoradmin/res/widgets/buttons/primaryButton.dart';
import 'package:doctoradmin/utils/utils.dart';
import 'package:doctoradmin/viewModel/prescriptions_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final FocusNode _medicineFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _frequencyFocus = FocusNode();
  final FocusNode _timeFocus = FocusNode();
  final FocusNode _timeDescriptionFocus = FocusNode();
  final FocusNode _durationFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<PrescriptionsViewModel>();
      viewModel.getAllMedicine(context);
      viewModel.getMedicalRecordsByAppointment(context);
    });
  }

  @override
  dispose() {
    _medicineFocus.dispose();
    _amountFocus.dispose();
    _frequencyFocus.dispose();
    _timeFocus.dispose();
    _timeDescriptionFocus.dispose();
    _durationFocus.dispose();
    super.dispose();
  }




  void showMultiSelectDialog(BuildContext context) {
    final viewModel = Provider.of<PrescriptionsViewModel>(context, listen: false);
    List<String> tempSelected = List.from(viewModel.selectedTimes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Time"),
          content: SingleChildScrollView(
            child: ListBody(
              children: viewModel.options.map((String option) {
                return Consumer<PrescriptionsViewModel>(
                  builder: (context, viewModel, child) {
                    return CheckboxListTile(
                      title: Text(option),
                      value: tempSelected.contains(option),
                      onChanged: (bool? checked) {
                        if (checked == true) {
                          tempSelected.add(option);
                        } else {
                          tempSelected.remove(option);
                        }
                        viewModel.selectedTimes = tempSelected;
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                viewModel.selectedTimes = tempSelected;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final viewModel = context.watch<PrescriptionsViewModel>();
    // TODO : Implement multiple medicine selection
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription"),
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
                    child: Text("Medicine Name:")),
                SizedBox(height: height * 0.01),
                DropdownMenu(
                  hintText: "Select Medicine",
                  focusNode: _medicineFocus,
                  width: double.infinity,
                  dropdownMenuEntries: viewModel.medicines
                      .map((e) => DropdownMenuEntry<Object>(
                            value: e.id,
                            label: e.name,
                          ))
                      .toList(),
                  onSelected: (value) {
                    viewModel.medicineIds = value.toString();
                    Utils.changeNodeFocus(context,
                        current: _medicineFocus, next: _amountFocus);
                  },
                ),
                SizedBox(height: height * 0.02),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Amount Per Dose:")),
                SizedBox(height: height * 0.01),
                TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: _amountFocus,
                  onChanged: (value) {
                    viewModel.amountPerDose = int.parse(value);
                  },
                  onFieldSubmitted: (value) {
                    Utils.changeNodeFocus(context,
                        current: _amountFocus, next: _frequencyFocus);
                  },
                  decoration: InputDecoration(
                    hintText: "Amount Per Dose",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Frequency Per Day:")),
                SizedBox(height: height * 0.01),
                TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: _frequencyFocus,
                  onChanged: (value) {
                    viewModel.frequency = int.parse(value);
                  },
                  onFieldSubmitted: (value) {
                    Utils.changeNodeFocus(context,
                        current: _frequencyFocus, next: _timeFocus);
                  },
                  decoration: InputDecoration(
                    hintText: "Frequency Per Day",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Align(alignment: Alignment.centerLeft, child: Text("Times:")),
                SizedBox(height: height * 0.01),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        onTap: () => showMultiSelectDialog(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Consumer<PrescriptionsViewModel>(
                            builder: (context, viewModel, child) {
                              return Text(
                                viewModel.selectedTimes.isEmpty
                                    ? "Select Time"
                                    : viewModel.selectedTimes.join(", "),
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: _timeDescriptionFocus,
                        onChanged: (value) {
                          viewModel.timeDescription = value;
                        },
                        onFieldSubmitted: (value) {
                          Utils.changeNodeFocus(context,
                              current: _timeDescriptionFocus,
                              next: _durationFocus);
                        },
                        decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Align(
                    alignment: Alignment.centerLeft, child: Text("Duration:")),
                SizedBox(height: height * 0.01),
                TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: _durationFocus,
                  onChanged: (value) {
                    viewModel.duration = int.parse(value);
                  },
                  onFieldSubmitted: (value) {
                    Utils.changeNodeFocus(context,
                        current: _durationFocus, next: null);
                  },
                  decoration: InputDecoration(
                    hintText: "Duration",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
          padding: EdgeInsets.all(20),
          child: PrimaryButton(
              text: "Update",
              onPressed: () {
                // print(viewModel.bookingId);
                if (viewModel.medicineIds.isEmpty) {
                  Utils.flushBarErrorMessage(
                      "Please select a medicine", context);
                  return;
                }
                if (viewModel.amountPerDose == 0) {
                  Utils.flushBarErrorMessage(
                      "Please enter amount per dose", context);
                  return;
                }
                if (viewModel.frequency == 0) {
                  Utils.flushBarErrorMessage("Please enter frequency", context);
                  return;
                }
                if (viewModel.selectedTimes.isEmpty) {
                  Utils.flushBarErrorMessage("Please select a time", context);
                  return;
                }
                if (viewModel.timeDescription.isEmpty) {
                  Utils.flushBarErrorMessage(
                      "Please enter time description", context);
                  return;
                }
                if (viewModel.duration == 0) {
                  Utils.flushBarErrorMessage("Please enter duration", context);
                  return;
                }
                Map<String, dynamic> data = {
                  "medicineId": viewModel.medicineIds,
                  "amountPerDose": viewModel.amountPerDose,
                  "frequencyPerDay": viewModel.frequency,
                  "times": viewModel.selectedTimes.map((e) => {"time": e.toLowerCase()}).toList(),
                  "description": viewModel.timeDescription,
                  "duration": viewModel.duration,
                };
                viewModel.createDosages(context, data);
                // viewModel.createPrescriptions(context);
              },
              context: context)),
    );
  }
}
