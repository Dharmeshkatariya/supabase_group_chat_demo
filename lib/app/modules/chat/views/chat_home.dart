import 'package:get/get.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import '../../../../models/user_model.dart';
import '../../../../services/chat/chat_room_services.dart';
import '../../../../services/user_services.dart';
import '../../../../utils/export.dart';
import 'add_particiapte_view.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final TextEditingController _chatRoomController = TextEditingController();
  final _chatServices = Get.put(ChatRoomServices());
  final supabase = Get.put(SupabaseService());
  Rx<UserModel?> user = Rx<UserModel?>(null);
  late String _currentUserId;

  _getUser() async {
    await UserServices.getUser(_currentUserId).then(
      (res) {
        res.fold(
          (l) {},
          (r) {
            user.value = r;
          },
        );
      },
    );
  }

  @override
  void initState() {
    _currentUserId = SupabaseService.client.auth.currentUser!.id;
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _chatRoomController,
              decoration: const InputDecoration(labelText: 'Chat Room Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createChatRoom,
              child: const Text('Create Chat Room'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createChatRoom() async {
    final name = _chatRoomController.text;
    if (name.isNotEmpty) {
      await _chatServices
          .createChatRoom(name, [_currentUserId], _currentUserId, [user.value!])
          .then(
        (res) {
          res.fold(
            (l) {},
            (str) {
              if (str.isNotEmpty) {
                Get.to(
                  AddParticiapteView(
                    chatRoomId: str,
                  ),
                );
                _chatRoomController.clear();
              }
            },
          );
        },
      );
    }
  }
}
