

import 'package:doctoradmin/res/widgets/mybooking.dart';
import 'package:doctoradmin/viewModel/myBooking_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyBookingViewModel>().getAllBooking(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final myBookingViewModel = context.watch<MyBookingViewModel>();

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Booking"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "Confirmed",
              ),
              Tab(
                text: "Completed",
              ),
              Tab(
                text: "Cancelled",
              ),
            ],
          ),
          // centerTitle: true,
          automaticallyImplyLeading: false,
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 18),
          //   child: CustomBackButton(
          //     onPressed: () {
          //       context.pop();
          //     },
          //   ),
          // ),
          actions: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            upComing(myBookingViewModel),
            complete(myBookingViewModel),
            cancel(myBookingViewModel),
          ],
        ),
      ),
    );
  }
}

Widget upComing(MyBookingViewModel myBookingViewModel) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myBookingViewModel.confirmedAppointments.length,
            itemBuilder: (BuildContext context, int index) {
              final appointment =
                  myBookingViewModel.confirmedAppointments[index];
              return MyBookingConfirmCard(
                appointment: appointment,
              );
            }),
        SizedBox(height: 80),
      ],
    ),
  );
}

Widget complete(MyBookingViewModel myBookingViewModel) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myBookingViewModel.completedAppointments.length,
            itemBuilder: (BuildContext context, int index) {
              final appointment =
                  myBookingViewModel.completedAppointments[index];
              return MyBookingCompleteCard(
                appointment: appointment,
              );
            }),
        SizedBox(height: 80),
      ],
    ),
  );
}

Widget cancel(MyBookingViewModel myBookingViewModel) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myBookingViewModel.cancelledAppointments.length,
            itemBuilder: (BuildContext context, int index) {
              final appointment =
                  myBookingViewModel.cancelledAppointments[index];
              return MyBookingCancelCard(
                appointment: appointment,
              );
            }),
        SizedBox(height: 80),
      ],
    ),
  );
}
