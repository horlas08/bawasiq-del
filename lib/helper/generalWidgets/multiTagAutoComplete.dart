import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class MultiTagAutoComplete extends StatefulWidget {
  final List<TagsData> allTags;
  final Function(List<TagsData>) onTagsChanged;
  final Function(String) onAddNewTag;

  const MultiTagAutoComplete({
    Key? key,
    required this.allTags,
    required this.onTagsChanged,
    required this.onAddNewTag,
  }) : super(key: key);

  @override
  _MultiTagAutoCompleteState createState() => _MultiTagAutoCompleteState();
}

class _MultiTagAutoCompleteState extends State<MultiTagAutoComplete> {
  List<TagsData> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<TagsData>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            var matchingTags = widget.allTags.where((TagsData option) {
              return option.name!
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            }).toList();

            // If no match, add option to create a new tag
            if (matchingTags.isEmpty) {
              return [TagsData(name: "+ Add '${textEditingValue.text}'")];
            }
            return matchingTags;
          },
          onSelected: (TagsData selection) {
            if (selection.name!.startsWith('+ Add ')) {
              // Add new tag
              String newTagName = selection.name!
                  .replaceFirst("+ Add '", '')
                  .replaceFirst("'", '');
              widget.onAddNewTag(newTagName); // Call the method to add new tag
              selection = TagsData(
                  name: newTagName); // Upd
              setState(() {});
            } else {
              // Add selected tag to the list
              if (!_selectedTags.contains(selection)) {
                _selectedTags.add(selection);
                widget.onTagsChanged(_selectedTags);
              }
              setState(() {});
            }
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback _) {
            return TextField(
              style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontSize: 15,
              ),
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                hintStyle: TextStyle(
                  color: ColorsRes.subTitleTextColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: ColorsRes.subTitleTextColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: ColorsRes.subTitleTextColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                hintText: getTranslatedValue(context, tagsHintLabel),
                isDense: true,
                filled: true,
              ),
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<TagsData> onSelected,
              Iterable<TagsData> options) {
            final itemCount = options.length;
            return ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                final TagsData option = options.elementAt(index);
                return _selectedTags.contains(option)
                    ? SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Container(
                          color: Theme.of(context).cardColor,
                          width: context.width,
                          child: CustomTextLabel(
                            text: option.name!,
                            style: TextStyle(
                              color: ColorsRes.mainTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
              },
            );
          },
        ),
        if (_selectedTags.isNotEmpty) getSizedBox(height: 5),
        if (_selectedTags.isNotEmpty)
          Container(
            width: context.width,
            height: 35,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: _selectedTags.map(
                (tag) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(start: 5),
                    child: Chip(
                      padding: EdgeInsetsDirectional.zero,
                      visualDensity: VisualDensity.compact,
                      label: CustomTextLabel(
                        text: tag.name!,
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      deleteIcon: Icon(
                        Icons.cancel_outlined,
                        color: ColorsRes.appColorRed,
                        size: 15,
                      ),
                      labelStyle: TextStyle(
                        color: ColorsRes.mainTextColor,
                      ),
                      side: BorderSide.none,
                      color:
                          WidgetStatePropertyAll(Theme.of(context).cardColor),
                      onDeleted: () {
                        _selectedTags.remove(tag);
                        widget.onTagsChanged(_selectedTags);
                        setState(() {});
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
      ],
    );
  }
}
