class UserModel {
  String? id;
  String? email;
  String? name;
  String? image;
  String? fcm_token;
  Metadata? metadata;
  String? createdAt;

  UserModel({this.id, this.email, this.createdAt, this.metadata});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    image = json['image'];
    id = json['id'];
    fcm_token = json['fcm_token'];
    name = json["name"];
    createdAt = json['created_at'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['image'] = image;
    data['id'] = id;
    data["name"] = name;
    data["fcm_token"] = fcm_token;
    data['created_at'] = createdAt;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  String? name;
  String? image;
  String? description;

  Metadata({this.name, this.image, this.description});

  Metadata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    return data;
  }
}
