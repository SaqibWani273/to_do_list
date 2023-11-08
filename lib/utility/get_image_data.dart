import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

Future<void> getImageData({
  required Function(File?, String?) onCompleted,
}) async {
  File? imageFile;
  //get image from gallery
  final picker = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (picker == null) {
    log('no image selected');
    return;
  }

  imageFile = File(picker.path);
  //upload that to firebaseStorage
  final storageRef = FirebaseStorage.instance.ref();

  final fileName = basename(imageFile.path);
  final destination = 'profilePics/$fileName';
  final snapshot = await storageRef.child(destination).putFile(imageFile);
  final url = await snapshot.ref.getDownloadURL();
  onCompleted(imageFile, url);
}
