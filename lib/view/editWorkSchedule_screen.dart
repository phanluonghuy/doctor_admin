import 'dart:convert';
import 'package:doctoradmin/res/texts/app_text.dart';
import 'package:doctoradmin/res/widgets/buttons/primaryButton.dart';
import 'package:doctoradmin/res/widgets/buttons/whitePrimaryButton.dart';
import 'package:doctoradmin/viewModel/workSchedule_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditWorkScheduleScreen extends StatefulWidget {
  @override
  _EditWorkScheduleScreenState createState() => _EditWorkScheduleScreenState();
}

class _EditWorkScheduleScreenState extends State<EditWorkScheduleScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkSchedule();
  }

  Future<void> fetchWorkSchedule() async {
    try {
      final viewModel =
          Provider.of<WorkScheduleProvider>(context, listen: false);
      viewModel.getWorkSchedule(context);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> pickTime(BuildContext context, String initTime) async {
    TimeOfDay init = parseTimeOfDay(initTime);
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: init,
    );
    return time?.format(context);
  }

  TimeOfDay parseTimeOfDay(String time) {
    final parts = time.split(":"); // Split "09:00" into ["09", "00"]
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkScheduleProvider>(context);
    final availableTimes = provider.availableTimes;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Doctor Work Schedule"), centerTitle: true),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                      width: width * 0.7,
                      child: OutlinePrimaryButton(
                          text: 'Add Available Time',
                          onPressed: provider.addAvailableTime)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableTimes.length,
                      itemBuilder: (context, index) {
                        final entry = availableTimes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButton<String>(
                                  value: entry["dayOfWeek"],
                                  onChanged: (value) =>
                                      provider.updateAvailableTime(
                                          index, "dayOfWeek", value!),
                                  items: [
                                    "Monday",
                                    "Tuesday",
                                    "Wednesday",
                                    "Thursday",
                                    "Friday",
                                    "Saturday",
                                    "Sunday"
                                  ]
                                      .map((day) => DropdownMenuItem(
                                          value: day, child: Text(day)))
                                      .toList(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Start: ${entry["startTime"]}"),
                                    TextButton(
                                      onPressed: () async {
                                        String? time = await pickTime(
                                            context, entry["startTime"]);
                                        if (time != null) {
                                          provider.updateAvailableTime(
                                              index, "startTime", time);
                                        }
                                      },
                                      child: Text(
                                        "Pick Start Time",
                                        style: AppTextStyle.link
                                            .copyWith(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("End: ${entry["endTime"]}"),
                                    TextButton(
                                      onPressed: () async {
                                        String? time = await pickTime(
                                            context, entry["endTime"]);
                                        if (time != null)
                                          provider.updateAvailableTime(
                                              index, "endTime", time);
                                      },
                                      child: Text("Pick End Time",
                                          style: AppTextStyle.link
                                              .copyWith(fontSize: 13)),
                                    ),
                                  ],
                                ),
                                Text("Rest Times:"),
                                Column(
                                  children:
                                      entry["restTime"].map<Widget>((time) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("- $time",
                                            style: TextStyle(
                                                color: Colors.grey[700])),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => provider
                                              .removeRestTime(index, time),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String? restTime =
                                        await pickTime(context, "12:00");
                                    if (restTime != null)
                                      provider.addRestTime(index, restTime);
                                  },
                                  child: Text("Add Rest Time",
                                      style: AppTextStyle.link
                                          .copyWith(fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(16),
        child: PrimaryButton(
            text: "Update Schedule",
            loading: provider.isLoading,
            onPressed: () {
              Provider.of<WorkScheduleProvider>(context, listen: false)
                  .updateWorkSchedule(context);
            },
            context: context),
      ),
    );
  }
}
