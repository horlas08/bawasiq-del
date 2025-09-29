
import 'package:project/helper/utils/generalImports.dart';

class GeminiRepository {
  Future<String> fetchGeneratedDescription(String prompt) async {
    try {
      var response = await sendApiRequest(
        apiName: ApiAndParams.apiGoogleGemini,
        params: {ApiAndParams.prompt: prompt, ApiAndParams.source: Constant.appKey},
        isPost: true,
      );

      final data = json.decode(response);
      return data[ApiAndParams.data] as String;
    } catch (e) {
      print("Error in fetchGeneratedDescription: $e");
      return e.toString();
    }
  }
}
