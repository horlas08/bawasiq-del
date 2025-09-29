import 'package:flutter/cupertino.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/repositories/addProductApi.dart';

enum TagsListState {
  initial,
  loading,
  loaded,
  error,
}

class TagsListProvider extends ChangeNotifier {
  TagsListState tagsListState = TagsListState.initial;

  String message = '';
  late Tags tags;
  late List<TagsData> tagsData = [];


  Future<List<TagsData>> getTagsProvider(BuildContext context) async {
    try {
      tagsListState = TagsListState.loading;
      notifyListeners();
      var getResult = await getTagsApi(params: {}, context: context);

      if (getResult[ApiAndParams.status].toString() == "1") {
        tags = Tags.fromJson(getResult);
        tagsData = tags.data ?? [];
        tagsListState = TagsListState.loaded;
        notifyListeners();
        return tagsData;
      } else {
        showMessage(
            context, getResult[ApiAndParams.message], MessageType.warning);
        tagsListState = TagsListState.error;
        notifyListeners();
        return [];
      }
    }catch (e) {
      message = e.toString();

      tagsListState = TagsListState.error;
      showMessage(context, message, MessageType.error);
      notifyListeners();
      return [];
    }
  }
}
