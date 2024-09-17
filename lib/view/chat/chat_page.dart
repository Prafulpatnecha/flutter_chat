import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/chat_model.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_chat/utils/globle_variable.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatController.receiverName.value),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(stream: FirebaseCloudServices.firebaseCloudServices.readChatFromFireStore(chatController.receiverEmail.value), builder: (context, snapshot) {
                if(snapshot.hasError)
                  {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator());
                  }

                List data = snapshot.data!.docs;
                List<ChatModel> chatList = [];
                for(QueryDocumentSnapshot snap in data)
                  {
                    chatList.add(
                        ChatModel.fromChat(snap.data() as Map)
                    );
                  }
                return ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                  return (chatList[index].sender!=AuthServices.authServices.getCurrentUser()!.email)?ListTile(title: Text(chatList[index].message!)):ListTile(trailing: Text(chatList[index].message!));
                },);
              },),
            ),
            TextFormField(
              controller: chatController.txtMassage,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(onPressed: () async{
                  ChatModel chat = ChatModel(sender: AuthServices.authServices.getCurrentUser()!.email, receiver: chatController.receiverEmail.value, message: chatController.txtMassage.text, time: Timestamp.now());
                  await FirebaseCloudServices.firebaseCloudServices.addChatFireStore(chat);
                }, icon: Icon(Icons.send))
              ),
            )
          ],
        ),
      ),
    );
  }
}