import 'dart:io' as io;

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:project/helper/utils/generalImports.dart';

class ProductBulkUploadScreen extends StatefulWidget {
  final String from;

  ProductBulkUploadScreen({Key? key, required this.from}) : super(key: key);

  @override
  State<ProductBulkUploadScreen> createState() =>
      _ProductBulkUploadScreenState();
}

class _ProductBulkUploadScreenState extends State<ProductBulkUploadScreen> {
  String selectedPath = "";

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: widget.from == "upload"
              ? titleProductsBulkUploadLabel
              : titleProductsBulkUpdateLabel,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSizedBox(height: 10),
                  CustomTextLabel(
                    jsonKey: bulkUploadTitleLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorsRes.mainTextColor,
                      fontSize: 22,
                    ),
                  ),
                  getSizedBox(height: 20),
                  buildNumberedList(
                    context: context,
                    items: [
                      {"title": "point_1", "message": "step_1"},
                      {"title": "point_2", "message": "step_2"},
                      {"title": "point_3", "message": "step_3"},
                    ],
                  ),
                  getSizedBox(height: 20),
                  // Display note for mandatory fields
                  CustomTextLabel(
                    jsonKey: mandatoryFieldsNoteLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorsRes.appColorRed,
                    ),
                  ),
                  getSizedBox(height: 20),
                  // Display the bulleted list with the product fields and descriptions
                  buildBulletList(context: context, items: [
                    {
                      "title": productNameTitleLabel,
                      "message": productNameMessageLabel
                    },
                    {
                      "title": categoryIdTitleLabel,
                      "message": categoryIdMessageLabel
                    },
                    {
                      "title": indicatorTitleLabel,
                      "message": indicatorMessageLabel
                    },
                    {
                      "title": manufacturerTitleLabel,
                      "message": manufacturerMessageLabel
                    },
                    {
                      "title": madeInTitleLabel, 
                      "message": madeInMessageLabel
                    },
                    {
                      "title": isReturnableTitleLabel,
                      "message": isReturnableMessageLabel
                    },
                    {
                      "title": isCancelableTitleLabel,
                      "message": isCancelableMessageLabel
                    },
                    {
                      "title": tillStatusTitleLabel,
                      "message": tillStatusMessageLabel
                    },
                    {
                      "title": descriptionTitleLabel,
                      "message": descriptionMessageLabel
                    },
                    {
                      "title": imageTitleLabel, 
                      "message": imageMessageLabel
                    },
                    {
                      "title": sellerIdTitleLabel,
                      "message": sellerIdMessageLabel
                    },
                    {
                      "title": isApprovedTitleLabel,
                      "message": isApprovedMessageLabel
                    },
                    {
                      "title": taxIdTitleLabel, 
                      "message": taxIdMessageLabel
                    },
                    {
                      "title": fssaiNoTitleLabel, 
                      "message": fssaiNoMessageLabel
                    },
                    {
                      "title": variantTypeTitleLabel,
                      "message": variantTypeMessageLabel
                    },
                    {
                      "title": variantMeasurementTitleLabel,
                      "message": variantMeasurementMessageLabel
                    },
                    {
                      "title": variantMeasurementUnitIdTitleLabel,
                      "message": variantMeasurementUnitIdMessageLabel
                    },
                    {
                      "title": variantPriceTitleLabel,
                      "message": variantPriceMessageLabel
                    },
                    {
                      "title": variantDiscountedPriceTitleLabel,
                      "message": variantDiscountedPriceMessageLabel
                    },
                    {
                      "title": variantAvailabilityTitleLabel,
                      "message": variantAvailabilityMessageLabel
                    },
                    {
                      "title": variantStockTitleLabel,
                      "message": variantStockMessageLabel
                    },
                    {
                      "title": variantStockUnitIdTitleLabel,
                      "message": variantStockUnitIdMessageLabel
                    },
                    {
                      "title": deliverableNoteTitleLabel,
                      "message": deliverableNoteMessageLabel
                    },
                    {
                      "title": emptyFieldNoteTitleLabel,
                      "message": emptyFieldNoteMessageLabel
                    },
                  ]),
                  getSizedBox(height: 130),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Container(
              padding: EdgeInsetsDirectional.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsRes.subTitleTextColor.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  getSizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Single file path
                          /* FilePicker.platform
                              .pickFiles(
                            allowMultiple: false,
                            allowCompression: true,
                            type: FileType.custom,
                            allowedExtensions: ["csv"],
                            lockParentWindow: true,
                          )
                              .then(
                            (value) {
                              if (value != null) {
                                selectedPath = value.paths.first.toString();
                                setState(() {});
                              }
                            },
                          ); */
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.any,
                            // allowedExtensions: ['csv'],//'jpg', 'jpeg', 'png', 
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
                              selectedPath = savedFile!.path.toString();
                            });
      
                            print("File ready for upload: ${savedFile!.path}");
                          } else {
                            print("No file selected");
                          }
                        },
                        child: Container(
                          padding: EdgeInsetsDirectional.only(
                              start: 15, end: 15, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsRes.appColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: CustomTextLabel(
                            jsonKey: selectFileLabel,
                            style: TextStyle(
                              color: ColorsRes.appColor,
                            ),
                          ),
                        ),
                      ),
                      getSizedBox(width: 10),
                      Expanded(
                        child: CustomTextLabel(
                          text: selectedPath.isEmpty
                              ? getTranslatedValue(context, noFileChosenLabel)
                              : selectedPath.split("/").last,
                        ),
                      ),
                      if (selectedPath.isNotEmpty) getSizedBox(width: 10),
                      if (selectedPath.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            selectedPath = "";
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: ColorsRes.subTitleTextColor,
                          ),
                        )
                    ],
                  ),
                  getSizedBox(height: 5),
                  Divider(
                    thickness: 1,
                    color: ColorsRes.subTitleTextColor.withValues(alpha: 0.2),
                  ),
                  getSizedBox(height: 5),
                  Consumer<ProductBulkOperationsProvider>(
                    builder: (__, productBulkOperationsProvider, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                productBulkOperationsProvider
                                    .getProductDownloadExcel(
                                  context: context,
                                  from : widget.from,
                                ).then(
                                  (htmlContent) async {
                                    try {
                                      if (htmlContent != null) {
                                        final appDocDirPath = io
                                                .Platform.isAndroid
                                            ? (await ExternalPath
                                                .getExternalStoragePublicDirectory(
                                                    ExternalPath
                                                        .DIRECTORY_DOWNLOAD))
                                            : (await getApplicationDocumentsDirectory())
                                                .path;
      
                                        final targetFileName =
                                            "${getTranslatedValue(context, widget.from == "upload" ? sampleProductsCsvFileLabel : allProductsCsvFileLabel)}_${DateTime.now().microsecondsSinceEpoch}.csv";
      
                                        io.File file = io.File(
                                            "$appDocDirPath/$targetFileName");
      
                                        // Write down the file as bytes from the bytes got from the HTTP request.
                                        await file.writeAsBytes(htmlContent,
                                            flush: false);
                                        await file.writeAsBytes(htmlContent);
      
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          action: SnackBarAction(
                                            label: getTranslatedValue(
                                                context, showFileLabel),
                                            textColor: ColorsRes.mainTextColor,
                                            onPressed: () {
                                              OpenFilex.open(file.path);
                                            },
                                          ),
                                          content: CustomTextLabel(
                                            jsonKey: fileSavedSuccessfullyLabel,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: ColorsRes.mainTextColor),
                                          ),
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ));
                                      }
                                    } catch (_) {}
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, end: 10, top: 10, bottom: 10),
                                alignment: Alignment.center,
                                child: productBulkOperationsProvider
                                            .productSampleFileState ==
                                        ProductSampleFileState.loading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: ColorsRes.appColor,
                                        ),
                                      )
                                    : CustomTextLabel(
                                        jsonKey: widget.from == "upload"
                                            ? downloadSampleFileLabel
                                            : downloadProductDataLabel,
                                        style: TextStyle(
                                          color: ColorsRes.appColor,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          getSizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                if (selectedPath.isNotEmpty) {
                                  productBulkOperationsProvider
                                      .productBulkOperation(
                                    context: context,
                                    fileParamsFilesPath: selectedPath,
                                    isUpload: widget.from == "upload",
                                  )
                                        .then((value) {
                                      if (value == true) {
                                        selectedPath = "";
                                        setState(() {});
                                        showMessage(context, getTranslatedValue(context, bulkUploadSuccessMessageLabel), MessageType.success);
                                      } else {
                                        showMessage(
                                            context, getTranslatedValue(context, somethingWentWrongMessageDescriptionLabel), MessageType.warning);
                                      }
                                    });
                                }
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, end: 10, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: ColorsRes.appColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: productBulkOperationsProvider
                                            .productBulkOperationsState ==
                                        ProductBulkOperationsState.loading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: ColorsRes.appColorWhite,
                                        ),
                                      )
                                    : CustomTextLabel(
                                        jsonKey: widget.from == "upload"
                                            ? uploadLabel
                                            : updateLabel,
                                        style: TextStyle(
                                          color: ColorsRes.appColorWhite,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ));
  }

  Widget buildBulletList(
      {required BuildContext context,
      required List<Map<String, String>> items,
      bool? isNumbered}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextLabel(
                    text: isNumbered == true ? "" : "• ",
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "${getTranslatedValue(context, item['title']!)}: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: getTranslatedValue(context, item['message']!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildNumberedList({
    required BuildContext context,
    required List<Map<String, String>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextLabel(
                  jsonKey: item['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                Expanded(
                  child: CustomTextLabel(
                    jsonKey: item['message'],
                    style: TextStyle(
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}