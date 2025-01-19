import 'package:doctoradmin/viewModel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashService {
  static Future<void> checkAuthentication(BuildContext context) async {
    context.go('/navigationMenu');
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.getUserProfile();
    final String? token = await userViewModel.getUserToken();
    if (token == null || token == "") {
      context.go('/welcome');
    } else {
      context.go('/navigationMenu');
    }
  }
}
