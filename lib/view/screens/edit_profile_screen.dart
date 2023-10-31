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
  String? _profilePic;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var uploadingPic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uploadingPic
                  ? const CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.grey,
                      child: SizedBox(
                        height: 15,
                        width: 10,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 5.0,
                        ),
                      ),
                    )
                  : InkWell(
                      child: _profilePic == null
                          ? const CircleAvatar(
                              radius: 50.0,
                              foregroundImage:
                                  AssetImage('assets/images/unknown_user.png'),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.grey,
                              backgroundImage: NetworkImage(_profilePic ?? ''),
                              radius: 50.0,
                            ),
                      onTap: () async {
                        setState(() {
                          uploadingPic = true;
                        });
                        _profilePic = await getImageUrl();
                        log(_profilePic.toString());
                        setState(() {
                          uploadingPic = false;
                        });
                      },
                    ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Update Profile'),
                onPressed: () async {
                  // Implement profile update logic here
                  final userModel = UserModel.fromMap({
                    'name': nameController.text,
                    'email': emailController.text,
                    'profilePictureUrl': _profilePic,
                    'phone': '1234567890',
                  });
                  await widget.ref
                      .read(userProvider.notifier)
                      .addUserProfile(userModel);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
