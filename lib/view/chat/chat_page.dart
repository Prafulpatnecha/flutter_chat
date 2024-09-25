import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/chat_model.dart';
import 'package:flutter_chat/services/auth_services.dart';
import 'package:flutter_chat/services/firebase_cloud_services.dart';
import 'package:flutter_chat/utils/globle_variable.dart';
import 'package:get/get.dart';

import '../../utils/colors_globle.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   toolbarOpacity: 0,
      // backgroundColor: Colors.redAccent,
      //   title: ,
      // ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: chatColorList,
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: Column(
          children: [
            StreamBuilder(
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
                  for (QueryDocumentSnapshot snap in data) {
                    chatList.add(ChatModel.fromChat(snap.data() as Map));
                  }
                  return Container(
                    height: 100,
                    width: width,
                    color: Colors.white.withOpacity(0.2),
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
                                        fontWeight: FontWeight.bold,
                                        color: textColor),
                                  ),
                                  const Text(
                                    "Online",
                                    style: TextStyle(),
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
                                color: containerColor,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    //Todo This one On and next time work incomplete
                                    // image: DecorationImage(
                                    //     image: //(userModal[index].image.contains('file:'))?
                                    //     // FileImage(File(userModal[index].image),),
                                    //     NetworkImage(
                                    //         chatList[index].image)
                                    //   //todo image set work is not complete <--------------------------------------------------
                                    // ),
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
                }),
            Expanded(
              child: StreamBuilder(
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
                      return (chatList[index].sender !=
                              AuthServices.authServices.getCurrentUser()!.email)
                          ? (chatList[index].deleteReceiver == true)
                              ? Container()
                              : (chatList[index].delete==true)? Row(
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
                                        color: sheetColor,
                                        borderRadius:
                                        const BorderRadius.only(
                                            topLeft:
                                            Radius.circular(
                                                30),
                                            topRight:
                                            Radius.circular(
                                                30))),
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
                                                  title: Text(
                                                    "Delete Conformation",
                                                  ),
                                                  content: const Text(
                                                      "Delete message Have you confirmed!!"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed:
                                                            () async {
                                                          String
                                                          dcId =
                                                          docIdList[
                                                          index];
                                                          await FirebaseCloudServices
                                                              .firebaseCloudServices
                                                              .deleteChatReceiver(
                                                              chatController.receiverEmail.value,
                                                              true,
                                                              dcId);
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                            "Yes")),
                                                    TextButton(
                                                        onPressed:
                                                            () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                            "No")),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: width,
                                            alignment:
                                            Alignment.center,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(8.0),
                                                margin:
                                                const EdgeInsets
                                                    .all(15),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color:
                                                      textChanderColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
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
                              width:
                              (chatList[index].message!.length <=
                                  34)
                                  ? null
                                  : width * 0.8,
                              decoration: BoxDecoration(
                                color: chatReadColor,
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "You deleted this message",
                                  style: TextStyle(
                                      fontSize: 17, color: textColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ) :Row(
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
                                                  color: sheetColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                          topRight:
                                                              Radius.circular(
                                                                  30))),
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
                                                            title: Text(
                                                              "Delete Conformation",
                                                            ),
                                                            content: const Text(
                                                                "Delete message Have you confirmed!!"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    String
                                                                        dcId =
                                                                        docIdList[
                                                                            index];
                                                                    await FirebaseCloudServices
                                                                        .firebaseCloudServices
                                                                        .deleteChatReceiver(
                                                                            chatController.receiverEmail.value,
                                                                            true,
                                                                            dcId);
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                      "Yes")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                      "No")),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      width: width,
                                                      alignment:
                                                          Alignment.center,
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color:
                                                                    textChanderColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                        width:
                                            (chatList[index].message!.length <=
                                                    34)
                                                ? null
                                                : width * 0.8,
                                        decoration: BoxDecoration(
                                          color: chatReadColor,
                                          borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            chatList[index].message!,
                                            style: TextStyle(
                                                fontSize: 17, color: textColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                )
                          : (chatList[index].delete==true && chatList[index].deleteSender)?Container():(chatList[index].delete==true)? Row(
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
                                        color: sheetColor,
                                        borderRadius:
                                        const BorderRadius.only(
                                            topLeft:
                                            Radius.circular(
                                                30),
                                            topRight:
                                            Radius.circular(
                                                30))),
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
                                                  title: Text(
                                                    "Delete Conformation",
                                                  ),
                                                  content: const Text(
                                                      "Delete message Have you confirmed!!"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed:
                                                            () async {
                                                          String
                                                          dcId =
                                                          docIdList[
                                                          index];
                                                          await FirebaseCloudServices
                                                              .firebaseCloudServices
                                                              .deleteChatSenderMe(
                                                              chatController.receiverEmail.value,
                                                              true,
                                                              dcId);
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                            "Yes")),
                                                    TextButton(
                                                        onPressed:
                                                            () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                            "No")),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: width,
                                            alignment:
                                            Alignment.center,
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(8.0),
                                                margin:
                                                const EdgeInsets
                                                    .all(15),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color:
                                                      textChanderColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
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
                              width:
                              (chatList[index].message!.length <=
                                  34)
                                  ? null
                                  : width * 0.8,
                              decoration: BoxDecoration(
                                color: chatReadColorCurrentUser,
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "You deleted this message",
                                  style: TextStyle(
                                      fontSize: 17, color: textColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                            width: 10,
                          ),
                        ],
                      ):(chatList[index].deleteSender==true)? Container():Row(
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
                                              color: sheetColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30))),
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
                                                        TextEditingController
                                                            textUpdate =
                                                            TextEditingController(
                                                                text: chatList[
                                                                        index]
                                                                    .message);
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              sheetColor,
                                                          title: Center(
                                                              child: Text(
                                                            "Update",
                                                            style: TextStyle(
                                                              color:
                                                                  textChanderColor,
                                                            ),
                                                          )),
                                                          content: TextField(
                                                            controller:
                                                                textUpdate,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  "Exit",
                                                                  style: TextStyle(
                                                                      color:
                                                                          textChanderColor),
                                                                )),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                //todo confirmation for update text....
                                                                String dcId =
                                                                    docIdList[
                                                                        index];
                                                                await FirebaseCloudServices
                                                                    .firebaseCloudServices
                                                                    .updateChat(
                                                                        chatController
                                                                            .receiverEmail
                                                                            .value,
                                                                        textUpdate
                                                                            .text,
                                                                        dcId);
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                "Confirm",
                                                                style: TextStyle(
                                                                    color:
                                                                        textChanderColor),
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Text(
                                                      "Update",
                                                      style: TextStyle(
                                                          color:
                                                              textChanderColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: DottedLine(
                                                  direction: Axis.horizontal,
                                                  alignment:
                                                      WrapAlignment.center,
                                                  lineLength: double.infinity,
                                                  lineThickness: 2,
                                                  dashLength: 2.0,
                                                  dashColor: textColor,
                                                  dashGradient:
                                                      dividerColorList,
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
                                                        backgroundColor:
                                                            sheetColor,
                                                        content: Text(
                                                          "Delete Message?",
                                                          style: TextStyle(
                                                              color:
                                                                  textSheetDeleteColor),
                                                        ),
                                                        actions: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                // mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      String
                                                                          dcId =
                                                                          docIdList[
                                                                              index];
                                                                      await FirebaseCloudServices.firebaseCloudServices.deleteChatSenderAlso(
                                                                          chatController
                                                                              .receiverEmail
                                                                              .value,
                                                                          true,
                                                                          dcId);
                                                                      Get.back();
                                                                    },
                                                                    child: Text(
                                                                        "Delete For Everyone",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .end,
                                                                        style: TextStyle(
                                                                            color:
                                                                                textButtonColor,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                // mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      String
                                                                          dcId =
                                                                          docIdList[
                                                                              index];
                                                                      await FirebaseCloudServices.firebaseCloudServices.deleteChatSenderMe(
                                                                          chatController
                                                                              .receiverEmail
                                                                              .value,
                                                                          true,
                                                                          dcId);
                                                                        Get.back();
                                                                    },
                                                                    child: Text(
                                                                      "Delete For Me",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style: TextStyle(
                                                                          color:
                                                                              textButtonColor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                // mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    child: Text(
                                                                      "close",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            textButtonColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color:
                                                                textChanderColor,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                    width:
                                        (chatList[index].message!.length <= 34)
                                            ? null
                                            : width * 0.8,
                                    decoration: BoxDecoration(
                                      color: chatReadColorCurrentUser,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        chatList[index].message!,
                                        style: TextStyle(
                                            fontSize: 17, color: textColor),
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
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                controller: chatController.txtMassage,
                cursorColor: cursorTextColor,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Colors.red)),
                  // focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)),borderSide: BorderSide(color: Colors.blueGrey)),
                  // enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50)),borderSide: BorderSide(color: Colors.red)),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (chatController.txtMassage.text.isNotEmpty) {
                        ChatModel chat = ChatModel(
                          sender:
                              AuthServices.authServices.getCurrentUser()!.email,
                          receiver: chatController.receiverEmail.value,
                          message: chatController.txtMassage.text,
                          time: Timestamp.now(),
                          editTime: Timestamp.now(),
                          edit: false,
                          delete: false,
                          deleteSender: false,
                          deleteReceiver: false,
                        );
                        await FirebaseCloudServices.firebaseCloudServices
                            .addChatFireStore(chat);
                        chatController.txtMassage.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
