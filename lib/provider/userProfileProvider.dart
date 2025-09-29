import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/userProfile.dart';

enum LoginState { initial, loading, loaded, error }

enum UpdateProfileState { initial, loading, loaded, error }

enum ProfileState {
  initial,
  loading,
  loaded,
  error,
}

enum DeleteUserState {
  initial,
  loading,
  loaded,
  error,
}

class UserProfileProvider extends ChangeNotifier {
  LoginState loginState = LoginState.initial;
  bool hidePassword = true;

  bool hideRegisterPassword = true;

  UpdateProfileState updateProfileState = UpdateProfileState.initial;
  bool hideUpdateProfilePassword = true;
  int currentPage = 0;

  Future<Map<String, dynamic>?> loginApiProvider(Map<String, String> params, BuildContext context) async {
    try {
      loginState = LoginState.loading;
      notifyListeners();

      Map<String, dynamic> loginApiResponse = await getLoginRepository(params: params);

      if (loginApiResponse[ApiAndParams.status].toString() == "1") {
        UserLogin userLogin = UserLogin.fromJson(loginApiResponse);

        Constant.session.setData(SessionManager.keyAccessToken, userLogin.data!.accessToken.toString(), false);
        loginState = LoginState.loaded;
        notifyListeners();

        return userLogin.toJson();
      } else {
        if (loginApiResponse.containsKey(ApiAndParams.data)) {
          Map<String, dynamic> data = loginApiResponse[ApiAndParams.data];
          if (data[ApiAndParams.status].toString() == "2") {
            showMessage(
                context,
                "${getTranslatedValue(context, requestRejectedMessageLabel)} \"${data[ApiAndParams.remark]}\", ${getTranslatedValue(context, thankYouLabel)}",
                MessageType.error);
            loginState = LoginState.loaded;
            notifyListeners();
          } else if (data[ApiAndParams.status].toString() == "3") {
            showMessage(
                context,
                "${getTranslatedValue(context, accountInactiveMessageLabel)} \"${data[ApiAndParams.remark]}\", ${getTranslatedValue(context, thankYouLabel)}",
                MessageType.error);
          }
          loginState = LoginState.loaded;
          notifyListeners();
        } else {
          showMessage(context, loginApiResponse[ApiAndParams.message].toString(), MessageType.error);
        }
        loginState = LoginState.error;
        notifyListeners();
        return {};
      }
    }catch (e) {
      showMessage(context, e.toString(), MessageType.error);
      loginState = LoginState.error;
      notifyListeners();
      return {};
    }
  }

  showHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  showHideRegisterPassword() {
    hideRegisterPassword = !hideRegisterPassword;
    notifyListeners();
  }

  moveBack() {
    currentPage--;
    notifyListeners();
  }

  moveNext() {
    currentPage++;
    notifyListeners();
  }

  showHideUpdateUserPassword() {
    hideUpdateProfilePassword = !hideUpdateProfilePassword;
    notifyListeners();
  }

  Future updateUserApiProvider(
      {required BuildContext context,
      required Map<String, dynamic> params,
      required String from,
      required Map<String, dynamic> fileParamsFilesPath,
      required Map<String, dynamic> fileParamsNames}) async {
    try {
      updateProfileState = UpdateProfileState.loading;
      notifyListeners();
      Map<String, File> filesMap = {};

      for (int i = 0; i < fileParamsFilesPath.length; i++) {
        fileParamsFilesPath.removeWhere(
          (key, value) => fileParamsFilesPath.values.toList()[i].toString().startsWith("http"),
        );
      }

      for (int i = 0; i < fileParamsFilesPath.length; i++) {
        filesMap[fileParamsFilesPath.keys.toList()[i]] = File(fileParamsFilesPath.values.toList()[i]);
      }

      Map<String, dynamic> updateUserApiResponse = await updateUserApiRepository(
        params: params,
        from: from,
        filesMap: filesMap,
      );

      showMessage(context, updateUserApiResponse[ApiAndParams.message], MessageType.warning);

      if (updateUserApiResponse[ApiAndParams.status].toString() == "1") {
        updateProfileState = UpdateProfileState.loaded;
        notifyListeners();

        return true;
      } else {
        showMessage(context, updateUserApiResponse[ApiAndParams.message], MessageType.warning);
        updateProfileState = UpdateProfileState.error;
        notifyListeners();
        return false;
      }
    }catch (e) {
      showMessage(context, e.toString(), MessageType.error);
      updateProfileState = UpdateProfileState.error;
      notifyListeners();
      return false;
    }
  }

  String message = '';
  ProfileState profileState = ProfileState.initial;
  late UserProfile profile;

  Future getProfile({
    required BuildContext context,
  }) async {
    profileState = ProfileState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData = await getProfileApi(context: context, id: Constant.session.getData(SessionManager.userId));

      if (getData[ApiAndParams.status].toString() == "1") {
        profile = UserProfile.fromJson(getData);

        profileState = ProfileState.loaded;
        notifyListeners();
        return profile;
      } else {
        profileState = ProfileState.error;
        notifyListeners();
        showMessage(context, getData[ApiAndParams.message], MessageType.warning);
        return null;
      }
    }catch (e) {
      message = e.toString();
      profileState = ProfileState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return null;
    }
  }

  DeleteUserState deleteUserState = DeleteUserState.initial;

  Future deleteAccount({
    required BuildContext context,
  }) async {
    profileState = ProfileState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData = await getProfileApi(context: context, id: Constant.session.getData(SessionManager.userId));

      if (getData[ApiAndParams.status].toString() == "1") {
        profile = UserProfile.fromJson(getData);

        profileState = ProfileState.loaded;
        notifyListeners();
        return profile;
      } else {
        profileState = ProfileState.error;
        notifyListeners();
        showMessage(context, getData[ApiAndParams.message], MessageType.warning);
        return null;
      }
    }catch (e) {
      message = e.toString();
      profileState = ProfileState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return null;
    }
  }
}
