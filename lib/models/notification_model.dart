import 'package:supabase_app_demo/models/user_model.dart';

class NotificationModel {
  String? id;
  String? postId;
  String? notification;
  String? createdAt;
  String? userId;
  String? toUserId;
  UserModel? user;

  NotificationModel({
    this.id,
    this.postId,
    this.notification,
    this.userId,
    this.toUserId,
    this.user,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    createdAt = json['created_at'];
    notification = json['notification'];
    userId = json['user_id'];
    toUserId = json['to_user_id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    data['created_at'] = createdAt;
    data['notification'] = notification;
    data['user_id'] = userId;
    data['to_user_id'] = toUserId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
