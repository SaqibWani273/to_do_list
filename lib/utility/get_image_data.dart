import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final folderRef = storageRef.child('profilePics/$userId');
  //delete previous images
  final previousImages = await folderRef.listAll();

  for (var element in previousImages.items) {
    // folderRef.child(element)
    await element.delete();
  }
  final fileName = basename(imageFile.path);
  //final destination = 'profilePics/$userId/$fileName';
  final snapshot = await folderRef.child(fileName).putFile(imageFile);
  final url = await snapshot.ref.getDownloadURL();
  onCompleted(imageFile, url);
}
