import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/userProfile.dart';
import 'package:flutter/material.dart';

class EditSellerProfileScreen extends StatefulWidget {
  final String from;

  EditSellerProfileScreen({Key? key, required this.from}) : super(key: key);

  @override
  State<EditSellerProfileScreen> createState() => _EditSellerProfileScreenState();
}

class _EditSellerProfileScreenState extends State<EditSellerProfileScreen> {
  bool isLoading = false;
  String selectedImagePath = "";

  final globalKeyPersonalInformationWidgetState = GlobalKey<SellerPersonalInformationWidgetState>();
  final globalKeyBankInformationWidgetState = GlobalKey<SellerBankInformationWidgetState>();
  final globalKeyStoreInformationWidgetState = GlobalKey<SellerStoreInformationWidgetState>();
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> registrationData = {};
  Map<String, String> registrationDataFiles = {};

  late Timer timer;
  int logoutTimerSeconds = 10;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      if (widget.from.isEmpty) {
        context.read<UserProfileProvider>().getProfile(context: context).then((value) {
          if (value is UserProfile) {
            // id:1
            // admin_id:4
            // name:WRTeamSeller
            // email:seller@gmail.com
            // mobile:9876543210
            // store_name:WRTeam
            // city_id:31
            // account_number:464545646464545
            // categories_ids:63,7,6,5,4,3,2
            // ifsc_code:837373737
            // account_name:Hsgsushdhdjdueh
            // store_url:https://jdhdhdhdj.com
            // bank_name:hshdjdjdjdhdhdj
            // commission:10
            // tax_name:TAX
            // tax_number:TAX
            // pan_number:PAN123
            // latitude:23.2419997
            // longitude:69.6669324
            // place_name:Bhuj
            // formatted_address:Bhuj,Gujarat,India
            // require_products_approval:0
            // store_description:Irhrhrrjrirjrj
            // view_order_otp:0
            // assign_delivery_boy:0
            // status:1
            // store_logo:undefined
            // password:
            // confirm_password:

            UserProfileSeller? seller = value.data?.admin?.seller!;

            registrationData["id"] = seller?.id?.toString() ?? "";
            registrationData["admin_id"] = seller?.adminId?.toString() ?? "";
            registrationData["name"] = seller?.name?.toString() ?? "";
            registrationData["email"] = seller?.email?.toString() ?? "";
            registrationData["mobile"] = seller?.mobile?.toString() ?? "";
            registrationData["store_name"] = seller?.storeName?.toString() ?? "";
            registrationData["city_id"] = seller?.cityId?.toString() ?? "";
            registrationData["account_number"] = seller?.accountNumber?.toString() ?? "";
            registrationData["categories_ids"] = seller?.categories?.toString() ?? "";
            registrationData["ifsc_code"] = seller?.bankIfscCode?.toString() ?? "";
            registrationData["account_name"] = seller?.accountName?.toString() ?? "";
            registrationData["store_url"] = seller?.storeUrl?.toString() ?? "";
            registrationData["bank_name"] = seller?.bankName?.toString() ?? "";
            registrationData["commission"] = Constant.sellerCommission.toString();
            registrationData["tax_name"] = seller?.taxName?.toString() ?? "";
            registrationData["tax_number"] = seller?.taxNumber?.toString() ?? "";
            registrationData["pan_number"] = seller?.panNumber?.toString() ?? "";
            registrationData["latitude"] = seller?.latitude?.toString() ?? "";
            registrationData["longitude"] = seller?.longitude?.toString() ?? "";
            registrationData["place_name"] = seller?.placeName?.toString() ?? "";
            registrationData["formatted_address"] = seller?.formattedAddress?.toString() ?? "";
            registrationData["require_products_approval"] = seller?.requireProductsApproval?.toString() ?? "";
            registrationData["store_description"] = seller?.storeDescription?.toString() ?? "";
            registrationData["view_order_otp"] = seller?.viewOrderOtp?.toString() ?? "";
            registrationData["assign_delivery_boy"] = seller?.assignDeliveryBoy?.toString() ?? "";
            registrationData["status"] = seller?.status?.toString() ?? "";
            registrationData["store_logo"] = seller?.logoUrl?.toString() ?? "";
            registrationDataFiles["national_id_card"] = seller?.nationalIdentityCardUrl.toString() ?? "";
            registrationDataFiles["address_proof"] = seller?.addressProofUrl.toString() ?? "";
            
            registrationData["categories_array"] = seller?.categoriesArray?.toString() ?? "";
            registrationData["cities"] = seller?.cities ?? [];
            // registrationData["cities"] = (seller?.cities)?.map((e) => e.id).join(', ') ?? '';
            
          }
        });
      } else {
        context.read<CategoryListProvider>().selectedCategories.clear();
        context.read<CategoryListProvider>().selectedCategoriesNames.clear();
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
            return Stack(
              children: [
                Form(key: _formKey,
                  child: Column(
                    children: [
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
                                if (widget.from.isEmpty)
                                  Expanded(
                                    child: Divider(
                                      color: userProfileProvider.currentPage >= 2 ? ColorsRes.appColor : ColorsRes.grey,
                                      height: 5,
                                      thickness: 5,
                                    ),
                                  ),
                                if (widget.from.isEmpty)
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: userProfileProvider.currentPage >= 2 ? ColorsRes.appColor : ColorsRes.grey,
                                    child: CustomTextLabel(
                                      text: "3",
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
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                padding: EdgeInsetsDirectional.only(start: 10, end: 10, top: 5, bottom: 5),
                                margin: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 5),
                                child: CustomTextLabel(
                                  jsonKey: allFieldsAreMandatoryLabel,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (userProfileProvider.currentPage == 0)
                              SellerPersonalInformationWidget(
                                key: globalKeyPersonalInformationWidgetState,
                                personalData: registrationData,
                                personalDataFile: registrationDataFiles,
                                from: widget.from,
                              ),
                            if (widget.from.isEmpty && userProfileProvider.currentPage == 1)
                              SellerBankInformationWidget(
                                key: globalKeyBankInformationWidgetState,
                                personalData: registrationData,
                                from: widget.from,
                              ),
                            if (userProfileProvider.currentPage == 2 || (widget.from.isNotEmpty && userProfileProvider.currentPage == 1))
                              SellerStoreInformationWidget(
                                key: globalKeyStoreInformationWidgetState,
                                personalData: registrationData,
                                personalDataFile: registrationDataFiles,
                                from: widget.from,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Row(
                          children: [
                            if (userProfileProvider.currentPage != 0)
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
                                title: (userProfileProvider.currentPage == 2 || (widget.from.isNotEmpty && userProfileProvider.currentPage == 1))
                                    ? getTranslatedValue(context, saveLabel)
                                    : getTranslatedValue(context, nextLabel),
                                callback: () {
                                  if (userProfileProvider.currentPage == 0 &&
                                      /* globalKeyPersonalInformationWidgetState.currentState?. */_formKey.currentState?.validate() == true) {
                                    if (globalKeyPersonalInformationWidgetState.currentState!.edtPassword.text !=
                                        globalKeyPersonalInformationWidgetState.currentState!.edtConfirmPassword.text) {
                                      showMessage(
                                          context, getTranslatedValue(context, passwordAndConfirmPasswordDoesNotMatchLabel), MessageType.error);
                                    } else if (globalKeyPersonalInformationWidgetState.currentState!.edtMobile.text.isEmpty ||
                                        phoneValidation(globalKeyPersonalInformationWidgetState.currentState!.edtMobile.text, "") != null) {
                                      showMessage(context, getTranslatedValue(context, enterValidMobileLabel), MessageType.error);
                                    } else if (globalKeyPersonalInformationWidgetState.currentState!.edtPanNumber.text.isEmpty) {
                                      showMessage(context, getTranslatedValue(context, enterPersonalIdentityNumberLabel), MessageType.error);
                                    } else if (widget.from.isNotEmpty &&
                                        globalKeyPersonalInformationWidgetState.currentState!.edtPassword.text ==
                                            globalKeyPersonalInformationWidgetState.currentState!.edtConfirmPassword.text &&
                                        globalKeyPersonalInformationWidgetState.currentState!.edtConfirmPassword.text.trim().length < 6) {
                                      showMessage(context, getTranslatedValue(context, passwordMustBeSixCharactersLabel), MessageType.error);
                                    } else if (globalKeyPersonalInformationWidgetState.currentState!.selectedNationalIdPath.isEmpty) {
                                      showMessage(context, getTranslatedValue(context, nationalIdCardRequiredLabel), MessageType.error);
                                    } else if (globalKeyPersonalInformationWidgetState.currentState!.selectedAddressProofPath.isEmpty) {
                                      showMessage(context, getTranslatedValue(context, addressProofIsRequiredLabel), MessageType.error);
                                    } else {
                                      //Personal information store action here
                                      registrationData[ApiAndParams.name] =
                                          globalKeyPersonalInformationWidgetState.currentState?.edtUsername.text ?? "";
                                      registrationData[ApiAndParams.email] = globalKeyPersonalInformationWidgetState.currentState?.edtEmail.text ?? "";
                                      registrationData[ApiAndParams.mobile] =
                                          globalKeyPersonalInformationWidgetState.currentState?.edtMobile.text ?? "";
                      
                                      registrationData[ApiAndParams.password] =
                                          globalKeyPersonalInformationWidgetState.currentState?.edtPassword.text ?? "";
                      
                                      registrationData[ApiAndParams.confirm_password] =
                                          globalKeyPersonalInformationWidgetState.currentState?.edtConfirmPassword.text ?? "";
                      
                                      registrationData[ApiAndParams.pan_number] =
                                          globalKeyPersonalInformationWidgetState.currentState?.edtPanNumber.text ?? "";
                      
                                      if (!globalKeyPersonalInformationWidgetState.currentState!.selectedNationalIdPath.contains("https://") ||
                                          !globalKeyPersonalInformationWidgetState.currentState!.selectedNationalIdPath.contains("http://")) {
                                        registrationDataFiles[ApiAndParams.national_id_card] =
                                            globalKeyPersonalInformationWidgetState.currentState?.selectedNationalIdPath ?? "";
                                      }
                      
                                      if (!globalKeyPersonalInformationWidgetState.currentState!.selectedAddressProofPath.contains("https://") ||
                                          !globalKeyPersonalInformationWidgetState.currentState!.selectedAddressProofPath.contains("http://")) {
                                        registrationDataFiles[ApiAndParams.address_proof] =
                                            globalKeyPersonalInformationWidgetState.currentState?.selectedAddressProofPath ?? "";
                                      }
                                      Constant.session.setData(SessionManager.password, registrationData[ApiAndParams.password]!, false);
                      
                                      Constant.session
                                          .setData(SessionManager.confirmationPassword, registrationData[ApiAndParams.confirm_password]!, false);
                      
                                      userProfileProvider.moveNext();
                                    }
                                  } else if (widget.from.isEmpty &&
                                      userProfileProvider.currentPage == 1 &&
                                      /* globalKeyBankInformationWidgetState.currentState?.formKey.currentState?.validate() */_formKey.currentState?.validate() == true) {
                                    //Bank information store action here
                                    registrationData[ApiAndParams.bank_name] = globalKeyBankInformationWidgetState.currentState?.edtBankName.text ?? "";
                                    registrationData[ApiAndParams.account_number] =
                                        globalKeyBankInformationWidgetState.currentState?.edtAccountNumber.text ?? "";
                                    registrationData[ApiAndParams.ifsc_code] = globalKeyBankInformationWidgetState.currentState?.edtIFSCCode.text ?? "";
                                    registrationData[ApiAndParams.account_name] =
                                        globalKeyBankInformationWidgetState.currentState?.edtAccountName.text ?? "";
                      
                                    userProfileProvider.moveNext();
                                  } else if ((widget.from.isNotEmpty &&
                                          userProfileProvider.currentPage == 1 &&
                                          /* globalKeyStoreInformationWidgetState.currentState?.formKey.currentState?.validate() */_formKey.currentState?.validate() == true) ||
                                      userProfileProvider.currentPage == 2 &&
                                          /* globalKeyStoreInformationWidgetState.currentState?.formKey.currentState?.validate() */_formKey.currentState?.validate() == true) {
                                    //Store information store action here
                      
                                    registrationData[ApiAndParams.categories_ids] =
                                        globalKeyStoreInformationWidgetState.currentState?.edtCategoryIds.text ?? "";
                      
                                    registrationData[ApiAndParams.storeName] =
                                        globalKeyStoreInformationWidgetState.currentState?.edtStoreName.text ?? "";
                      
                                    if (globalKeyStoreInformationWidgetState.currentState?.edtStoreUrl.text != null) {
                                      registrationData[ApiAndParams.store_url] = globalKeyStoreInformationWidgetState.currentState!.edtStoreUrl.text;
                                    } else if (globalKeyStoreInformationWidgetState.currentState!.selectedLogoPath.isEmpty) {
                                      showMessage(context, getTranslatedValue(context, logoIsRequiredLabel), MessageType.error);
                                    }
                      
                                    registrationData[ApiAndParams.commission] = Constant.sellerCommission.toString();
                      
                                    if ((!globalKeyStoreInformationWidgetState.currentState!.selectedLogoPath.contains("https://") ||
                                            !globalKeyStoreInformationWidgetState.currentState!.selectedLogoPath.contains("http://")) &&
                                        globalKeyStoreInformationWidgetState.currentState!.selectedLogoPath.isEmpty) {
                                      showMessage(context, getTranslatedValue(context, logoIsRequiredLabel), MessageType.error);
                                    } else {
                                      if (!globalKeyStoreInformationWidgetState.currentState!.selectedLogoPath.contains("https://") ||
                                          !globalKeyStoreInformationWidgetState.currentState!.selectedLogoPath.contains("http://")) {
                                        registrationDataFiles[ApiAndParams.store_logo] =
                                            globalKeyStoreInformationWidgetState.currentState?.selectedLogoPath ?? "";
                                      }
                      
                                      registrationData[ApiAndParams.store_description] =
                                          globalKeyStoreInformationWidgetState.currentState?.edtStoreDescription ?? "";
                      
                                      registrationData[ApiAndParams.tax_name] =
                                          globalKeyStoreInformationWidgetState.currentState?.edtTaxName.text ?? "";
                                      registrationData[ApiAndParams.tax_number] =
                                          globalKeyStoreInformationWidgetState.currentState?.edtTaxName.text ?? "";
                                      registrationData.remove(ApiAndParams.cities);
                                      registrationData.remove(ApiAndParams.categoriesName);
                      
                                      /*
                                1. Personal Information
                                name
                                email
                                mobile
                                pan_number
                                address_proof //file
                                national_id_card //file
                      
                                2. Store Information
                                store_url
                                store_name
                                categories_ids
                                tax_name
                                tax_number
                                store_description
                                store_logo //file
                      
                                3.Bank Information
                                account_number
                                ifsc_code
                                bank_name
                                account_name
                      
                                4. Store Location Information
                                street
                                city_id
                                state
                                latitude
                                longitude
                                place_name
                                formatted_address
                                */
                      
                                      if (userProfileProvider.currentPage == 2 || (widget.from.isNotEmpty && userProfileProvider.currentPage == 1)) {
                                        userProfileProvider.updateUserApiProvider(
                                          context: context,
                                          params: registrationData,
                                          from: widget.from,
                                          fileParamsFilesPath: registrationDataFiles,
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
                                    }
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
