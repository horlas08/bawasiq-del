import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/cities.dart';
import 'package:project/provider/passwordShowHideProvider.dart';

enum EarningType { commission, salaried }

class DeliveryBoyPersonalInformationWidget extends StatefulWidget {
  final String from;
  final Map<String, dynamic> personalData;
  final Map<String, String> personalDataFile;

  const DeliveryBoyPersonalInformationWidget(
      {Key? key,
      required this.personalData,
      required this.personalDataFile,
      required this.from})
      : super(key: key);

  @override
  State<DeliveryBoyPersonalInformationWidget> createState() =>
      DeliveryBoyPersonalInformationWidgetState();
}

class DeliveryBoyPersonalInformationWidgetState
    extends State<DeliveryBoyPersonalInformationWidget> {
  late TextEditingController edtDeliveryBoyUsername,
      edtDeliveryBoyEmail,
      edtDeliveryBoyMobile,
      edtDeliveryBoyDateOfBirth,
      edtDeliveryBoyAddress,
      edtPassword,
      edtConfirmPassword,
      edtDeliveryBoyCommission;

  String selectedNationalIdProof = "";
  String selectedDrivingLicense = "";

  final formKey = GlobalKey<FormState>();

  EarningType earningType = EarningType.commission;

  @override
  void initState() {
    edtDeliveryBoyUsername = TextEditingController(
      text: widget.personalData[ApiAndParams.name],
    );
    edtDeliveryBoyMobile = TextEditingController(
      text: widget.personalData[ApiAndParams.mobile],
    );
    edtDeliveryBoyEmail = TextEditingController(
      text: widget.personalData[ApiAndParams.email],
    );
    edtDeliveryBoyDateOfBirth = TextEditingController(
      text: widget.personalData[ApiAndParams.dob],
    );

    widget.personalDataFile[ApiAndParams.national_identity_card] = widget
                .personalDataFile[ApiAndParams.national_identity_card]
                .toString() !=
            "null"
        ? "${Constant.hostUrl}storage/${widget.personalData[ApiAndParams.national_identity_card]}"
        : "";
    widget.personalDataFile[ApiAndParams.driving_license] = widget
                .personalDataFile[ApiAndParams.driving_license]
                .toString() !=
            "null"
        ? "${Constant.hostUrl}storage/${widget.personalData[ApiAndParams.driving_license]}"
        : "";

    selectedNationalIdProof = widget
                .personalData[ApiAndParams.national_identity_card]
                .toString() !=
            "null"
        ? "${Constant.hostUrl}storage/${widget.personalData[ApiAndParams.national_identity_card]}"
        : "";

    selectedDrivingLicense = widget.personalData[ApiAndParams.driving_license]
                .toString() !=
            "null"
        ? "${Constant.hostUrl}storage/${widget.personalData[ApiAndParams.driving_license]}"
        : "";

    /* edtDeliveryBoyAddress = TextEditingController(
      text: widget.personalData[ApiAndParams.address],
    ); */
     edtDeliveryBoyAddress = TextEditingController(
        text: (widget.personalData['cities'] as List<Cities>?)?.map((e) => e.name).first.toString() ??
            widget.personalData[ApiAndParams.address] ??
            ""); // Use the first city name or the address if cities is empty

    edtDeliveryBoyCommission = TextEditingController(
        text: widget.personalData[ApiAndParams.bonusPercentage]);

    earningType = widget.personalData[ApiAndParams.bonusType] == "0"
        ? EarningType.salaried
        : EarningType.commission;
    edtPassword = TextEditingController();
    edtConfirmPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: ColorsRes.appColorTransparent,
      elevation: 0,
      child: Padding(
        padding: EdgeInsetsDirectional.all(15),
        child: /* Form(
          key: formKey,
          child: */ Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextLabel(
                jsonKey: personalInformationLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: ColorsRes.mainTextColor,
                ),
              ),
              getSizedBox(height: 10),
              Divider(
                  height: 1,
                  color: ColorsRes.grey.withValues(alpha: 0.5),
                  thickness: 1),
              getSizedBox(height: 10),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyUsername,
                validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterUserNameLabel)),
                label: getTranslatedValue(context, userNameLabel),
                inputType: TextInputType.text,
              ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyEmail,
                validationFunction: (value)=> emailValidation(value!,  getTranslatedValue(context, enterEmailLabel)),
                label: getTranslatedValue(context, emailLabel),
                inputType: TextInputType.text,
              ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyDateOfBirth,
                validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterDateOfBirthLabel)),
                label: getTranslatedValue(context, dateOfBirthLabel),
                inputType: TextInputType.none,
                tailIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          keyboardType: TextInputType.datetime,
                          firstDate: DateTime(1800),
                          lastDate: DateTime.now(),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            // format date in required form here we use yyyy-MM-dd that means time is removed
                            edtDeliveryBoyDateOfBirth.text =
                                DateFormat('dd-MM-yyyy').format(selectedDate);
                          } else {
                            edtDeliveryBoyDateOfBirth.text = "";
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: defaultImg(
                          image: AppAssets.datePickerIcon,
                          iconColor: ColorsRes.appColor,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtDeliveryBoyMobile,
                validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterValidMobileLabel)),
                label: getTranslatedValue(context, mobileLabel),
                inputType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CustomNumberTextInputFormatter()
                ],
              ),
              getSizedBox(
                height: 10,
              ),
              if (widget.from.isEmpty)
                CustomTextLabel(
                  jsonKey: keepBlankIfDontWantToChangePasswordLabel,
                  softWrap: true,
                  style: TextStyle(
                    color: ColorsRes.appColorRed,
                    fontSize: 12,
                  ),
                ),
              if (widget.from.isEmpty)
                getSizedBox(
                  height: 5,
                ),
              ChangeNotifierProvider<PasswordShowHideProvider>(
                create: (context) => PasswordShowHideProvider(),
                child: Consumer<PasswordShowHideProvider>(
                  builder: (context, passwordShowHideProvider, child) {
                    return editBoxWidget(
                      context: context,
                      edtController: edtPassword,
                      validationFunction: (val) => widget.from == "registration" ? passwordValidation(val, getTranslatedValue(context, enterPasswordLabel)) : optionalFieldValidation(val!, getTranslatedValue(context, enterPasswordLabel)),
                      label: getTranslatedValue(context, passwordLabel),
                      inputType: TextInputType.text,
                      tailIcon: GestureDetector(
                        onTap: () {
                          passwordShowHideProvider.showHidePassword();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            child: defaultImg(
                              image:
                                  passwordShowHideProvider.hidePassword == true
                                      ? AppAssets.hidePasswordIcon
                                      : AppAssets.showPasswordIcon,
                              iconColor: ColorsRes.appColor,
                            ),
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ),
                      ishidetext: passwordShowHideProvider.hidePassword == true,
                      maxlines: 1,
                    );
                  },
                ),
              ),
              getSizedBox(
                height: 10,
              ),
              if (widget.from.isEmpty)
                CustomTextLabel(
                  jsonKey: keepBlankIfDontWantToChangePasswordLabel,
                  softWrap: true,
                  style: TextStyle(
                    color: ColorsRes.appColorRed,
                    fontSize: 12,
                  ),
                ),
              if (widget.from.isEmpty)
                getSizedBox(
                  height: 5,
                ),
              ChangeNotifierProvider<PasswordShowHideProvider>(
                create: (context) => PasswordShowHideProvider(),
                child: Consumer<PasswordShowHideProvider>(
                  builder: (context, passwordShowHideProvider, child) {
                    return editBoxWidget(
                        context: context,
                        edtController: edtConfirmPassword,
                        validationFunction: (val) => widget.from == "registration" ? (val != edtPassword.text ? getTranslatedValue(context, passwordAndConfirmPasswordDoesNotMatchLabel) : null) : optionalFieldValidation(val!, getTranslatedValue(context, enterPasswordLabel)),
                        label: getTranslatedValue(context, confirmPasswordLabel),
                        inputType: TextInputType.text,
                        tailIcon: GestureDetector(
                          onTap: () {
                            passwordShowHideProvider.showHidePassword();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              child: defaultImg(
                                image: passwordShowHideProvider.hidePassword ==
                                        true
                                    ? AppAssets.hidePasswordIcon
                                    : AppAssets.showPasswordIcon,
                                iconColor: ColorsRes.appColor,
                              ),
                              height: 10,
                              width: 10,
                            ),
                          ),
                        ),
                        ishidetext:
                            passwordShowHideProvider.hidePassword == true,
                        maxlines: 1);
                  },
                ),
              ),
              getSizedBox(
                height: 10,
              ),
              if (widget.from.isNotEmpty)
                //National Id Proof
                CustomTextLabel(
                  jsonKey: nationalIdentificationCardLabel,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (widget.from.isNotEmpty)
                getSizedBox(
                  height: 10,
                ),
              if (widget.from.isNotEmpty)
                Row(
                  children: [
                    if (selectedNationalIdProof.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorsRes.subTitleTextColor,
                            ),
                            color: Theme.of(context).cardColor),
                        height: 105,
                        width: 105,
                        child: Center(
                          child: imgWidget(selectedNationalIdProof),
                        ),
                      ),
                    if (selectedNationalIdProof.isNotEmpty)
                      getSizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // Single file path
                          /* FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false,
                                  allowCompression: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    "pdf",
                                    "jpg",
                                    "jpeg",
                                    "png"
                                  ],
                                  lockParentWindow: true)
                              .then((value) {
                            if (value != null) {
                              selectedNationalIdProof =
                                  value.paths.first.toString();
                              setState(() {});
                            }
                          }); */
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                          );

                          if (result != null && result.files.single.path != null) {
                            File pickedFile = File(result.files.single.path!);
                            print("Selected file path: ${pickedFile.path}");

                            // Check if file exists
                            if (!await pickedFile.exists()) {
                              print("File does not exist: ${pickedFile.path}");
                              return;
                            }

                            // Move file to a persistent location
                            File? savedFile = await saveFileToLocalStorage(pickedFile);

                            // Set state if valid
                            setState(() {
                              selectedNationalIdProof = savedFile!.path.toString();
                            });

                            print("File ready for upload: ${savedFile!.path}");
                          } else {
                            print("No file selected");
                          }
                        },
                        child: DottedBorder(
                          /* dashPattern: [5],
                          strokeWidth: 2,
                          strokeCap: StrokeCap.round,
                          color: ColorsRes.subTitleTextColor,
                          radius: Radius.circular(10),
                          borderType: BorderType.RRect, */
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [5],
                            strokeWidth: 2,
                            radius: Radius.circular(10),
                            color: ColorsRes.subTitleTextColor,
                            // padding: EdgeInsets.all(16),
                          ),
                          child: Container(
                            height: 100,
                            color: ColorsRes.appColorTransparent,
                            padding: EdgeInsetsDirectional.all(10),
                            child: Center(
                              child: Column(
                                children: [
                                  defaultImg(
                                    image: AppAssets.uploadIcon,
                                    iconColor: ColorsRes.subTitleTextColor,
                                    height: 40,
                                    width: 40,
                                  ),
                                  CustomTextLabel(
                                    jsonKey: uploadNidFileHereLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ColorsRes.subTitleTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.from.isNotEmpty)
                getSizedBox(
                  height: 10,
                ),
              if (widget.from.isNotEmpty)
                //National Id Proof
                CustomTextLabel(
                  jsonKey: drivingLicenseLabel,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (widget.from.isNotEmpty)
                getSizedBox(
                  height: 10,
                ),
              if (widget.from.isNotEmpty)
                Row(
                  children: [
                    if (selectedDrivingLicense.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorsRes.subTitleTextColor,
                            ),
                            color: Theme.of(context).cardColor),
                        height: 105,
                        width: 105,
                        child: Center(
                          child: imgWidget(selectedDrivingLicense),
                        ),
                      ),
                    getSizedBox(
                      height: 10,
                    ),
                    if (selectedDrivingLicense.isNotEmpty)
                      getSizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // Single file path
                          /* FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false,
                                  allowCompression: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    "pdf",
                                    "jpg",
                                    "jpeg",
                                    "png"
                                  ],
                                  lockParentWindow: true)
                              .then((value) {
                            if (value != null) {
                              selectedDrivingLicense =
                                  value.paths.first.toString();
                              setState(() {});
                            }
                          }); */
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                          );

                          if (result != null && result.files.single.path != null) {
                            File pickedFile = File(result.files.single.path!);
                            print("Selected file path: ${pickedFile.path}");

                            // Check if file exists
                            if (!await pickedFile.exists()) {
                              print("File does not exist: ${pickedFile.path}");
                              return;
                            }

                            // Move file to a persistent location
                            File? savedFile = await saveFileToLocalStorage(pickedFile);

                            // Set state if valid
                            setState(() {
                              selectedDrivingLicense = savedFile!.path.toString();
                            });

                            print("File ready for upload: ${savedFile!.path}");
                          } else {
                            print("No file selected");
                          }
                        },
                        child: DottedBorder(
                          /* dashPattern: [5],
                          strokeWidth: 2,
                          strokeCap: StrokeCap.round,
                          color: ColorsRes.subTitleTextColor,
                          radius: Radius.circular(10),
                          borderType: BorderType.RRect, */
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [5],
                            strokeWidth: 2,
                            radius: Radius.circular(10),
                            color: ColorsRes.subTitleTextColor,
                            // padding: EdgeInsets.all(16),
                          ),
                          child: Container(
                            height: 100,
                            color: ColorsRes.appColorTransparent,
                            padding: EdgeInsetsDirectional.all(10),
                            child: Center(
                              child: Column(
                                children: [
                                  defaultImg(
                                    image: AppAssets.uploadIcon,
                                    iconColor: ColorsRes.subTitleTextColor,
                                    height: 40,
                                    width: 40,
                                  ),
                                  CustomTextLabel(
                                    jsonKey: uploadDrivingLicenseFileHereLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ColorsRes.subTitleTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.from.isNotEmpty)
                getSizedBox(
                  height: 10,
                ),
              getSizedBox(height: 10),
              // if (widget.from.isNotEmpty)
                editBoxWidget(
                  context: context,
                  edtController: edtDeliveryBoyAddress,
                  validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterSelectCityLabel)),
                  label: getTranslatedValue(context, selectCityLabel),
                  inputType: TextInputType.none,
                  tailIcon: IconButton(
                    onPressed: () {
                      /* Navigator.pushNamed(context, cityListScreen).then(
                        (value) {
                          if (value is Cities) {
                            widget.personalData.addAll({
                              ApiAndParams.city_id: value.id.toString(),
                            });
                            edtDeliveryBoyAddress.text =
                                value.formattedAddress.toString();
                          }
                        },
                      ); */
                      Navigator.pushNamed(context, cityListScreen, arguments: true).then(
                        (value) {
                          if (value is Cities) {
                            widget.personalData.addAll({
                              ApiAndParams.address: value.formattedAddress.toString(),
                              ApiAndParams.city_id: value.id.toString(),
                            });

                            edtDeliveryBoyAddress.text = value.name.toString();

                            setState(() {});
                          }
                        },
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: ColorsRes.appColor,
                    ),
                  ),
                ),
              getSizedBox(
                height: 10,
              ),
              getSizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 10, top: 10),
                      child: CustomTextLabel(
                        jsonKey: earningTypeLabel,
                        style: TextStyle(
                          color: ColorsRes.mainTextColor.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              earningType = EarningType.commission;
                              setState(() {});
                            },
                            child: Container(
                              color: ColorsRes.appColorTransparent,
                              child: Row(
                                children: [
                                  Radio<EarningType>(
                                    value: earningType,
                                    groupValue: EarningType.commission,
                                    onChanged: (value) {
                                      earningType = EarningType.commission;
                                      setState(() {});
                                    },
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  CustomTextLabel(
                                    jsonKey: earningTypeCommissionLabel,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              earningType = EarningType.salaried;
                              setState(() {});
                            },
                            child: Container(
                              color: ColorsRes.appColorTransparent,
                              child: Row(
                                children: [
                                  Radio<EarningType>(
                                    value: earningType,
                                    groupValue: EarningType.salaried,
                                    onChanged: (value) {
                                      earningType = EarningType.salaried;
                                      setState(() {});
                                    },
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  CustomTextLabel(
                                    jsonKey: earningTypeSalariedLabel,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (earningType == EarningType.commission)
                getSizedBox(
                  height: 10,
                ),
              if (earningType == EarningType.commission)
                editBoxWidget(
                  context: context,
                  isEditable: widget.from==""?false:true,
                  edtController: edtDeliveryBoyCommission,
                  validationFunction: (value)=> widget.from==""?optionalFieldValidation("", ""):percentageValidation(value!,  getTranslatedValue(context, enterCommissionLabel)),
                  label: getTranslatedValue(context, commissionTitleLabel),
                  hint: getTranslatedValue(context, commissionHintLabel),
                  inputType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                ),
              if (widget.from.isEmpty)
                getSizedBox(
                  height: 10,
                ),
              if (widget.from.isEmpty)
                editBoxWidget(
                  context: context,
                  edtController: edtDeliveryBoyAddress,
                  validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterSelectCityLabel)),
                  label: getTranslatedValue(context, selectCityLabel),
                  inputType: TextInputType.none,
                  tailIcon: IconButton(
                    onPressed: () {
                      /* Navigator.pushNamed(context, cityListScreen).then(
                            (value) {
                          if (value is Cities) {
                            Map<String, String> tempMap =
                            value as Map<String, String>;

                            widget.personalData.addAll({
                              ApiAndParams.address:
                              value.formattedAddress.toString(),
                              ApiAndParams.city_id: value.id.toString(),
                            });
                            edtDeliveryBoyAddress.text =
                                tempMap[ApiAndParams.formatted_address]
                                    .toString();
                          }
                        },
                      ); */
                      Navigator.pushNamed(context, cityListScreen, arguments: true).then(
                        (value) {
                          if (value is Cities) {
                            widget.personalData.addAll({
                              ApiAndParams.address: value.formattedAddress.toString(),
                              ApiAndParams.city_id: value.id.toString(),
                            });

                            edtDeliveryBoyAddress.text = value.name.toString();

                            setState(() {});
                          }
                        },
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: ColorsRes.appColor,
                    ),
                  ),
                ),
            ],
          )/* ,
        ), */
      ),
    );
  }

  imgWidget(String fileName) {
    return GestureDetector(
      onTap: () {
        try {
          OpenFilex.open(fileName);
        } catch (e) {
          showMessage(context, e.toString(), MessageType.error);
        }
      },
      child: fileName.split(".").last == "pdf"
          ? Center(
              child: defaultImg(
                image: AppAssets.pdfIcon,
                height: 50,
                width: 50,
              ),
            )
          : ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: (fileName.contains("https://") ||
                      fileName.contains("http://"))
                  ? setNetworkImg(
                      image: fileName,
                      width: 90,
                      height: 90,
                      boxFit: BoxFit.fill,
                    )
                  : Image.file(
                      File(fileName),
                      fit: BoxFit.cover,
                    ),
            ),
    );
  }
}