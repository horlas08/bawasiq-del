import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:project/helper/utils/generalImports.dart';

Widget editBoxWidget({
  required BuildContext context,
  required TextEditingController edtController,
  required Function validationFunction,
  required String label,
  required TextInputType inputType,
  bool ishidetext = false,
  Widget? tailIcon,
  Widget? suffixIcon,
  String? hint,
  Color? bgcolor,
  bool? isEditable = true,
  bool? nonFocusable = false,
  FocusNode? focusNode,
  int? maxlines,
  List<TextInputFormatter>? inputFormatters,
}) {
  return textFieldWidget(
    edtController,
    validationFunction,
    label,
    inputType,
    "${getTranslatedValue(context, enterValidLabel)} $label",
    context,
    floatingLbl: false,
    borderRadius: 8,
    iseditable: isEditable ?? true,
    hint: hint ?? label,
    ticon: tailIcon ?? SizedBox.shrink(),
    sicon: suffixIcon ?? SizedBox.shrink(),
    maxlines: maxlines,
    ishidetext: ishidetext,
    inputFormatters: inputFormatters,
    bgcolor: bgcolor ?? Theme.of(context).scaffoldBackgroundColor,
    focusNode: nonFocusable == null ? null : (focusNode ?? FocusNode()),
    contentPadding: EdgeInsets.symmetric(vertical: Constant.paddingOrMargin18, horizontal: Constant.paddingOrMargin8),
  );
}
