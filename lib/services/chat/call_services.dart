import 'package:get/get.dart';
import 'package:supabase_app_demo/sql/table.dart';
import 'package:supabase_app_demo/sql/table_column/call.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/call_cred_model.dart';
import '../../utils/env.dart';

class CallServices extends GetxService {
  final client = SupabaseClient(Env.supabaseUrl, Env.supabaseKey);

  Future<CallCredentials> getCallCredentials(
      {required String chatRoomId}) async {
    try {
      final response = await client
          .from(TableName.callCredentials)
          .select()
          .eq(CallTable.chatRoomId, chatRoomId)
          .maybeSingle();
      if (response.error == null && response.data != null) {
        return CallCredentials(
          data: CallCredentialsData(
            agoraUid: response.data[CallTable.agoraUid],
            rtcToken: response.data[CallTable.rtcToken],
          ),
        );
      } else {
        return CallCredentials();
      }
    } catch (e) {
      return CallCredentials();
    }
  }
}
