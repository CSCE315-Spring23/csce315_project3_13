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

  Future<String?> translate_string(String text, String target_language) async
  {
    if(target_language == "en"){
      return text;
    }else{
      try{
        http.Response response = await http.get(Uri.parse("https://translation.googleapis.com/language/translate/v2?target=${target_language}&key=${api_key}&q=${text}"));
        Map<String, dynamic> json = jsonDecode(response.body);
        String? translated_result = json['data']['translations'][0]['translatedText'];
        return translated_result;
      }catch(e){
        return text;
      }

    }

  }

  Future<List<String>> translate_batch(List<String> items, String target_language) async {
    String api_url = 'https://translation.googleapis.com/language/translate/v2?key=$api_key';
    String source_text = items.join(' ||| ');
    final request_body = {
      'q': source_text,
      'target': target_language,
    };

    final response = await http.post(Uri.parse(api_url), body: request_body);

    final json = jsonDecode(response.body);
    final translations = json['data']['translations'];

    final translated_texts = translations.map((t) => t['translatedText']).toString();

    List<String> translation_list = translated_texts.replaceAll('(', '').replaceAll(')', '').split(' ||| ');
    // for(String s in translation_list) {
    //   print(s);
    // }
    return translation_list;
  }
}