import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/helper/utils/generalImports.dart';

enum LanguageState {
  initial,
  loading,
  updating,
  loaded,
  error,
}

class LanguageProvider extends ChangeNotifier {
  LanguageState languageState = LanguageState.initial;
  LanguageJsonData? jsonData;
  Map<dynamic, dynamic> currentLanguage = {};
  Map<dynamic, dynamic> currentLocalOfflineLanguage = {};
  String languageDirection = "";
  List<LanguageListData> languages = [];
  LanguageList? languageList;
  String selectedLanguage = "0";

  Future getLanguageDataProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    languageState = LanguageState.updating;
    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await getSystemLanguageApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        if (getData.containsKey(ApiAndParams.data)) {
          jsonData = LanguageJsonData.fromJson(getData);
          languageDirection = jsonData!.data!.type!;

          currentLanguage = jsonData!.data!.jsonData!;
          Constant.session.setData(
            SessionManager.keySelectedLanguageId,
            jsonData!.data!.id!.toString(),
            false,
          );
        }

        final String response =
            await rootBundle.loadString(Constant.getAssetsPath(4, "en"));
        context
            .read<LanguageProvider>()
            .setLocalLanguage(await json.decode(response));

        languageState = LanguageState.loaded;
        notifyListeners();
        return true;
      } else {
        languageState = LanguageState.error;
        notifyListeners();
        return null;
      }
    }catch (e) {
      languageState = LanguageState.error;
      showMessage(context, e.toString(), MessageType.error);
      notifyListeners();
      return null;
    }
  }

  Future getAvailableLanguageList({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    languageState = LanguageState.loading;
    notifyListeners();

    try {
      Map<String, dynamic> getData =
          (await getAvailableLanguagesApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        if (getData.containsKey(ApiAndParams.data)) {
          languageList = LanguageList.fromJson(getData);
          languages = languageList!.data!;
        }
      }

      languageState = LanguageState.loaded;
      notifyListeners();
    }catch (e) {
      languageState = LanguageState.error;
      notifyListeners();
    }
  }

  setLocalLanguage(Map<dynamic, dynamic> currentLocalLanguage) {
    currentLocalOfflineLanguage = currentLocalLanguage;
    notifyListeners();
  }

  setSelectedLanguage(String index) {
    selectedLanguage = index;
    notifyListeners();
  }
}