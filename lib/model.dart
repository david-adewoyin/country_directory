class Country {
  String code;
  String name;
  String? capital;
  String? currency;
  String? native;
  String? phone;
  String? emoji;

  Country.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        name = json["name"],
        capital = json["capital"],
        currency = json["currency"],
        native = json["native"],
        phone = json["phone"],
        emoji = json["emoji"];
}
