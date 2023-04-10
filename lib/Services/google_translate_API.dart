import 'package:http/http.dart' as http;
import 'dart:convert';

class google_translate_API
{
  final String api_key = "AIzaSyBogUqD6xUnBkJ89bLPvcRDivGWDpaLET0";

  Future<void> translate_text(String text, String target_language) async
  {
    http.Response response = await http.get(Uri.parse("https://translation.googleapis.com/language/translate/v2?target=${target_language}&key=${api_key}&q=${text}"));
    Map<String, dynamic> json = jsonDecode(response.body);
    String translated_text = json['data']['translations'][0]['translatedText'];
    print(translated_text);
  }
}