import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  late String name,email,phoneNo,token,image;
  bool online,typingChat;
  Timestamp lastTime;

  UserModal({required this.name,required this.email,required this.phoneNo,required this.token,required this.image,required this.online,required this.lastTime,required this.typingChat});
  factory UserModal.fromUser(Map m1)
  {
    return UserModal(name: m1['name'], email: m1["email"], phoneNo: m1["phoneNo"], token: m1["token"], image: m1["image"], online: m1['online'],lastTime: m1['lastTime'], typingChat: m1['typingChat']);
  }
  Map toMap(UserModal userModal)
  {
    return {
      'email': userModal.email,
      'name': userModal.name,
      'phoneNo': userModal.phoneNo,
      'token': userModal.token,
      'image': userModal.image,
      "online" : userModal.online,
      "lastTime" : userModal.lastTime,
      "typingChat" : userModal.typingChat,
    };
  }
}