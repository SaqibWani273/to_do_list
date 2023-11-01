import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/utility/get_image_url.dart';
import 'package:to_do_list/view_model/sqf_data.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _profilePic;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var uploadingPic = false;
  File? imageFile;
  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.user?.name ?? '';
    emailController.text = widget.user?.email ?? '';
    _profilePic = widget.user?.profilePictureUrl;
    super.initState();
  }

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
          child: Form(
            key: _formKey,
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
                          width: 15,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 5.0,
                          ),
                        ),
                      )
                    : InkWell(
                        //here if i am getting the image from gallery then
                        //to show preview, i use image.file
                        //otherwise show unknown user or profile pic accordingly
                        child: imageFile != null
                            ? CircleAvatar(
                                radius: 50.0,
                                foregroundImage: Image.file(imageFile!).image,
                              )
                            : widget.user == null
                                ? const CircleAvatar(
                                    radius: 50.0,
                                    foregroundImage: AssetImage(
                                        'assets/images/unknown_user.png'),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(
                                        widget.user!.profilePictureUrl!),
                                    radius: 50.0,
                                  ),
                        onTap: () async {
                          //  getImage();
                          setState(() {
                            uploadingPic = true;
                          });
                          // _profilePic = await getImageUrl();
                          // log(_profilePic.toString());
                          imageFile = await getImageFileFromGallery();
                          setState(() {
                            uploadingPic = false;
                          });
                        },
                      ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  child: const Text('Update Profile'),
                  onPressed: () async {
                    if (imageFile == null && _profilePic == null) {
                      //show snackbar to tell user to select profile pic
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select a profile pic'),
                      ));
                    } else {
                      if (_formKey.currentState!.validate()) {
                        final userModel = UserModel.fromMap({
                          'name': nameController.text,
                          'email': emailController.text,
                          'profilePictureUrl': _profilePic,
                          'phone':
                              FirebaseAuth.instance.currentUser!.phoneNumber,
                          'imagePath': imageFile?.path,
                        });
                        await widget.ref
                            .read(userProvider.notifier)
                            .addUserProfile(userModel);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
