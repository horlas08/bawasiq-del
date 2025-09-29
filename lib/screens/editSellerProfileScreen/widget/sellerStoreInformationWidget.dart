import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:project/helper/generalWidgets/bottomSheetMultipleCategorySelectionWidget.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/cities.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class SellerStoreInformationWidget extends StatefulWidget {
  final String from;
  final Map<String, dynamic> personalData;
  final Map<String, String> personalDataFile;

  const SellerStoreInformationWidget(
      {Key? key,
      required this.personalData,
      required this.personalDataFile,
      required this.from})
      : super(key: key);

  @override
  State<SellerStoreInformationWidget> createState() =>
      SellerStoreInformationWidgetState();
}

class SellerStoreInformationWidgetState
    extends State<SellerStoreInformationWidget> {
  QuillEditorController quillEditorController = QuillEditorController();
  late TextEditingController edtCategoriesName,
      edtCategoryIds,
      edtStoreName,
      edtStoreUrl,
      edtTaxName,
      edtTaxNumber,
      edtCommission,
      edtStoreAddress,
      edtSelectCity,
      edtCitiesName;

  String edtStoreDescription = "";

  String selectedLogoPath = "";

  final formKey = GlobalKey<FormState>();
  String result = '';
  final QuillEditorController controller = QuillEditorController();

  @override
  void initState() {
    /* edtCategoriesName = TextEditingController(
      text: widget.personalData[ApiAndParams.categoriesName] == null
          ? Constant.session.getData(SessionManager.categoriesName)
          : widget.personalData[ApiAndParams.categoriesName],
    ); */
    edtCategoriesName = TextEditingController(
      text: widget.personalData[ApiAndParams.categoriesName] == null
          ? Constant.session.getData(SessionManager.categoriesName)
          : widget.personalData[ApiAndParams.categoriesName],
    );
     edtCitiesName = TextEditingController(
        text: (widget.personalData[ApiAndParams.cities] as List<Cities>?)
                ?.map((e) => e.name)
                .join(', ') ??
            '');
    edtCategoryIds = TextEditingController(
      text: widget.personalData[ApiAndParams.categories] == null
          ? Constant.session.getData(SessionManager.categories)
          : widget.personalData[ApiAndParams.categories],
    );
    edtStoreName = TextEditingController(
      text: widget.personalData[ApiAndParams.storeName] == null
          ? Constant.session.getData(SessionManager.store_name)
          : widget.personalData[ApiAndParams.storeName],
    );
    edtStoreUrl = TextEditingController(
      text: widget.personalData[ApiAndParams.store_url] == null
          ? "-"
          : widget.personalData[ApiAndParams.store_url],
    );
    selectedLogoPath = widget.personalDataFile[ApiAndParams.store_logo] == null
        ? Constant.session.getData(SessionManager.logo_url)
        : widget.personalDataFile[ApiAndParams.store_logo].toString();

    edtStoreDescription =
        (widget.personalData[ApiAndParams.store_description] == null
            ? Constant.session.getData(SessionManager.store_description)
            : widget.personalData[ApiAndParams.store_description])!;

    edtCommission = TextEditingController(
      text: Constant.sellerCommission,
    );

    edtTaxName = TextEditingController(
      text: widget.personalData[ApiAndParams.tax_name] == null
          ? Constant.session.getData(SessionManager.tax_name)
          : widget.personalData[ApiAndParams.tax_name],
    );
    edtTaxNumber = TextEditingController(
      text: widget.personalData[ApiAndParams.tax_number] == null
          ? Constant.session.getData(SessionManager.tax_number)
          : widget.personalData[ApiAndParams.tax_number],
    );

    edtSelectCity = TextEditingController(
      text: widget.personalData[ApiAndParams.state] == null
          ? Constant.session.getData(SessionManager.city_id)
          : widget.personalData[ApiAndParams.city_id],
    );

    edtStoreAddress = TextEditingController();

    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: ColorsRes.appColorTransparent,
      shape: DesignConfig.setRoundedBorder(7),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Constant.paddingOrMargin10,
          vertical: Constant.paddingOrMargin10,
        ),
        child:/*  Form(
          key: formKey,
          child: */ Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextLabel(
                jsonKey: storeInformationLabel,
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
              Consumer(
                builder: (context, value, child) {
                  return editBoxWidget(
                    context: context,
                    edtController: edtCategoriesName,
                    validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterCategoryIdsLabel)),
                    label: getTranslatedValue(context, categoryIdsLabel),
                    inputType: TextInputType.none,
                    nonFocusable: true,
                    tailIcon: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<Map<String, String>>(
                          backgroundColor: Theme.of(context).cardColor,
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: DesignConfig.setRoundedBorderSpecific(20,
                              istop: true),
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: Constant.paddingOrMargin15,
                                  end: Constant.paddingOrMargin15,
                                  top: Constant.paddingOrMargin15,
                                  bottom: Constant.paddingOrMargin15),
                              child:
                                  BottomSheetMultipleCategorySelectionWidget(),
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            edtCategoriesName.text = value["names"]!;
                            edtCategoryIds.text = value["ids"]!;
                          }
                          setState(() {});
                        });
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: defaultImg(
                          image: AppAssets.selectCategoriesIcon,
                          iconColor: ColorsRes.appColor,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtStoreName,
                validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterStoreNameLabel)),
                label: getTranslatedValue(context, storeNameLabel),
                inputType: TextInputType.text,
              ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtStoreUrl,
                validationFunction: (value)=> optionalFieldValidation("",  ""),
                label: getTranslatedValue(context, storeUrlLabel),
                inputType: TextInputType.text,
              ),
              // getSizedBox(
              //   height: 10,
              // ),
              // editBoxWidget(
              //   context: context,
              //   edtController: edtCommission,
              //   validationFunction: percentageValidation,
              //   label: getTranslatedValue(context, commissionLabel),
              //   inputType: TextInputType.number,
              //   isEditable: false,
              // ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtTaxName,
                validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterTaxNameLabel)),
                label: getTranslatedValue(context, taxNameLabel),
                inputType: TextInputType.text,
              ),
              getSizedBox(
                height: 10,
              ),
              editBoxWidget(
                context: context,
                edtController: edtTaxNumber,
                validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterTaxNumberLabel)),
                label: getTranslatedValue(context, taxNumberLabel),
                inputType: TextInputType.text,
              ),
              getSizedBox(
                height: 10,
              ),
              Row(
                children: [
                  if (selectedLogoPath.isNotEmpty)
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
                        child: imgWidget(selectedLogoPath),
                      ),
                    ),
                  if (selectedLogoPath.isNotEmpty) getSizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Single file path
                        /* FilePicker.platform
                            .pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ["jpg", "jpeg", "png"],
                                lockParentWindow: true)
                            .then((value) {
                          if (value != null) {
                            cropImage(value.paths.first.toString());
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
                            cropImage(savedFile!.path.toString());
                            // selectedPath = savedFile!.path.toString();
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
                                  jsonKey: uploadLogoFileHereLabel,
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
              getSizedBox(
                height: 10,
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.sizeOf(context).width,
                  minHeight: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: ColorsRes.subTitleTextColor,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(10),
                      child: QuillHtmlEditor(
                        text: edtStoreDescription.isEmpty
                            ? getTranslatedValue(
                                context, descriptionGoesHereLabel)
                            : edtStoreDescription,
                        hintText: getTranslatedValue(
                            context, descriptionGoesHereLabel),
                        isEnabled: false,
                        ensureVisible: false,
                        minHeight: 10,
                        autoFocus: false,
                        textStyle: TextStyle(color: ColorsRes.mainTextColor),
                        hintTextStyle:
                            TextStyle(color: ColorsRes.subTitleTextColor),
                        hintTextAlign: TextAlign.start,
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 2, top: 2),
                        hintTextPadding: const EdgeInsets.only(left: 20),
                        backgroundColor: Theme.of(context).cardColor,
                        inputAction: InputAction.newline,
                        loadingBuilder: (context) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorsRes.appColor,
                            ),
                          );
                        },
                        controller: quillEditorController,
                      ),
                    ),
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, htmlEditorScreen,
                                  arguments: edtStoreDescription)
                              .then(
                            (value) {
                              if (value != null) {
                                edtStoreDescription = value.toString();
                                setState(
                                  () {},
                                );
                              }
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: ColorsRes.appColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // if (widget.from.isNotEmpty)
                getSizedBox(
                  height: 10,
                ),
              // if (widget.from.isNotEmpty)
                editBoxWidget(
                  context: context,
                  edtController: edtCitiesName,
                  validationFunction: (value)=> emptyValidation(value!,  getTranslatedValue(context, enterSelectCityLabel)),
                  label: getTranslatedValue(context, selectCityLabel),
                  inputType: TextInputType.none,
                  tailIcon: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, cityListScreen, arguments: false).then(
                        (value) {
                          /* if (value is Cities) {
                            widget.personalData.addAll({
                              ApiAndParams.address:
                                  value.formattedAddress.toString(),
                              ApiAndParams.city_id: value.id.toString(),
                            });
                            edtSelectCity.text =
                                value.formattedAddress.toString();
                          } */
                         if (value is List<Cities>) {
                          widget.personalData.addAll({
                            ApiAndParams.city_id: value.map((e) => e.id).join(','),
                            ApiAndParams.address: value.map((e) => e.formattedAddress).join(', '),
                          });

                          edtSelectCity.text = value.map((e) => e.formattedAddress).join(', ');
                          edtCitiesName.text = value.map((e) => e.name).join(', ');
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

  Future<void> cropImage(String filePath) async {
    await ImageCropper()
        .cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 1024,
      maxWidth: 1024,
    )
        .then((croppedFile) {
      if (croppedFile != null) {
        setState(() {
          selectedLogoPath = croppedFile.path;
        });
      }
    });
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