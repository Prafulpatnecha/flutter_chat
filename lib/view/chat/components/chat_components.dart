import 'dart:io';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/services/cloud_storage_firebase_save_any_files.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../modal/chat_model.dart';
import '../../../modal/massageTypeModel.dart';
import '../../../services/auth_services.dart';
import '../../../services/firebase_cloud_services.dart';
import '../../../utils/colors_globle.dart';
import '../../../utils/globle_variable.dart';

// todo chat page app bar........................................................................
StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>
    receiverAppBarStreamBuilder(double width) {
  return StreamBuilder(
      stream: FirebaseCloudServices.firebaseCloudServices
          .findUserOnlineOfflineAndLastTime(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        Map? chatUser = snapshot.data!.data();
        //todo not working...
        // List<ChatModel> chatList = [];
        // for (QueryDocumentSnapshot snap in data) {
        //   chatList.add(ChatModel.fromChat(snap.data() as Map));
        // }

        return Container(
          height: 100,
          width: width,
          color: colorsGlobleGet.appBarColor.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 29),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.navigate_before,
                          size: 25,
                        )),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chatController.receiverName.value.capitalize
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: colorsGlobleGet.textColor.value),
                        ),
                        if (chatUser!["typingChat"] == true)
                          const Text(
                            "Typing...",
                            style: TextStyle(color: Colors.green),
                          )
                        else if (chatUser["online"] == true)
                          const Text(
                            "Online",
                            style: TextStyle(color: Colors.green),
                          )
                        else
                          Text(
                            "Offline\n${chatUser["lastTime"].toDate().hour}:${chatUser["lastTime"].toDate().minute}/${chatUser["lastTime"].toDate().day}:${(chatUser["lastTime"].toDate().month > 12) ? chatUser["lastTime"].toDate().month : "0${chatUser["lastTime"].toDate().month}"}:${chatUser["lastTime"].toDate().year}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                    const Spacer(),
                    ClayContainer(
                      height: 40,
                      width: 40,
                      depth: 50,
                      spread: 5,
                      borderRadius: 50,
                      curveType: CurveType.concave,
                      color: colorsGlobleGet.containerColor.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //Todo This one On and next time work incomplete
                          image: DecorationImage(
                              image: NetworkImage(chatUser["image"])
                              //(userModal[index].image.contains('file:'))?
                              // FileImage(File(userModal[index].image),),
                              //todo image set work is not complete <--------------------------------------------------
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

//todo User And Receiver Chats All Are This Available
StreamBuilder<QuerySnapshot<Map<String, dynamic>>>
    userReceiverChatsStreamBuilder(double width) {
  return StreamBuilder(
    stream: FirebaseCloudServices.firebaseCloudServices
        .readChatFromFireStore(chatController.receiverEmail.value),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text(snapshot.error.toString()));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      List data = snapshot.data!.docs;
      List<ChatModel> chatList = [];
      List docIdList = [];
      for (QueryDocumentSnapshot snap in data) {
        docIdList.add(snap.id);
        chatList.add(ChatModel.fromChat(snap.data() as Map));
      }

      return ListView.builder(
        reverse: true,
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          // Future<void> working()
          // async {
          if (chatList[index].sender !=
              AuthServices.authServices.getCurrentUser()!.email) {
            FirebaseCloudServices.firebaseCloudServices.userReadAndUnRead(
                chatController.receiverEmail.value, true, docIdList[index]);
          }
          // }
          return (chatList[index].sender !=
                  AuthServices.authServices.getCurrentUser()!.email)
              ? (chatList[index].deleteReceiver == true)
                  ? Container()
                  : (chatList[index].delete == true)
                      ? deleteChatMassageReceiverChatsRow(
                          context, docIdList, index, width, chatList)
                      : receiverChatsRow(
                          context, docIdList, index, width, chatList)
              : (chatList[index].delete == true && chatList[index].deleteSender)
                  ? Container()
                  : (chatList[index].delete == true)
                      ? deleteSanderChatsRow(
                          context, docIdList, index, width, chatList)
                      : (chatList[index].deleteSender == true)
                          ? Container()
                          : senderChatsRow(
                              context, chatList, index, docIdList, width);
        },
      );
    },
  );
}

Row senderChatsRow(BuildContext context, List<ChatModel> chatList, int index,
    List<dynamic> docIdList, double width) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const SizedBox(
        height: 10,
        width: 10,
      ),
      GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                    color: colorsGlobleGet.sheetColor.value,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          print("Update");
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController textUpdate =
                                  TextEditingController(
                                      text: chatList[index].message);
                              return AlertDialog(
                                backgroundColor: colorsGlobleGet.sheetColor.value,
                                title: Center(
                                    child: Text(
                                  "Edit Message",
                                  style: TextStyle(
                                    color: colorsGlobleGet.textChanderColor.value,
                                  ),
                                )),
                                content: Container(
                                  decoration: BoxDecoration(
                                      color: colorsGlobleGet.textFieldContainer.value,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: TextField(
                                    controller: textUpdate,
                                    style: TextStyle(color: colorsGlobleGet.textStyleColor.value),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        "Exit",
                                        style:
                                            TextStyle(color: colorsGlobleGet.textChanderColor.value),
                                      )),
                                  TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      //todo confirmation for update text....
                                      String dcId = docIdList[index];
                                      await FirebaseCloudServices
                                          .firebaseCloudServices
                                          .updateChat(
                                              chatController
                                                  .receiverEmail.value,
                                              textUpdate.text,
                                              dcId);
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(color: colorsGlobleGet.textChanderColor.value),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: width,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(15),
                          child: Text(
                            "Edit Message",
                            style: TextStyle(
                              color: colorsGlobleGet.textChanderColor.value,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        lineLength: double.infinity,
                        lineThickness: 2,
                        dashLength: 2.0,
                        dashColor: colorsGlobleGet.textColor.value,
                        dashGradient: colorsGlobleGet.dividerColorList,
                        dashRadius: 0.0,
                        dashGapRadius: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Delete");
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: colorsGlobleGet.sheetColor.value,
                              content: Text(
                                "Delete Message?",
                                style: TextStyle(color: colorsGlobleGet.textSheetDeleteColor.value),
                              ),
                              actions: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            Get.back();
                                            String dcId = docIdList[index];
                                            await FirebaseCloudServices
                                                .firebaseCloudServices
                                                .deleteChatSenderAlso(
                                                    chatController
                                                        .receiverEmail.value,
                                                    true,
                                                    dcId);
                                          },
                                          child: Text("Delete For Everyone",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: colorsGlobleGet.textButtonColor.value,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            Get.back();
                                            String dcId = docIdList[index];
                                            await FirebaseCloudServices
                                                .firebaseCloudServices
                                                .deleteChatSenderMe(
                                                    chatController
                                                        .receiverEmail.value,
                                                    true,
                                                    dcId);
                                          },
                                          child: Text(
                                            "Delete For Me",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: colorsGlobleGet.textButtonColor.value,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "close",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: colorsGlobleGet.textButtonColor.value,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: width,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: colorsGlobleGet.textChanderColor.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              width:
                  (chatList[index].message!.length <= 34) ? null : width * 0.8,
              decoration: BoxDecoration(
                color: colorsGlobleGet.chatReadColorCurrentUser.value,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (chatList[index].massageType == MassageType.massage) Text(
                            "${chatList[index].message!}    ",
                            style: TextStyle(fontSize: 17, color: colorsGlobleGet.textColor.value),
                          ) else if(chatList[index].massageType == MassageType.image) GestureDetector(
                            onTap: () {
                              chatController.imageShow.value =
                                  chatList[index].message!;
                              Get.toNamed("/imageShow");
                            },
                            child: Container(
                              width: double.infinity,
                              child: Image.network(
                                chatList[index].message!,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ))else GestureDetector(
                            onTap: () {
                              chatController.imageShow.value =
                                  chatList[index].message!;
                              // Get.toNamed("/imageShow");
                            },
                            child: Container(
                              width: double.infinity,
                              child: VideoPlayer( VideoPlayerController.networkUrl(
                                Uri.parse(
                                  chatList[index].message!,
                                ),
                              )),
                            )),
                    //todo sender read.............................................................................
                    if (chatList[index].readAndUnReadMassage == false)
                      const Icon(
                        Icons.done,
                        size: 15,
                      )
                    else
                      const Icon(
                        Icons.done_all,
                        size: 15,
                        color: Colors.blue,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 50,
        width: 10,
      ),
    ],
  );
}

Row deleteSanderChatsRow(BuildContext context, List<dynamic> docIdList,
    int index, double width, List<ChatModel> chatList) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const SizedBox(
        height: 10,
        width: 10,
      ),
      GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                    color: colorsGlobleGet.sheetColor.value,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Delete Receiver");
                        //Todo Delete Receiver
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                "Delete Conformation",
                              ),
                              content: const Text(
                                  "Delete message Have you confirmed!!"),
                              actions: [
                                CupertinoDialogAction(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("No")),
                                CupertinoDialogAction(
                                    onPressed: () async {
                                      Get.back();
                                      String dcId = docIdList[index];
                                      await FirebaseCloudServices
                                          .firebaseCloudServices
                                          .deleteChatSenderMe(
                                              chatController
                                                  .receiverEmail.value,
                                              true,
                                              dcId);
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: width,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: colorsGlobleGet.textChanderColor.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          width: (chatList[index].message!.length <= 34) ? null : width * 0.8,
          decoration: BoxDecoration(
            color: colorsGlobleGet.chatReadColorCurrentUser.value,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "You deleted this message",
              style: TextStyle(fontSize: 17, color: colorsGlobleGet.textColor.value),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 50,
        width: 10,
      ),
    ],
  );
}

Row receiverChatsRow(BuildContext context, List<dynamic> docIdList, int index,
    double width, List<ChatModel> chatList) {
  //todo receiver chats all available here
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(
        height: 10,
        width: 10,
      ),
      GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                    color: colorsGlobleGet.sheetColor.value,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Delete Receiver");
                        //Todo Delete Receiver
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                "Delete Conformation",
                              ),
                              content: const Text(
                                  "Delete message Have you confirmed!!"),
                              actions: [
                                CupertinoDialogAction(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("No")),
                                CupertinoDialogAction(
                                    onPressed: () async {
                                      Get.back();
                                      String dcId = docIdList[index];
                                      await FirebaseCloudServices
                                          .firebaseCloudServices
                                          .deleteChatReceiver(
                                              chatController
                                                  .receiverEmail.value,
                                              true,
                                              dcId);
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: width,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: colorsGlobleGet.textChanderColor.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          width: (chatList[index].message!.length <= 34) ? null : width * 0.8,
          decoration: BoxDecoration(
            color: colorsGlobleGet.chatReadColor.value,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: (chatList[index].massageType == MassageType.massage)
                ? Text(
                    chatList[index].message!,
                    style: TextStyle(fontSize: 17, color: colorsGlobleGet.textColor.value),
                  )
                : GestureDetector(
                    onTap: () {
                      chatController.imageShow.value = chatList[index].message!;
                      Get.toNamed("/imageShow");
                    },
                    child: Image.network(
                      chatList[index].message!,
                      height: 300,
                      fit: BoxFit.cover,
                    )),
          ),
        ),
      ),
      const SizedBox(
        height: 50,
      ),
    ],
  );
}

Row deleteChatMassageReceiverChatsRow(
    BuildContext context,
    List<dynamic> docIdList,
    int index,
    double width,
    List<ChatModel> chatList) {
  //todo receiver chat delete massage print.................................................
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(
        height: 10,
        width: 10,
      ),
      GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                    color: colorsGlobleGet.sheetColor.value,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Delete Receiver");
                        //Todo Delete Receiver
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                "Delete Conformation",
                              ),
                              content: const Text(
                                  "Delete message Have you confirmed!!"),
                              actions: [
                                CupertinoDialogAction(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("No")),
                                CupertinoDialogAction(
                                    onPressed: () async {
                                      Get.back();
                                      String dcId = docIdList[index];
                                      await FirebaseCloudServices
                                          .firebaseCloudServices
                                          .deleteChatReceiver(
                                              chatController
                                                  .receiverEmail.value,
                                              true,
                                              dcId);
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: width,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: colorsGlobleGet.textChanderColor.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          width: (chatList[index].message!.length <= 34) ? null : width * 0.8,
          decoration: BoxDecoration(
            color: colorsGlobleGet.chatReadColor.value,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "You deleted this message",
              style: TextStyle(fontSize: 17, color: colorsGlobleGet.textColor.value),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 50,
      ),
    ],
  );
}

//todo sander chat image_sharing and textSend
Padding chatSanderPadding() {
  return Padding(
    padding: const EdgeInsets.all(9),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        onChanged: (value) {
          if (value.isNotEmpty) {
            print("Yes Working...\n\n\n");
            FirebaseCloudServices.firebaseCloudServices
                .changeOnline(Timestamp.now(), true, true);
          } else {
            FirebaseCloudServices.firebaseCloudServices
                .changeOnline(Timestamp.now(), true, false);
          }
        },
        onTapOutside: (event) {
          print('\n\n\nonTapOutside\n\n');
          FocusManager.instance.primaryFocus?.unfocus();
        },
        // onChanged: (value) {
        //   print("object");
        // },
        // onSaved: (newValue) {
        //   print("object");
        // },
        // focusNode: FocusNode(canRequestFocus: true),
        controller: chatController.txtMassage,
        cursorColor: colorsGlobleGet.cursorTextColor.value,
        decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions_outlined)),
          hintText: "Massage",
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.transparent)),
          // focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)),borderSide: BorderSide(color: Colors.blueGrey)),
          // enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)),borderSide: BorderSide(color: Colors.red)),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? xFileVideo = await imagePicker.pickVideo(
                        source: ImageSource.gallery);
                    try{
                      File image = File(xFileVideo!.path);
                    ChatModel chat = ChatModel(
                        massageType: MassageType.video,
                        readAndUnReadMassage: false,
                        sender:
                            AuthServices.authServices.getCurrentUser()!.email,
                        receiver: chatController.receiverEmail.value,
                        message: await CloudStorageFirebaseSaveAnyFiles
                            .cloudStorageFirebaseSaveAnyFiles
                            .videoStorageIntoChatSander(image),
                        editTime: Timestamp.now(),
                        edit: false,
                        delete: false,
                        deleteSender: false,
                        time: Timestamp.now(),
                        deleteReceiver: false);
                    await FirebaseCloudServices.firebaseCloudServices
                        .addChatFireStore(chat);
                    }catch(e){
                      Get.snackbar("Video", "Video Dispatch!!!");
                    }
                  },
                  icon: Icon(Icons.video_collection_outlined)),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? xFileImage = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    File image = File(xFileImage!.path);
                    ChatModel chat = ChatModel(
                        massageType: MassageType.image,
                        readAndUnReadMassage: false,
                        sender:
                            AuthServices.authServices.getCurrentUser()!.email,
                        receiver: chatController.receiverEmail.value,
                        message: await CloudStorageFirebaseSaveAnyFiles
                            .cloudStorageFirebaseSaveAnyFiles
                            .imageStorageIntoChatSander(image),
                        editTime: Timestamp.now(),
                        edit: false,
                        delete: false,
                        deleteSender: false,
                        time: Timestamp.now(),
                        deleteReceiver: false);
                    await FirebaseCloudServices.firebaseCloudServices
                        .addChatFireStore(chat);
                  },
                  icon: Icon(Icons.image_outlined)),
              IconButton(
                onPressed: () async {
                  if (chatController.txtMassage.text.isNotEmpty) {
                    ChatModel chat = ChatModel(
                      sender: AuthServices.authServices.getCurrentUser()!.email,
                      receiver: chatController.receiverEmail.value,
                      message: chatController.txtMassage.text,
                      time: Timestamp.now(),
                      editTime: Timestamp.now(),
                      edit: false,
                      delete: false,
                      deleteSender: false,
                      deleteReceiver: false,
                      massageType: MassageType.massage,
                      readAndUnReadMassage: false,
                    );
                    chatController.txtMassage.clear();
                    await FirebaseCloudServices.firebaseCloudServices
                        .addChatFireStore(chat);
                    FirebaseCloudServices.firebaseCloudServices
                        .changeOnline(Timestamp.now(), true, false);
                  }
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
