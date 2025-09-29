import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class HtmlEditorScreen extends StatefulWidget {
  final String? htmlContent;

  const HtmlEditorScreen({super.key, this.htmlContent});

  @override
  State<HtmlEditorScreen> createState() => _HtmlEditorScreenState();
}

class _HtmlEditorScreenState extends State<HtmlEditorScreen> {
  final QuillEditorController controller = QuillEditorController();

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.strike,
    ToolBarStyle.blockQuote,
    ToolBarStyle.codeBlock,
    ToolBarStyle.indentMinus,
    ToolBarStyle.indentAdd,
    ToolBarStyle.directionRtl,
    ToolBarStyle.directionLtr,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.align,
    ToolBarStyle.listOrdered,
    ToolBarStyle.listBullet,
    ToolBarStyle.size,
    ToolBarStyle.link,
    ToolBarStyle.image,
    ToolBarStyle.video,
    ToolBarStyle.clean,
    ToolBarStyle.undo,
    ToolBarStyle.redo,
    ToolBarStyle.clearHistory,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
    ToolBarStyle.separator,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: descriptionLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
        ),
        body: Column(
          children: [
            ToolBar(
              toolBarColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: ColorsRes.mainTextColor,
              activeIconColor: ColorsRes.appColor,
              controller: controller,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              toolBarConfig: customToolBarList,
            ),
            Expanded(
              child: QuillHtmlEditor(
                text: widget.htmlContent ?? "",
                hintText: getTranslatedValue(context, descriptionGoesHereLabel),
                controller: controller,
                isEnabled: true,
                ensureVisible: false,
                minHeight: context.height,
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
              ),
            ),
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () => Navigator.pop(context, controller.getText()),
          child: Container(
            decoration: BoxDecoration(
              color: ColorsRes.appColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 45,
            alignment: Alignment.center,
            padding: EdgeInsetsDirectional.all(10),
            margin: EdgeInsetsDirectional.all(10),
            child: CustomTextLabel(
              jsonKey: doneLabel,
              style: TextStyle(
                color: ColorsRes.appColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
