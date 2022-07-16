import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';
class DictionaryApi{
  Future<String> getMeaning(String word)async{
    late Definition defination;
    var res =await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/hi/'+word));
    print(res.body);
    if (res.statusCode == 200) {
      //display UI
      var body = jsonDecode(res.body);

      var meaning = json.decode(res.body);
      print(meaning[0]);
      for(var dictionary in meaning){
        //Dictionary d = dictionary;
        Dictionary d = Dictionary.fromJson(dictionary);
        Meaning meaning = d.meanings[0];
        defination = meaning.definitions[0];
        print(defination.definition);
      }

    }
    else {
      print("ERROR");
      //Show Error Message
    }
    return defination.definition??"";
  }
}