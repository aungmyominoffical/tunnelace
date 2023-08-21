class ServerModal {
  String? flag;
  String? type;
  int? speed;
  int? id;
  String? config;
  String? country;

  ServerModal({this.flag, this.type, this.speed, this.config, this.country,this.id});

  ServerModal.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    type = json['type'];
    speed = json['speed'];
    config = json['config'];
    country = json['country'];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['type'] = this.type;
    data['speed'] = this.speed;
    data['config'] = this.config;
    data['country'] = this.country;
    data["id"] = this.id;
    return data;
  }
}