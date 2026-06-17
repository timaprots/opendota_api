class HeroModel {
  final int id;
  final String localizedName;
  final String primaryAttr;
  final String attackType;
  final String img;
  final int proWins;
  final int proPick;

  HeroModel({
    required this.id,
    required this.localizedName,
    required this.primaryAttr,
    required this.attackType,
    required this.img,
    required this.proWins,
    required this.proPick,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json["id"],
      localizedName: json["localized_name"] ?? "",
      primaryAttr: json["primary_attr"] ?? "",
      attackType: json["attack_type"] ?? "",
      img: json["img"] ?? "",
      proWins: json["pro_win"] ?? 0,
      proPick: json["pro_pick"] ?? 0,
    );
  }

  double get winRate {
    if (proPick == 0) return 0;
    return (proWins / proPick) * 100;
  }

  String get imageUrl {
    final file = img.split('/').last;
    return "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/$file";
  }
}