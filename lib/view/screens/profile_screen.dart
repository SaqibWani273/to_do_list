import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/model/user_model.dart';
import 'package:to_do_list/view_model/user_provider.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  late String name;
  late String email;
  String profilePicture = 'https://picsum.photos/200';
  late final UserModel? user;
  Future<void> getUser() async {
    user = await ref.read(userProvider.notifier).getUser();
    if (user == null) {
      name = 'Guest';
      email = 'guest';
      profilePicture = 'https://picsum.photos/200';
    } else {
      name = 'John Doe';
      email = 'johndoe@example.com';
      profilePicture = 'https://picsum.photos/200';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: [
          // Profile header with user's name, email, and profile picture
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profilePicture),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Edit profile section
          Divider(),
          ListTile(
            title: Text('Edit Profile'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user),
                  ));
              // Open a dialog or navigate to a new screen to edit user's profile information
            },
          ),

          // App settings section
          Divider(),
          ListTile(
            title: Text('App Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              // Navigate to app settings screen
            },
          ),
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () {
              // Open a dialog or navigate to a new screen to change user's password
            },
          ),

          // Other common features
          Divider(),
          ListTile(
            title: Text('Help & Support'),
            leading: Icon(Icons.help),
            onTap: () {
              // Open help & support page or contact support
            },
          ),
          ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
            onTap: () {
              // Open about page with app information
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              // Logout the user
            },
          ),
        ],
      ),
    );
  }
}
