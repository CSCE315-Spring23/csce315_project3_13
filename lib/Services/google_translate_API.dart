import 'package:http/http.dart' as http;
import 'dart:convert';

/// This class provides methods for interacting with the Google Translate API
class google_translate_API
{
  final String api_key = "AIzaSyBogUqD6xUnBkJ89bLPvcRDivGWDpaLET0";

  /// Translates [text] into the specified [target_language] and prints the translated text
  Future<void> translate_text(String text, String target_language) async
  {
    http.Response response = await http.get(Uri.parse("https://translation.googleapis.com/language/translate/v2?target=${target_language}&key=${api_key}&q=${text}"));
    Map<String, dynamic> json = jsonDecode(response.body);
    String translated_text = json['data']['translations'][0]['translatedText'];
    print(translated_text);
  }

  /// Translates [text] into the specified [target_language] and returns the translated text
  ///
  /// If [target_language] is 'en', returns the original [text]
  /// If the translation fails, returns the original [text]
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

  /// Translates a batch of strings [items] into the specified [target_language] and returns the translated list
  ///
  /// If [target_language] is 'en', returns the original [items]
  /// If the batch translation fails, returns the original [items]
  Future<List<String>> translate_batch(List<String> items, String target_language) async {
    // print("Translating");
    // print(target_language);
    if(target_language == "en"){
      return items;
    }else{

      try{
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

      }catch(e){
        print("Could not batch translate");
        print(e);
        return items;

      }
    }
  }
}