import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/utility/get_image_url.dart';
import 'package:to_do_list/view_model/user_provider.dart';

import '../../model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;
  final WidgetRef ref;

  const EditProfileScreen({super.key, this.user, required this.ref});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = '';
  String _email = '';
  String? _profilePic = '';
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  void _updateName(String newName) {
    setState(() {
      _name = newName;
    });
  }

  void _updateEmail(String newEmail) {
    setState(() {
      _email = newEmail;
    });
  }

  void _updateProfilePic(String newProfilePic) {
    setState(() {
      _profilePic = newProfilePic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: widget.user == null
                    ? const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/unknown_user.png'),
                        radius: 50.0,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(_profilePic ?? ''),
                        radius: 50.0,
                      ),
                onTap: () async {
                  _profilePic = await getImageUrl();
                  log(_profilePic.toString());
                  setState(() {});
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: _updateName,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: _updateEmail,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Update Profile'),
                onPressed: () {
                  // Implement profile update logic here
                  final userModel = UserModel.fromMap({
                    'name': nameController.text,
                    'email': emailController.text,
                    'profilePictureUrl': _profilePic,
                    'phone': '1234567890',
                  });
                  widget.ref
                      .read(userProvider.notifier)
                      .addUserProfile(userModel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
