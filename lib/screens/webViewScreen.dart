import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class WebViewScreen extends StatefulWidget {
  final String dataFor;

  WebViewScreen({Key? key, required this.dataFor}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          title: CustomTextLabel(
            text: widget.dataFor,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
          child: QuillHtmlEditor(
            text:
                widget.dataFor == getTranslatedValue(context, privacyPolicyLabel)
                    ? Constant.privacyPolicy
                    : Constant.termsConditions,
            hintText: getTranslatedValue(context, descriptionGoesHereLabel),
            isEnabled: false,
            ensureVisible: false,
            minHeight: 10,
            autoFocus: false,
            textStyle: TextStyle(color: ColorsRes.mainTextColor),
            hintTextStyle: TextStyle(color: ColorsRes.subTitleTextColor),
            hintTextAlign: TextAlign.start,
            padding: const EdgeInsets.only(left: 10, top: 10),
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
            controller: QuillEditorController(),
          ),
        ),
      ),
    );
  }
}
