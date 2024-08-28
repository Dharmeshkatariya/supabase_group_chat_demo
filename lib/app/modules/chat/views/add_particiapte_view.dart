import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/views/chat_room_list.dart';
import '../../../../models/user_model.dart';
import '../../../../services/chat/chat_room_services.dart';
import '../../../../services/user_services.dart';
import '../../../../utils/export.dart';

class AddParticiapteView extends StatefulWidget {
  final String chatRoomId;

  const AddParticiapteView({super.key, required this.chatRoomId});

  @override
  State<AddParticiapteView> createState() => _AddParticiapteViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('chatRoomId', chatRoomId));
  }
}

class _AddParticiapteViewState extends State<AddParticiapteView> {
  List<UserModel> _users = [];
  bool _isLoading = true;
  String? _error;
  final List<String> _selectedUsers = [];
  final List<UserModel> _selectedUsersModel = [];

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  Future<void> _fetchUsers() async {
    final result = await UserServices.getAllUsers();
    result.fold(
      (error) {
        setState(() {
          _error = error;
          _isLoading = false;
        });
      },
      (users) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      },
    );
  }

  final chatServices = Get.put(ChatRoomServices());

  bool loading = false;

  Future<void> _addParticipants() async {
    loading = true;
    setState(() {});
    try {
      final response = await chatServices.addParticipant(
          widget.chatRoomId, _selectedUsers, _selectedUsersModel);
      response.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding participant: $error')),
          );
        },
        (_) {
          loading = false;
          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Participant added successfully!')),
          );
          Get.off(const ChatRoomListPage());
        },
      );
      loading = false;
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Participants'),
        actions: [
          TextButton(
            onPressed: _addParticipants,
            child: loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const Text('Add Selected',
                    style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      title: Text(user.name ?? 'No Name'),
                      subtitle: Text(user.email ?? 'No Email'),
                      trailing: IconButton(
                        icon: Icon(
                          _selectedUsers.contains(user.id)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: _selectedUsers.contains(user.id)
                              ? Colors.blue
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_selectedUsers.contains(user.id)) {
                              _selectedUsers.remove(user.id);
                              _selectedUsersModel.remove(user);
                            } else {
                              _selectedUsers.add(user.id!);
                              _selectedUsersModel.add(user);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
