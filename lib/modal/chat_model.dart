import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  // Todo ex. massageType image,voice,video.. future use
  String? sender, receiver, message, massageType;
  Timestamp time, editTime;
  bool edit, delete, deleteSender, deleteReceiver, readAndUnReadMassage;

  ChatModel({
    required this.massageType,
    required this.readAndUnReadMassage,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.time,
    required this.editTime,
    required this.edit,
    required this.delete,
    required this.deleteSender,
    required this.deleteReceiver,
  });

  factory ChatModel.fromChat(Map m1) {
    return ChatModel(
        sender: m1['sender'],
        receiver: m1['receiver'],
        message: m1['message'],
        time: m1['time'],
        editTime: m1['editTime'],
        edit: m1['edit'],
        delete: m1['delete'],
        deleteSender: m1['deleteSender'],
        deleteReceiver: m1['deleteReceiver'],
        massageType: m1['massageType'],
        readAndUnReadMassage: m1['readAndUnReadMassage']);
  }

  Map<String, dynamic> toMap(ChatModel chat) {
    return {
      "sender": chat.sender,
      "message": chat.message,
      "receiver": chat.receiver,
      "time": chat.time,
      "edit": chat.edit,
      "editTime": chat.editTime,
      "delete": chat.delete,
      "deleteReceiver": chat.deleteReceiver,
      "deleteSender": chat.deleteSender,
      "readAndUnReadMassage": chat.readAndUnReadMassage,
      "massageType": chat.massageType,
    };
  }
}
