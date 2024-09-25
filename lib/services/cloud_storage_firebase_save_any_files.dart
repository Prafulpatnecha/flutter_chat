import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageFirebaseSaveAnyFiles {
  CloudStorageFirebaseSaveAnyFiles._();

  static CloudStorageFirebaseSaveAnyFiles cloudStorageFirebaseSaveAnyFiles = CloudStorageFirebaseSaveAnyFiles._();

  final _firebaseStorage = FirebaseStorage.instance;


  //TODO image save fire Storage
  Future<void> imageStorageIntoEmail(File image) async {
    // print("object 1");
    // final imageSave = await getApplicationDocumentsDirectory();
    // print("object 2");
    // print("object 3");
    // final file =File(filePath);
    // print("object 4");
    final filePath = "Profile/${DateTime.now()}.jpg";
    await _firebaseStorage.ref(filePath).putFile(image);
    String fileSaveImageUrlEmailProfile = await _firebaseStorage.ref(filePath).getDownloadURL();
  }
}