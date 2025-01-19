import "package:doctoradmin/res/widgets/profile_tab.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../res/widgets/buttons/backButton.dart";

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileTab(
                  onPressed: () {},
                  iconPath: 'assets/buttons/icons8-notification.svg',
                  title: 'Notifications Settings'),
              Divider(
                height: 5,
                indent: 20,
                endIndent: 20,
                thickness: 0.5,
              ),
              ProfileTab(
                  onPressed: () {
                    context.push('/changePassword');
                  },
                  iconPath: 'assets/buttons/icons8-key.svg',
                  title: 'Password manager'),
              Divider(
                height: 5,
                indent: 20,
                endIndent: 20,
                thickness: 0.5,
              ),
              ProfileTab(
                  onPressed: () {},
                  iconPath: 'assets/buttons/icons8-denied.svg',
                  title: 'Delete Account'),
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
