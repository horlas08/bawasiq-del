import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class PasswordShowHideProvider extends ChangeNotifier {
  LoginState loginState = LoginState.initial;
  bool hidePassword = true;

  showHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }
}
