import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../repository/auth_repository.dart';
import '../utils/utils.dart';

class SignUpViewModel with ChangeNotifier {
  final _auth = AuthRepository();
  bool _isLoading = false;
  bool _signupLoading = false;
  bool _termsAccepted = false;
  String email = "";
  String name = "";
  String token = "";
  String password = "";
  String phoneNumber = "";
  String address = "";
  DateTime dob = DateTime.now();
  bool _isFemale = false;

  get loading => _isLoading;

  get signupLoading => _signupLoading;

  get termsAccepted => _termsAccepted;

  get getEmail => email;

  get getName => name;

  get getToken => token;

  get getPassword => password;

  get getPhoneNumber => phoneNumber;

  get getAddress => address;

  get getIsFemale => _isFemale;

  get getDob => dob;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSignUpLoading(bool value) {
    _signupLoading = value;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  Future<void> apiSignUp(dynamic data, BuildContext context) async {
    setSignUpLoading(true);
    _auth.signUp(data).then((value) async {
      if (value.acknowledgement ?? false) {
        Utils.flushBarSuccessMessage(value.description ?? "", context);
        Future.delayed(const Duration(seconds: 2), () {
          context.push('/login');
        });
      } else {
        Utils.flushBarErrorMessage(value.description ?? "", context);
      }
      // Utils.flushBarErrorMessage(value.description, context);
      // Navigator.pushNamed(context, RouteNames.home);
      // context.push('/login');
      setSignUpLoading(false);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setSignUpLoading(false);
    });
  }

  Future<void> apiSendOTP(dynamic data, BuildContext context) async {
    setLoading(true);
    try {
      final value = await _auth.sendOTP(data);
      // print(value);
      Utils.flushBarSuccessMessage(value.description ?? "", context);
      token = value.data;
      context.push('/otp');
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> apiVerifyOTP(dynamic data, BuildContext context) async {
    setLoading(true);
    try {
      final value = await _auth.verifyOTP(data);
      // print(value);
      if (value.acknowledgement ?? false) {
        Utils.flushBarSuccessMessage(value.description ?? "", context);
        context.push('/createPassword');
      } else {
        Utils.flushBarErrorMessage(value.description ?? "", context);
      }
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      setLoading(false);
    }
  }
}
