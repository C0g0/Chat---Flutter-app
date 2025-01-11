import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // List to store the users
  final users = [
    User(online: true, email: 'test1@test.com', name: 'Luis', uid: '1'),
    User(online: true, email: 'test2@test.com', name: 'Melissa', uid: '2'),
    User(online: true, email: 'test3@test.com', name: 'Carlos', uid: '3'),
    User(online: false, email: 'test4@test.com', name: 'Sara', uid: '4'),
  ];
  // Refresh controller to handle the refresh of the list
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Get the authService from the context to get the user information
    final authService = Provider.of<AuthService>(context);
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
              // Call the logOut method from the authService
              authService.logOut();

              // Navigate to the login page
              Navigator.pushReplacementNamed(context, 'login');
            },
            color: Colors.black,
          ),
          actions: [
            // IconButton to check the users
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: theme.primaryColor,
                ),
                onPressed: () {},
                color: Colors.black,
              ),
            ),
          ],
        ),
        // SmartRefresher widget to handle the refresh of the list
        body: SmartRefresher(
            // WaterDropMaterialHeader widget to display the refresh header of the list
            header: const WaterDropMaterialHeader(),
            enablePullDown: true,
            onRefresh: _onRefresh,
            controller: _refreshController,
            child: _usersListView()));
  }

  // ListView widget to display the list of users
  ListView _usersListView() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return _userListTile(users[index]);
        },
        separatorBuilder: (_, index) {
          return const Divider();
        },
        itemCount: users.length);
  }

  // ListTile widget to display the user information
  ListTile _userListTile(User user) {
    return ListTile(
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
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
