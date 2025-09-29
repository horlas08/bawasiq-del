import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/provider/tagsProvider.dart';

class TagsListScreen extends StatefulWidget {
  final List<TagsData> selectedTags;

  const TagsListScreen({super.key, required this.selectedTags});

  @override
  State<TagsListScreen> createState() => _TestState();
}

class _TestState extends State<TagsListScreen> {
  List<TagsData> tags = [];

  @override
  void initState() {
    apicall();
    super.initState();
  }

  apicall(){
    Future.delayed(Duration.zero).then((value) {
      context.read<TagsListProvider>().getTagsProvider(context).then(
        (value) {
          tags = value;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          Navigator.pop(context, widget.selectedTags);
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: tagsLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                widget.selectedTags.clear();
                setState(() {});
              },
              child: CustomTextLabel(
                jsonKey: clearAllLabel,
                style: TextStyle(
                  color: ColorsRes.appColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            getSizedBox(width: 10),
          ],
        ),
        body: Consumer<TagsListProvider>(
          builder: (context, tagsListProvider, child) {
            if (tagsListProvider.tagsListState == TagsListState.loaded) {
              if(tagsListProvider.tagsData.isEmpty){
                return Container(
                  alignment: Alignment.center,
                  height: context.height,
                  width: context.width,
                  child: DefaultBlankItemMessageScreen(
                    image: "no_product_icon",
                    title: noDataLabel,
                    description: noDataFoundLabel,
                    buttonTitle: tryAgainLabel,
                    callback: () {
                      apicall();
                    },
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            widget.selectedTags
                                    .any((tag) => tag.name == tags[index].name)
                                ? widget.selectedTags.remove(tags[index])
                                : widget.selectedTags.add(tags[index]);
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.only(
                              start: 10,
                              end: 10,
                              top: 10,
                            ),
                            color: ColorsRes.appColorTransparent,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextLabel(
                                    text: tags[index].name!,
                                    softWrap: true,
                                  ),
                                ),
                                Icon(
                                  widget.selectedTags.any(
                                          (tag) => tag.name == tags[index].name)
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  size: 20,
                                  color: ColorsRes.appColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: tags.length,
                    ),
                  ),
                ],
              );
            }
            if (tagsListProvider.tagsListState == TagsListState.loading) {
              return ListView(
                children: List.generate(
                  20,
                  (index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin10),
                      child: CustomShimmer(
                        height: 40,
                        width: context.width,
                        borderRadius: 10,
                        margin: EdgeInsetsDirectional.only(start: 10),
                      ),
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
