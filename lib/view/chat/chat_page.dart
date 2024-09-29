import 'package:flutter/material.dart';

import '../../utils/colors_globle.dart';
import 'components/chat_components.dart';

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
            receiverAppBarStreamBuilder(width),
            Expanded(
              child: userReceiverChatsStreamBuilder(width),
            ),
            const SizedBox(
              height: 20,
            ),
            chatSanderPadding(),
          ],
        ),
      ),
    );
  }
}
