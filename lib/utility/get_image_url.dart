import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

File? imageFile;
Future<void> imageFromGallery() async {
  final picker = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (picker != null) {
    imageFile = File(picker.path);
  }
}

Future<String?> getImageUrl() async {
  await imageFromGallery();
  //upload that to firebaseStorage
  final storageRef = FirebaseStorage.instance.ref();

  if (imageFile == null) {
    log('image path is null');
    return null;
  }
  final fileName = basename(imageFile!.path);
  final destination = 'profilePics/$fileName';
  final snapshot = await storageRef.child(destination).putFile(imageFile!);
  final url = await snapshot.ref.getDownloadURL();
  // task.whenComplete(() {
  //   task.snapshot.ref.getDownloadURL().then((value) {
  //     url = value;
  //   });
  //   log('image uploaded to firebase storage');
  // });
  // task.catchError((err) => log(err.toString()));

  log(url.toString());
  return url;
}
