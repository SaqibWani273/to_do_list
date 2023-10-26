import 'package:flutter/material.dart';

import '../../model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;

  const EditProfileScreen({super.key, this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = '';
  String _email = '';
  String _profilePic = '';

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
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.user == null)
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/unknown_user.png'),
                radius: 50.0,
              ),
            if (widget.user != null)
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user!.profilePictureUrl!),
                radius: 50.0,
              ),
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: _updateName,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: _email,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: _updateEmail,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Update Profile'),
              onPressed: () {
                // Implement profile update logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
