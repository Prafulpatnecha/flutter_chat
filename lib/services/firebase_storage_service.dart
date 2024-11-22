// image -->
// storage

// network

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService
{
  FirebaseStorageService._();
  static FirebaseStorageService firebaseStorageService = FirebaseStorageService._();


  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> createFirebaseStorageReference()
  async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    final ref = firebaseStorage.ref();
    ref.child("images/${image!.name}");
    File file = File(image.path);
    ref.putFile(file);
    String url = await ref.getDownloadURL();
    return url;
  }
}
