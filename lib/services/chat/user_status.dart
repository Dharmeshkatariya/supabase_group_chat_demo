import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../sql/table.dart';
import '../../sql/table_column/user_status.dart';
import '../../utils/env.dart';

class UserStatusServices extends GetxService {
  final client = SupabaseClient(Env.supabaseUrl, Env.supabaseKey);

  Future<Either<String, void>> userOnline(String userId) async {
    try {
      return await updateUserStatus(userId, true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> userOffline(String userId) async {
    try {
      return await updateUserStatus(userId, false);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Either<String, Stream<List<Map<String, dynamic>>>> getUserStatusUpdates() {
    try {
      final stream = client
          .from(TableName.userStatus)
          .stream(primaryKey: [UserStatusTable.userId])
          .order(UserStatusTable.updatedAt, ascending: false)
          .map((data) => List<Map<String, dynamic>>.from(data));
      return Right(stream);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> updateUserStatus(
      String userId, bool isOnline) async {
    try {
      final response = await client.from(TableName.userStatus).upsert({
        UserStatusTable.userId: userId,
        UserStatusTable.id: userId,
        UserStatusTable.isOnline: isOnline,
        UserStatusTable.lastSeen: DateTime.now().toIso8601String(),
        UserStatusTable.updatedAt: DateTime.now().toIso8601String(),
      }).execute();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
