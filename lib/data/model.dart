// To parse this JSON data, do
//
//     final dictionary = dictionaryFromJson(jsonString);

import 'dart:convert';

List<Dictionary> dictionaryFromJson(String str) => List<Dictionary>.from(json.decode(str).map((x) => Dictionary.fromJson(x)));

String dictionaryToJson(List<Dictionary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dictionary {
  Dictionary({
   required this.meanings,
  });

  List<Meaning> meanings;

  factory Dictionary.fromJson(Map<String, dynamic> json) => Dictionary(

    meanings: List<Meaning>.from(json["meanings"].map((x) => Meaning.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meanings": List<dynamic>.from(meanings.map((x) => x.toJson())),
  };
}

class Meaning {
  Meaning({
   required this.partOfSpeech,
   required this.definitions,
  });

  String partOfSpeech;
  List<Definition> definitions;

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
    partOfSpeech: json["partOfSpeech"],
    definitions: List<Definition>.from(json["definitions"].map((x) => Definition.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "partOfSpeech": partOfSpeech,
    "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
  };
}

class Definition {
  Definition({
   required this.definition,
   required this.example,
   required this.synonyms,
   required this.antonyms,
  });

  String definition;
  String example;
  List<dynamic> synonyms;
  List<dynamic> antonyms;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
    definition: json["definition"],
    example: json["example"]??"",
    synonyms: List<dynamic>.from(json["synonyms"].map((x) => x)),
    antonyms: List<dynamic>.from(json["antonyms"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "definition": definition,
    "example": example,
    "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
    "antonyms": List<dynamic>.from(antonyms.map((x) => x)),
  };
}
//
// String app_id= '4f929018';
// String app_key = '89407ad6f6954a6f77437b854aae5865';
// var header = {"app_id": app_id, "app_key": app_key};
// var res =await http.get(Uri.parse('https://od-api.oxforddictionaries.com:443/api/v2/search/hi?q='+word ),headers: header);
//