import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CloudStorageFirebaseSaveAnyFiles {
  CloudStorageFirebaseSaveAnyFiles._();

  static CloudStorageFirebaseSaveAnyFiles cloudStorageFirebaseSaveAnyFiles = CloudStorageFirebaseSaveAnyFiles._();

  final _firebaseStorage = FirebaseStorage.instance;


  //TODO image save fire Storage
  Future<String> imageStorageIntoEmail(File image) async {
    final filePath = "Profile/${DateTime.now()}.jpg";
    await _firebaseStorage.ref(filePath).putFile(image);
    String fileSaveImageUrlEmailProfile = await _firebaseStorage.ref(filePath).getDownloadURL();
    return fileSaveImageUrlEmailProfile;
  }

  //Todo Sander And Receiver image Well be sharing
  Future<String> imageStorageIntoChatSander(File fileImage)
  async {
    final filePath = "image/${fileImage.path}.png";
    await _firebaseStorage.ref(filePath).putFile(fileImage);
    String fileSaveImageUrl = await _firebaseStorage.ref(filePath).getDownloadURL();
    return fileSaveImageUrl;
  }
}
// print("object 1");
// final imageSave = await getApplicationDocumentsDirectory();
// print("object 2");
// print("object 3");
// final file =File(filePath);
// print("object 4");