import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/userProfile.dart';

class EditDeliveryBoyProfileScreen extends StatefulWidget {
  final String from;

  EditDeliveryBoyProfileScreen({Key? key, required this.from}) : super(key: key);

  @override
  State<EditDeliveryBoyProfileScreen> createState() => _EditDeliveryBoyProfileScreenState();
}

class _EditDeliveryBoyProfileScreenState extends State<EditDeliveryBoyProfileScreen> {
  bool isLoading = false;
  String selectedImagePath = "";

  final globalKeyPersonalInformationWidgetState = GlobalKey<DeliveryBoyPersonalInformationWidgetState>();
  final globalKeyBankInformationWidgetState = GlobalKey<DeliveryBoyBankInformationWidgetState>();

  Map<String, dynamic> registrationData = {};
  Map<String, String> registrationDataFiles = {};
  late Timer timer;
  int logoutTimerSeconds = 10;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      if (widget.from.isEmpty) {
        registrationData[ApiAndParams.email] = Constant.session.getData(SessionManager.email);
        context.read<UserProfileProvider>().getProfile(context: context).then((value) {
          if (value is UserProfile) {
            // 'name' => 'required',
            // 'email' => 'email|required|unique:admins,email,'.$request->admin_id,
            // 'mobile' => 'required',
            // 'confirm_password' => 'same:password',
            // 'dob' => 'required',
            // 'bonus_percentage' => 'required',
            // 'ifsc_code' => 'required',
            // 'bank_name' => 'required',
            // 'bank_account_number' => 'required',
            // 'account_name' => 'required',
            // 'address' => 'required',
            // 'city_id' => 'required',
            // 'status' => 'required',

            UserProfileDeliveryBoy? deliveryBoy = value.data?.admin?.deliveryBoy!;

            registrationData["admin_id"] = deliveryBoy?.adminId?.toString() ?? "";
            registrationData["id"] = deliveryBoy?.id?.toString() ?? "";
            registrationData["name"] = deliveryBoy?.name?.toString() ?? "";
            registrationData["email"] = value.data?.admin?.email?.toString() ?? "";
            registrationData["mobile"] = deliveryBoy?.mobile?.toString() ?? "";
            registrationData["dob"] = deliveryBoy?.dob?.toString() ?? "";
            registrationData["bonus_percentage"] = deliveryBoy?.bonusPercentage?.toString() ?? "";
            registrationData["ifsc_code"] = deliveryBoy?.ifscCode?.toString() ?? "";
            registrationData["bank_name"] = deliveryBoy?.bankName?.toString() ?? "";
            registrationData["bank_account_number"] = deliveryBoy?.bankAccountNumber?.toString() ?? "";
            registrationData["account_name"] = deliveryBoy?.accountName?.toString() ?? "";
            registrationData["address"] = deliveryBoy?.address?.toString() ?? "";
            registrationData["city_id"] = deliveryBoy?.cityId?.toString() ?? "";
            registrationData["status"] = deliveryBoy?.status?.toString() ?? "";
            registrationData["cities"] = deliveryBoy?.cities ?? [];
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: titleProfileLabel,
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          if (userProfileProvider.profileState == ProfileState.loaded ||
              (userProfileProvider.profileState == ProfileState.initial || widget.from.isNotEmpty)) {
                var currentState = globalKeyPersonalInformationWidgetState.currentState;
            return Stack(
              children: [
                Form(key: _formKey,
                  child: Column(
                    children: [
                      if (widget.from.isEmpty)
                        Padding(
                          padding: EdgeInsetsDirectional.all(7),
                          child: Card(
                            color: Theme.of(context).cardColor,
                            surfaceTintColor: ColorsRes.appColorTransparent,
                            margin: EdgeInsetsDirectional.zero,
                            shape: DesignConfig.setRoundedBorder(7),
                            elevation: 0,
                            child: Padding(
                              padding: EdgeInsetsDirectional.all(10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: userProfileProvider.currentPage >= 0 ? ColorsRes.appColor : ColorsRes.grey,
                                    child: CustomTextLabel(
                                      text: "1",
                                      style: TextStyle(
                                        color: ColorsRes.appColorWhite,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: userProfileProvider.currentPage >= 1 ? ColorsRes.appColor : ColorsRes.grey,
                                      height: 5,
                                      thickness: 5,
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: userProfileProvider.currentPage >= 1 ? ColorsRes.appColor : ColorsRes.grey,
                                    child: CustomTextLabel(
                                      text: "2",
                                      style: TextStyle(
                                        color: ColorsRes.appColorWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                          children: [
                            if (widget.from.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsRes.appColorRed.shade100,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                padding: EdgeInsetsDirectional.only(start: 10, end: 10, top: 5, bottom: 5),
                                margin: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 5),
                                child: CustomTextLabel(
                                  jsonKey: allFieldsAreMandatoryLabel,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: ColorsRes.appColorRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (userProfileProvider.currentPage == 0)
                              DeliveryBoyPersonalInformationWidget(
                                key: globalKeyPersonalInformationWidgetState,
                                personalData: registrationData,
                                personalDataFile: registrationDataFiles,
                                from: widget.from,
                              ),
                            if (userProfileProvider.currentPage == 1 && widget.from.isEmpty)
                              DeliveryBoyBankInformationWidget(
                                key: globalKeyBankInformationWidgetState,
                                personalData: registrationData,
                                from: widget.from,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Row(
                          children: [
                            if (userProfileProvider.currentPage != 0 && widget.from.isEmpty)
                              Expanded(
                                child: gradientBtnWidget(
                                  context,
                                  10,
                                  title: getTranslatedValue(context, previousLabel),
                                  callback: () {
                                    userProfileProvider.moveBack();
                                  },
                                ),
                              ),
                            if (userProfileProvider.currentPage != 0) getSizedBox(width: 10),
                            Expanded(
                              child: gradientBtnWidget(
                                context,
                                10,
                                title: (userProfileProvider.currentPage == 1 || widget.from.isNotEmpty)
                                    ? getTranslatedValue(context, saveLabel)
                                    : getTranslatedValue(context, nextLabel),
                                callback: () {
                                  // id:2
                                  // admin_id:7
                                  // name:delivery
                                  // dob:8852-11-18
                                  // mobile:9876543210
                                  // email:delivery@gmail.com
                                  // ifsc_code:123
                                  // bank_name:123
                                  // bank_account_number:132
                                  // account_name:123
                                  // city_id:31
                                  // address:123
                                  // bonus_type:0
                                  // status:1
                                  // bonus_percentage:0
                      
                                  if (userProfileProvider.currentPage == 0 &&
                                      currentState?.formKey.currentState?.validate() == true) {
                                    //Personal information store action here
                      
                                    registrationData[ApiAndParams.name] =
                                        currentState?.edtDeliveryBoyUsername.text ?? "";
                                    registrationData[ApiAndParams.email] =
                                        currentState?.edtDeliveryBoyEmail.text ?? "";
                      
                                    registrationData[ApiAndParams.mobile] =
                                        currentState?.edtDeliveryBoyMobile.text ?? "";
                      
                                    /* registrationData[ApiAndParams.dob] =
                                        currentState?.edtDeliveryBoyDateOfBirth.text ?? ""; */
                                    final dobText = currentState?.edtDeliveryBoyDateOfBirth.text ?? '';
                  
                                    if (dobText.trim().isEmpty) {
                                      registrationData[ApiAndParams.dob] = "";
                                    } else {
                                      try {
                                        // Parse and format date
                                        DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobText);
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                  
                                        registrationData[ApiAndParams.dob] = formattedDate;
                                      } catch (e) {
                                        // If parsing fails, fallback to empty string
                                        registrationData[ApiAndParams.dob] = "";
                                      }
                                    }
                      
                                    if (currentState?.earningType == EarningType.commission) {
                                      registrationData[ApiAndParams.bonusPercentage] =
                                          currentState?.edtDeliveryBoyCommission.text ?? "";
                                    }
                      
                                    registrationData[ApiAndParams.bonusType] =
                                        currentState?.earningType == EarningType.commission ? "1" : "0";
                      
                                    registrationData[ApiAndParams.address] =
                                        currentState?.edtDeliveryBoyAddress.text ?? "";
                                    if (currentState!.edtPassword.text.isNotEmpty &&
                                        currentState.edtConfirmPassword.text.isNotEmpty) {
                                      registrationData[ApiAndParams.password] =
                                          currentState.edtPassword.text;
                      
                                      registrationData[ApiAndParams.confirm_password] =
                                          currentState.edtConfirmPassword.text;
                                    } else if (widget.from.isNotEmpty &&
                                        currentState.edtConfirmPassword.text.length < 6) {
                                      showMessage(context, getTranslatedValue(context, passwordMustBeSixCharactersLabel), MessageType.error);
                                    } else if (!registrationDataFiles[ApiAndParams.national_identity_card]!.contains("https://") ||
                                        !registrationDataFiles[ApiAndParams.national_identity_card]!.contains("http://")) {
                                      registrationDataFiles[ApiAndParams.national_identity_card] =
                                          currentState.selectedNationalIdProof;
                                    } else if (!registrationDataFiles[ApiAndParams.driving_license]!.contains("https://") ||
                                        !registrationDataFiles[ApiAndParams.driving_license]!.contains("http://")) {
                                      registrationDataFiles[ApiAndParams.driving_license] =
                                          currentState.selectedDrivingLicense;
                                    }
                      
                                    if (widget.from.isEmpty) {
                                      userProfileProvider.moveNext();
                                    } else {
                                      if ((!registrationDataFiles[ApiAndParams.national_identity_card]!.contains("https://") ||
                                              !registrationDataFiles[ApiAndParams.national_identity_card]!.contains("http://")) &&
                                          currentState.selectedNationalIdProof.isEmpty) {
                                        showMessage(context, getTranslatedValue(context, nationalIdCardRequiredLabel), MessageType.error);
                                      } else if ((!registrationDataFiles[ApiAndParams.driving_license]!.contains("https://") ||
                                              !registrationDataFiles[ApiAndParams.driving_license]!.contains("http://")) &&
                                          currentState.selectedDrivingLicense.isEmpty) {
                                        showMessage(context, getTranslatedValue(context, drivingLicenseIsRequiredLabel), MessageType.error);
                                      } else if (currentState.earningType == EarningType.commission &&
                                          currentState.edtDeliveryBoyCommission.text.isEmpty) {
                                        showMessage(context, getTranslatedValue(context, enterCommissionLabel), MessageType.error);
                                      } else if (currentState.earningType == EarningType.commission &&
                                          double.parse(currentState.edtDeliveryBoyCommission.text) > 100) {
                                        showMessage(
                                            context, getTranslatedValue(context, commissionShouldBeLessThanOrEqualTo100Label), MessageType.error);
                                      } else if (currentState.earningType == EarningType.commission &&
                                          double.parse(currentState.edtDeliveryBoyCommission.text) <= 0) {
                                        showMessage(context, getTranslatedValue(context, commissionShouldBeGreaterThan0Label), MessageType.error);
                                      } else {
                                        /*
                                    1. Personal Information
                                      name
                                      mobile
                                      dob
                                      address
                                      driving_license //file
                                      national_identity_card //file
                      
                                    2. Store Information
                                      bank_name
                                      ifsc_code
                                      account_name
                                      bank_account_number
                                  */
                      
                                        if (!registrationDataFiles[ApiAndParams.national_identity_card]!.contains("https://") ||
                                            !registrationDataFiles[ApiAndParams.national_identity_card]!.contains("http://")) {
                                          registrationDataFiles[ApiAndParams.national_identity_card] =
                                              currentState.selectedNationalIdProof;
                                        }
                      
                                        if (!registrationDataFiles[ApiAndParams.driving_license]!.contains("https://") ||
                                            !registrationDataFiles[ApiAndParams.driving_license]!.contains("http://")) {
                                          registrationDataFiles[ApiAndParams.driving_license] =
                                              currentState.selectedDrivingLicense;
                                        }
                      
                                        userProfileProvider.updateUserApiProvider(
                                            context: context,
                                            params: registrationData,
                                            from: widget.from,
                                            fileParamsFilesPath: registrationDataFiles,
                                            fileParamsNames: {}).then((value) {
                                          if (value == true) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    }
                                  } else if (userProfileProvider.currentPage == 1 &&
                                      /* globalKeyBankInformationWidgetState.currentState?.formKey.currentState? */ _formKey.currentState!.validate() == true) {
                                    //Bank information store action here
                      
                                    registrationData[ApiAndParams.bank_name] = globalKeyBankInformationWidgetState.currentState?.edtBankName.text ?? "";
                      
                                    registrationData[ApiAndParams.ifsc_code] = globalKeyBankInformationWidgetState.currentState?.edtIFSCCode.text ?? "";
                      
                                    registrationData[ApiAndParams.account_name] =
                                        globalKeyBankInformationWidgetState.currentState?.edtAccountName.text ?? "";
                      
                                    registrationData[ApiAndParams.bank_account_number] =
                                        globalKeyBankInformationWidgetState.currentState?.edtAccountNumber.text ?? "";
                      
                                    /*
                                    1. Personal Information
                                      name
                                      mobile
                                      dob
                                      address
                                      driving_license //file
                                      national_identity_card //file
                      
                                    2. Store Information
                                      bank_name
                                      ifsc_code
                                      account_name
                                      bank_account_number
                                  */
                      
                                    userProfileProvider.updateUserApiProvider(
                                      context: context,
                                      params: registrationData,
                                      from: widget.from,
                                      fileParamsFilesPath: {},
                                      fileParamsNames: {},
                                    ).then((value) {
                                      if (value == true) {
                                        if (registrationData.containsKey("password") &&
                                            widget.from.isEmpty &&
                                            registrationData["password"].toString().isNotEmpty) {
                                          timer = Timer.periodic(Duration(seconds: 1), (time) {
                                            logoutTimerSeconds--;
                      
                                            if (logoutTimerSeconds == 0) {
                                              if (timer.isActive) {
                                                timer.cancel();
                                              }
                                              Navigator.pop(context);
                                              Constant.session.logoutUser(context, confirmationRequired: false);
                                            }
                                          });
                      
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Theme.of(context).cardColor,
                                                surfaceTintColor: Theme.of(context).cardColor,
                                                title: CustomTextLabel(
                                                  jsonKey: logoutLabel,
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                actions: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (timer.isActive) {
                                                        timer.cancel();
                                                      }
                                                      Navigator.pop(context);
                                                      Constant.session.logoutUser(context, confirmationRequired: false);
                                                    },
                                                    child: CustomTextLabel(
                                                      softWrap: true,
                                                      jsonKey: logoutNowLabel,
                                                      style: TextStyle(color: ColorsRes.appColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                                content: CustomTextLabel(
                                                  softWrap: true,
                                                  text:
                                                      "${getTranslatedValue(context, appWillLogoutInLabel)} $logoutTimerSeconds ${getTranslatedValue(context, secondsBecausePasswordChangedLabel)}",
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (userProfileProvider.updateProfileState == UpdateProfileState.loading)
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: Container(
                      color: ColorsRes.appColorBlack.withValues(alpha: 0.2),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          } else if (userProfileProvider.profileState == ProfileState.loading) {
            return CustomShimmer(
              height: context.height,
              width: context.width,
              margin: EdgeInsets.all(10),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
