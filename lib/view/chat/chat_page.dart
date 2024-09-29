import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/modal/chat_model.dart';
import 'package:flutter_chat/modal/massageTypeModel.dart';
import 'package:flutter_chat/modal/user_modal.dart';
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
                    color: appBarColor,
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
                                  if (chatUser!["typingChat"] == true)
                                    const Text(
                                      "Typing...",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  else if (chatUser["online"] == true)
                                    Text(
                                      "Online",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  else
                                    Text(
                                      "Offline\n${chatUser["lastTime"].toDate().hour}:${chatUser["lastTime"].toDate().minute}/${chatUser["lastTime"].toDate().day}:${(chatUser["lastTime"].toDate().month > 12) ? chatUser["lastTime"].toDate().month : "0${chatUser["lastTime"].toDate().month}"}:${chatUser["lastTime"].toDate().year}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
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
                      // Future<void> working()
                      // async {
                        if(chatList[index].sender != AuthServices.authServices.getCurrentUser()!.email)
                        {
                          FirebaseCloudServices.firebaseCloudServices.userReadAndUnRead(chatController.receiverEmail.value, true, docIdList[index]);
                        }
                      // }
                      return (chatList[index].sender !=
                              AuthServices.authServices.getCurrentUser()!.email)
                          ? (chatList[index].deleteReceiver == true)
                              ? Container()
                              : (chatList[index].delete == true)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: sheetColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(
                                                                      30))),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "Delete Receiver");
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
                                                                  CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child: Text(
                                                                          "No")),
                                                                  CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        Get.back();
                                                                        String
                                                                            dcId =
                                                                            docIdList[index];
                                                                        await FirebaseCloudServices.firebaseCloudServices.deleteChatReceiver(
                                                                            chatController.receiverEmail.value,
                                                                            true,
                                                                            dcId);
                                                                      },
                                                                      child: Text(
                                                                          "Yes")),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          width: width,
                                                          alignment:
                                                              Alignment.center,
                                                          color: Colors
                                                              .transparent,
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
                                                                    fontSize:
                                                                        20),
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
                                            width: (chatList[index]
                                                        .message!
                                                        .length <=
                                                    34)
                                                ? null
                                                : width * 0.8,
                                            decoration: BoxDecoration(
                                              color: chatReadColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "You deleted this message",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: textColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: sheetColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(
                                                                      30))),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "Delete Receiver");
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
                                                                  CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child: Text(
                                                                          "No")),
                                                                  CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        Get.back();
                                                                        String
                                                                            dcId =
                                                                            docIdList[index];
                                                                        await FirebaseCloudServices.firebaseCloudServices.deleteChatReceiver(
                                                                            chatController.receiverEmail.value,
                                                                            true,
                                                                            dcId);
                                                                      },
                                                                      child: Text(
                                                                          "Yes")),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          width: width,
                                                          alignment:
                                                              Alignment.center,
                                                          color: Colors
                                                              .transparent,
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
                                                                    fontSize:
                                                                        20),
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
                                            width: (chatList[index]
                                                        .message!
                                                        .length <=
                                                    34)
                                                ? null
                                                : width * 0.8,
                                            decoration: BoxDecoration(
                                              color: chatReadColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                chatList[index].message!,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: textColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    )
                          : (chatList[index].delete == true &&
                                  chatList[index].deleteSender)
                              ? Container()
                              : (chatList[index].delete == true)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: sheetColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(
                                                                      30))),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              "Delete Receiver");
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
                                                                  CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child: Text(
                                                                          "No")),
                                                                  CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        Get.back();
                                                                        String
                                                                            dcId =
                                                                            docIdList[index];
                                                                        await FirebaseCloudServices.firebaseCloudServices.deleteChatSenderMe(
                                                                            chatController.receiverEmail.value,
                                                                            true,
                                                                            dcId);
                                                                      },
                                                                      child: Text(
                                                                          "Yes")),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          width: width,
                                                          alignment:
                                                              Alignment.center,
                                                          color: Colors
                                                              .transparent,
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
                                                                    fontSize:
                                                                        20),
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
                                            width: (chatList[index]
                                                        .message!
                                                        .length <=
                                                    34)
                                                ? null
                                                : width * 0.8,
                                            decoration: BoxDecoration(
                                              color: chatReadColorCurrentUser,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "You deleted this message",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: textColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                          width: 10,
                                        ),
                                      ],
                                    )
                                  : (chatList[index].deleteSender == true)
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onLongPress: () {
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color: sheetColor,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30))),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                print("Update");
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    TextEditingController
                                                                        textUpdate =
                                                                        TextEditingController(
                                                                            text:
                                                                                chatList[index].message);
                                                                    return AlertDialog(
                                                                      backgroundColor:
                                                                          sheetColor,
                                                                      title: Center(
                                                                          child: Text(
                                                                        "Edit Message",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              textChanderColor,
                                                                        ),
                                                                      )),
                                                                      content:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                textFieldContainer,
                                                                            borderRadius:
                                                                                BorderRadius.circular(50)),
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              textUpdate,
                                                                          style:
                                                                              TextStyle(color: textStyleColor),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50)),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50)),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(50)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "Exit",
                                                                              style: TextStyle(color: textChanderColor),
                                                                            )),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            Get.back();
                                                                            //todo confirmation for update text....
                                                                            String
                                                                                dcId =
                                                                                docIdList[index];
                                                                            await FirebaseCloudServices.firebaseCloudServices.updateChat(
                                                                                chatController.receiverEmail.value,
                                                                                textUpdate.text,
                                                                                dcId);
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Confirm",
                                                                            style:
                                                                                TextStyle(color: textChanderColor),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                width: width,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                color: Colors
                                                                    .transparent,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15),
                                                                child: Text(
                                                                  "Edit Message",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        textChanderColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: DottedLine(
                                                              direction: Axis
                                                                  .horizontal,
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              lineLength: double
                                                                  .infinity,
                                                              lineThickness: 2,
                                                              dashLength: 2.0,
                                                              dashColor:
                                                                  textColor,
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
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        sheetColor,
                                                                    content:
                                                                        Text(
                                                                      "Delete Message?",
                                                                      style: TextStyle(
                                                                          color:
                                                                              textSheetDeleteColor),
                                                                    ),
                                                                    actions: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            // mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              TextButton(
                                                                                onPressed: () async {
                                                                                  Get.back();
                                                                                  String dcId = docIdList[index];
                                                                                  await FirebaseCloudServices.firebaseCloudServices.deleteChatSenderAlso(chatController.receiverEmail.value, true, dcId);
                                                                                },
                                                                                child: Text("Delete For Everyone", textAlign: TextAlign.end, style: TextStyle(color: textButtonColor, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            // mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              TextButton(
                                                                                onPressed: () async {
                                                                                  Get.back();
                                                                                  String dcId = docIdList[index];
                                                                                  await FirebaseCloudServices.firebaseCloudServices.deleteChatSenderMe(chatController.receiverEmail.value, true, dcId);
                                                                                },
                                                                                child: Text(
                                                                                  "Delete For Me",
                                                                                  textAlign: TextAlign.end,
                                                                                  style: TextStyle(color: textButtonColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
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
                                                                                    color: textButtonColor,
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
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              color: Colors
                                                                  .transparent,
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          15),
                                                                  child: Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color:
                                                                            textChanderColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
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
                                                width: (chatList[index]
                                                            .message!
                                                            .length <=
                                                        34)
                                                    ? null
                                                    : width * 0.8,
                                                decoration: BoxDecoration(
                                                  color:
                                                      chatReadColorCurrentUser,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomRight: Radius
                                                              .circular(10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        chatList[index].message!+"  ",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: textColor),
                                                      ),
                                                      //todo sender read.............................................................................
                                                      (chatList[index].readAndUnReadMassage==false)?Icon(Icons.done,size: 18):Icon(Icons.done_all,size: 18,color: Colors.blue,)
                                                    ],
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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
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
                  cursorColor: cursorTextColor,
                  decoration: InputDecoration(
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
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (chatController.txtMassage.text.isNotEmpty) {
                          ChatModel chat = ChatModel(
                            sender: AuthServices.authServices
                                .getCurrentUser()!
                                .email,
                            receiver: chatController.receiverEmail.value,
                            message: chatController.txtMassage.text,
                            time: Timestamp.now(),
                            editTime: Timestamp.now(),
                            edit: false,
                            delete: false,
                            deleteSender: false,
                            deleteReceiver: false, massageType: MassageType.massage, readAndUnReadMassage: false,
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
