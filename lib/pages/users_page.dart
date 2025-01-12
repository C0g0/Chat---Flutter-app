import 'package:chat/models/user.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/users_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final usersService = UsersService();
  // List to store the users

  List<User> usersDB = [];

  @override
  void initState() {
    _onRefreshUsers();
    super.initState();
  }

  // Refresh controller to handle the refresh of the list
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Get the authService from the context to get the user information
    final authService = Provider.of<AuthService>(context);

    // Get the socketService from the context to handle the socket connection
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(authService.user!.name,
              style: const TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          // IconButton to exit the app
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Disconnect the socket
              socketService.disconnect();
              // Call the logOut method from the authService
              authService.logOut();

              // Navigate to the login page
              Navigator.pushReplacementNamed(context, 'login');
            },
            color: Colors.black,
          ),
          actions: [
            // IconButton to check the server status  (online/offline)
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.check_circle,
                      color: theme.primaryColor,
                    )
                  : const Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    ),
            ),
          ],
        ),
        // SmartRefresher widget to handle the refresh of the list
        body: SmartRefresher(
            // WaterDropMaterialHeader widget to display the refresh header of the list
            header: const WaterDropMaterialHeader(),
            enablePullDown: true,
            onRefresh: _onRefreshUsers,
            controller: _refreshController,
            child: _usersListView()));
  }

  // ListView widget to display the list of users
  ListView _usersListView() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return _userListTile(usersDB[index]);
        },
        separatorBuilder: (_, index) {
          return const Divider();
        },
        itemCount: usersDB.length);
  }

  // ListTile widget to display the user information
  ListTile _userListTile(User user) {
    return ListTile(
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  // Method to handle the refresh of the list
  void _onRefreshUsers() async {
    // Obtain de users from de DB
    usersDB = await usersService.getUsers();
    // Update the state
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
