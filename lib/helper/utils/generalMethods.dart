import 'dart:core';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/helper/generalWidgets/messageContainer.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

enum MessageType { success, error, warning }

Map<MessageType, Color> messageColors = {MessageType.success: ColorsRes.appColorGreen, MessageType.error: ColorsRes.appColorRed, MessageType.warning: ColorsRes.appColorOrange};

Map<MessageType, Widget> messageIcon = {
  MessageType.success: defaultImg(image: AppAssets.doneIcon, iconColor: ColorsRes.appColorGreen),
  MessageType.error: defaultImg(image: AppAssets.errorIcon, iconColor: ColorsRes.appColorRed),
  MessageType.warning: defaultImg(image: AppAssets.warningIcon, iconColor: ColorsRes.appColorOrange),
};

Future<bool> checkInternet() async {
  bool check = false;

  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult[0] == ConnectivityResult.mobile ||
      connectivityResult[0] == ConnectivityResult.wifi ||
      connectivityResult[0] == ConnectivityResult.ethernet) {
    check = true;
  }
  return check;
}

NetworkStatus getNetworkStatus(ConnectivityResult status) {
  return status == ConnectivityResult.mobile || status == ConnectivityResult.wifi || status == ConnectivityResult.ethernet
      ? NetworkStatus.Online
      : NetworkStatus.Offline;
}

showMessage(
  BuildContext context,
  String msg,
  MessageType type,
) async {
  FocusScope.of(context).unfocus(); // Unfocused any focused text field
  SystemChannels.textInput.invokeMethod('TextInput.hide'); // Close the keyboard

  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        left: 5,
        right: 5,
        bottom: 15,
        child: MessageContainer(
          context: context,
          text: msg,
          type: type,
        ),
      );
    },
  );
  overlayState.insert(overlayEntry);
  await Future.delayed(
    Duration(
      milliseconds: Constant.messageDisplayDuration,
    ),
  );

  overlayEntry.remove();
}

Locale getLocaleFromLangCode(String languageCode) {
  List<String> result = languageCode.split("-");
  return result.length == 1 ? Locale(result.first) : Locale(result.first, result.last);
}

String setFirstLetterUppercase(String value) {
  if (value.isNotEmpty) value = value.replaceAll("_", ' ');
  return value.toTitleCase();
}

Future sendApiRequest({required String apiName, required Map<String, dynamic> params, required bool isPost, bool? isRequestedForInvoice}) async {
  try {
    String token = Constant.session.getData(SessionManager.keyAccessToken);
    String baseUrl = "${Constant.hostUrl}api/${Constant.session.isSeller() ? "seller" : "delivery_boy"}/";

    Map<String, String> headersData = {
      "accept": "application/json",
    };

    if (token.trim().isNotEmpty) {
      headersData["Authorization"] = "Bearer $token";
    }

    headersData["x-access-key"] = "903361";

    String mainUrl = apiName.contains("http") ? apiName : "${baseUrl}$apiName";

    http.Response response;
    if (isPost) {
      response = await http.post(Uri.parse(mainUrl), body: params.isNotEmpty ? params : null, headers: headersData);
    } else {
      mainUrl = await Constant.getGetMethodUrlWithParams(apiName.contains("http") ? apiName : "${baseUrl}$apiName", params);

      response = await http.get(Uri.parse(mainUrl), headers: headersData);
    }

    if (response.statusCode == 200) {
      if (response.body == "null") {
        return null;
      }
      if (kDebugMode) {
        print("API IS : $mainUrl, PARAMS : $params, CODE : ${response.statusCode}, ${response.body},");
      }
      return isRequestedForInvoice == true ? response.bodyBytes : response.body;
    } else {
      if(response.statusCode == 401){
        Constant.session.processToLogout(Constant.navigatorKay.currentContext!);
      }
      if (kDebugMode) {
        print("ERROR IS API : $mainUrl, PARAMS : $params, CODE : ${response.statusCode}, ${response.body},");
      }
      return null;
    }
  } on SocketException {
    await Future.delayed(const Duration(milliseconds: 1800));
    throw SocketException('No Internet Connection');
  } catch (e) {
    return null;
  }
}



Future sendApiMultiPartRequest({required String apiName, required Map<String, dynamic> params, required Map<String, File> filesMap}) async {
  try {
    dio.Dio dioClient = dio.Dio();
    String token = Constant.session.getData(SessionManager.keyAccessToken);
    String baseUrl = "${Constant.hostUrl}api/${Constant.session.isSeller() ? "seller" : "delivery_boy"}/";
    String mainUrl = apiName.contains("http") ? apiName : "$baseUrl$apiName";

    // Headers
    dioClient.options.headers = {
      "Authorization": "Bearer $token",
      "x-access-key": "903361",
    };

    // Form Data
    dio.FormData formData = dio.FormData.fromMap(params);

    // Add multiple image files with dynamic fileParamsNames[i]
    if (filesMap.isNotEmpty) {
      // Extract keys
      List<String> keys = filesMap.keys.toList();

      // Extract files
      List<File> file = filesMap.values.toList();
      for (int i = 0; i < file.length; i++) {
        final mimeType = lookupMimeType(file[i].path) ?? 'application/octet-stream';
        var extension = mimeType.split("/");

        formData.files.add(
          MapEntry(
            keys[i],
            // Use fileParamsNames[i] as the dynamic key for each image
            await dio.MultipartFile.fromFile(
              file[i].path,
              filename: file[i].path.split('/').last,
              contentType: MediaType(extension[0], extension[1]),
            ),
          ),
        );
      }
    }

    // Send Request
    dio.Response response = await dioClient.post(
      mainUrl,
      data: formData,
      options: dio.Options(
        contentType: 'multipart/form-data',
      ),
    );
    if (kDebugMode) {
      print("ERROR IS : ${response.data}, API : $baseUrl, PARAMS : $params, CODE : ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  } on dio.DioException catch (e) {
    print("Server error ${e.response?.statusCode}");
    print("Message: ${e.response?.data}");
  } on SocketException {
    await Future.delayed(const Duration(milliseconds: 1800));
    throw SocketException('No Internet Connection');
  } catch (e) {
    if (kDebugMode) {
      print("ERROR IS CACHE : ${e.toString()}");
    }
    rethrow;
  }
}

String? validateEmail(String value) {
  String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else
    return null;
}

emailValidation(String val, String msg) {
  return validateEmail(
    val.trim(),
  );
}

percentageValidation(String val, String msg) {
  if (val.isNotEmpty) {
    double percentage = val.toDouble!;
    if (percentage > 100 || percentage < 0) {
      return "Commission should be greater then 0% and less then 100%!";
    } else {
      return null;
    }
  } else {
    return "Commission should not be empty!";
  }
}

emptyValidation(String val, String msg) {
  if (val.trim().isEmpty) {
    return msg;
  }
  return null;
}

optionalFieldValidation(String val, String msg) {
  return null;
}

/* passwordValidation(String val, String msg) {
  if (val == "false") {
    return "";
  }
  return null;
} */
String? passwordValidation(String? value, String errorMessage) {
  if (value == null || value.trim().isEmpty) {
    return enterPasswordLabel;
  } else if (value.trim().length < 6) {
    return passwordMinLengthLabel;
  }
  return null;
}

getUserLocation() async {
  LocationPermission permission;

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();

    getUserLocation();
  } else if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      await Geolocator.openLocationSettings();
      getUserLocation();
    } else {
      getUserLocation();
    }
  }
}



Future<Position> determinePosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  } else if (permission == LocationPermission.deniedForever) {
    return Future.error('Location Not Available');
  }

  return await Geolocator.getCurrentPosition();
}

Future getFileFromDevice() async {
  String path = "";
  await FilePicker.platform
      .pickFiles(
          allowMultiple: false, allowCompression: true, type: FileType.custom, allowedExtensions: ["jpg", "jpeg", "png"], lockParentWindow: true)
      .then((value) {
    path = value!.paths.first.toString();
  });
  return path;
}

phoneValidation(String value, String msg) {
  String pattern = r'[0-9]';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty || !regExp.hasMatch(value) || value.trim().length >= 16 || value.trim().length < Constant.minimumRequiredMobileNumberLength) {
    return msg;
  }
  return null;
}

String getCurrencyFormat(double amount) {
  return NumberFormat.currency(symbol: Constant.currency, decimalDigits: int.tryParse(Constant.currencyDecimalPoint)??2, name: Constant.currencyCode)
      .format(amount);
}

maskSensitiveInformation(text) {}

String getTranslatedValue(BuildContext context, String key) {
  return context.read<LanguageProvider>().currentLanguage[key] ?? context.read<LanguageProvider>().currentLocalOfflineLanguage[key] ?? key;
}

Future<bool> hasStoragePermissionGiven() async {
  try {
    if (Platform.isIOS) {
      bool permissionGiven = await Permission.storage.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.storage.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    }
//if it is for android
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt < 33) {
      bool permissionGiven = await Permission.storage.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.storage.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    } else {
      bool permissionGiven = await Permission.photos.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.photos.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    }
  } on SocketException {
    await Future.delayed(const Duration(milliseconds: 1800));
    throw SocketException('No Internet Connection');
  } catch (e) {
    return false;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map(
        (str) => str.toCapitalized(),
      )
      .join(' ');
}

extension ContextExtension on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;
}

extension StringParsing on String {
  double? get toDouble => double.tryParse(this) ?? 0.0;

  double? get toInt => double.tryParse(this) ?? 0;

  int get toStringToInt => int.tryParse(this) ?? 0;

  String get currency => NumberFormat.currency(
          symbol: Constant.currency, decimalDigits: int.tryParse(Constant.currencyDecimalPoint.toString())??2, name: Constant.currencyCode)
      .format(this.toDouble);
}

extension StringToDateTimeFormatting on String {
  DateTime toDate({String format = 'd MMM y, hh:mm a'}) {
    try {
      return DateTime.parse(this).toLocal();
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  String formatDate({String inputFormat = 'yyyy-MM-dd', String outputFormat = 'd MMM y, hh:mm a'}) {
    try {
      DateTime dateTime = toDate(format: inputFormat);
      return DateFormat(outputFormat).format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return this; // Return the original string if there's an error
    }
  }
}

class CustomNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits (0-9)
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (RegExp(r'^[0-9]*$').hasMatch(newValue.text)) {
      // Allow a single '0', but prevent multiple leading zeros
      if (newValue.text == '0') {
        return newValue; // Allow the single zero
      } else if (newValue.text.length > 1 && newValue.text.startsWith('0') && newValue.text[1] == '0') {//if (newValue.text.startsWith('0') && newValue.text.length > 1) {
        return oldValue; // Reject if it starts with multiple zeros
      } else {
        return newValue; // Accept valid inputs
      }
    } else {
      return oldValue; // Reject invalid inputs
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

extension ValidateNullString on String {
  String checkNullString() => (this == "null" ? "" : this).toString();
}

//save image in local
Future<File?> saveFileToLocalStorage(File file) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final newPath = "${directory.path}/${file.path.split('/').last}";
    return await file.copy(newPath);
  } catch (e) {
    if (kDebugMode) print("Error saving file locally: $e");
    return null;
  }
}
