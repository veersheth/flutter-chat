import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/group_info.dart';
import 'package:flutter_chat_app/service/database_service.dart';
import 'package:flutter_chat_app/widgets/message_tile.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({
    Key? key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);
  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          IconButton(
              // padding: EdgeInsets.only(right: 20),
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupName: widget.groupName,
                        groupId: widget.groupId,
                        adminName: admin));
              },
              icon: const Icon(Icons.info_outline_rounded)),
        ],
      ),
      body: Stack(
        children: [
          //chat messages
          // chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 30, top: 10, bottom: 10, right: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(Icons.send_rounded))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data!.docs[index]['message'],
                        sender: snapshot.data!.docs[index]['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data!.docs[index]['sender']);
                  },
                )
              : Container();
        });
  }

  sendMessage() {}
}
