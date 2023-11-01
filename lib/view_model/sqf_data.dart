import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

getImage() async {
  final picker = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (picker != null) {
    getLocalImage(File(picker.path));
  }
}

Future<void> getLocalImage(File imageFile) async {
  //to get the appdirectory where this app's data gets stored
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  final fileName = path.basename(imageFile.path);
  //copy the image from the local directory
  final copiedImage = await imageFile.copy('${appDirectory.path}/$fileName');
  // copiedImage.
  log('local imagefile= ${copiedImage.path}');
  addToLocalDataBase(copiedImage.path);
}

addToLocalDataBase(String imagePath) async {
  //to get the appdirectory where the databases are stored
  final dbPath = await sqflite.getDatabasesPath();
  const createQuery =
      'create table user_profile(id INTEGER PRIMARY KEY, name TEXT, email TEXT, profilePicture TEXT)';
  //here we open a specific database
  final db = await sqflite.openDatabase(path.join(dbPath, 'todo.db'),
      onCreate: (db, version) {
    //oncreate gets called only for the first time when this 'todo.db' gets created
    return db.execute(createQuery);
  }, version: 1);
  //now insert the data into table
  await db.insert(
    'user_profile',
    {
      'name': 'name',
      'email': 'email',
      'profilePicture': imagePath,
    },
  );
  final dataInTable = await db.query('user_profile');
  log('local database data= ${dataInTable.toString()}');
}
