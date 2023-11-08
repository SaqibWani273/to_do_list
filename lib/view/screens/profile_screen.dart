import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/model/user_model.dart';
import 'package:to_do_list/view_model/user_provider.dart';

import '../widgets/full_profile_pic.dart';
import 'edit_profile_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends ConsumerWidget {
  ProfileScreen({Key? key, this.user}) : super(key: key);

  UserModel? user;

  late String name;
  late String email;
  late String profilePicture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Future<void> getUser() async {
    //   await ref.read(userProvider.notifier).setUserProfile();
    //   //   user = ref.watch(userProvider);
    //   name = user == null ? 'Guest' : user!.name;
    //   email = user == null ? 'Guest' : user!.email;
    //   profilePicture = user == null
    //       ? 'assets/images/unknown_user.png'
    //       : user!.profilePictureUrl!;
    // }
    user = ref.watch(userProvider);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.black,
          title: const Text('Profile'),
        ),
        body: ListView(
          children: [
            // Profile header with user's name, email, and profile picture
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          FullProfilePic(url: user?.profilePictureUrl),
                    )),
                    child: Hero(
                      tag: 'profile',
                      child: user == null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/unknown_user.png'),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(user!.profilePictureUrl!),
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //  name,
                        user == null ? 'Guest' : user!.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        // email,
                        user == null ? 'Guest' : user!.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit profile section
            const Divider(),
            ListTile(
              title: const Text('Edit Profile'),
              leading: const Icon(Icons.edit),
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
            const Divider(),
            ListTile(
              title: const Text('App Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                // Navigate to app settings screen
              },
            ),
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock),
              onTap: () {
                // Open a dialog or navigate to a new screen to change user's password
              },
            ),

            // Other common features
            const Divider(),
            ListTile(
              title: const Text('Help & Support'),
              leading: const Icon(Icons.help),
              onTap: () {
                // Open help & support page or contact support
              },
            ),
            ListTile(
              title: const Text('About'),
              leading: const Icon(Icons.info),
              onTap: () {
                // Open about page with app information
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                // Logout the user
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        )

        //  FutureBuilder(
        //   future: getUser(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     //   ref.watch(userProvider);
        //     return
        //   },
        // ),
        );
  }
}
