import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/model/user_model.dart';
import 'package:to_do_list/view_model/user_provider.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({
    Key? key,
  }) : super(key: key);

  UserModel? user;

  late String name;
  late String email;
  late String profilePicture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> getUser() async {
      user = await ref.read(userProvider.notifier).getUserProfile();
      name = user == null ? 'Guest' : user!.name;
      email = user == null ? 'Guest' : user!.email;
      profilePicture = user == null
          ? 'assets/images/unknown_user.png'
          : user!.profilePictureUrl!;
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.black,
          title: Text('Profile'),
          // leading: Icon(
          //   Icons.arrow_back_ios_new,
          //   color: Colors.black,
          // ),
        ),
        body: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: [
                // Profile header with user's name, email, and profile picture
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      user == null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(profilePicture),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(profilePicture),
                            ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                          builder: (context) =>
                              EditProfileScreen(user: user, ref: ref),
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
            );
          },
        ));
  }
}
