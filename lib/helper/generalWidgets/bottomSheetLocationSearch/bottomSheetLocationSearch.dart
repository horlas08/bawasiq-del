import 'package:flutter/material.dart';
import 'package:project/helper/utils/generalImports.dart';

class BottomSheetLocationSearch extends StatefulWidget {
  const BottomSheetLocationSearch({super.key});

  @override
  State<BottomSheetLocationSearch> createState() =>
      _BottomSheetLocationSearchState();
}

class _BottomSheetLocationSearchState extends State<BottomSheetLocationSearch> {
  void onError(PlacesAutocompleteResponse response) {
    showMessage(context, response.errorMessage!, MessageType.error);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
