import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../viewModel/forgorPassword_viewmodel.dart";
import "forgotPwChange_screen.dart";
import "forgotPwGetEmail_screen.dart";
import "forgotPwGetOTP_screen.dart";
import "forgotPwSuccess_screen.dart";

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(this), // Pass TickerProvider here
      builder: (context, _) {
        return ForgotPasswordContent(); // Child widget to separate UI logic
      },
    );
  }
}

class ForgotPasswordContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ForgotPasswordViewModel>(context, listen: true);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: viewModel.pageController,
        onPageChanged: viewModel.handlePageViewChanged,
        children: <Widget>[
          GetEmail(),
          GetOTP(),
          ChangePassWord(),
          ChangePasswordSuccess(),
        ],
      ),
    );
  }
}
