import 'package:supabase_app_demo/models/like_model.dart';
import 'package:supabase_app_demo/models/user_model.dart';

class PostModel {
  String? id;
  String? content;
  String? image;
  String? userId;
  int? likeCount;
  int? commentCount;
  String? createdAt;
  UserModel? user;
  List<LikeModel>? likes;

  PostModel({
    this.id,
    this.content,
    this.image,
    this.createdAt,
    this.user,
    this.likeCount,
    this.commentCount,
    this.userId,
    this.likes,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    commentCount = json['comment_count'] ?? 0;
    userId = json['user_id'];
    likeCount = json['like_count'] ?? 0;
    image = json['image'];
    createdAt = json['created_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    // if (json['likes'] != null) {
    //   likes = <LikeModel>[];
    //   json['likes'].forEach((v) {
    //     likes!.add(LikeModel.fromJson(v));
    //   });
    // }
    likes = json['likes'] != null
        ? (json['likes'] as List).map((v) => LikeModel.fromJson(v)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['like_count'] = likeCount;
    data['comment_count'] = commentCount;
    data['user_id'] = userId;
    data['image'] = image;
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
