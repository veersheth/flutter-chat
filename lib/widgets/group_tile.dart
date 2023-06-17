import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({
    Key? key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          nextScreen(
              context,
              ChatPage(
                groupId: widget.groupId,
                groupName: widget.groupName,
                userName: widget.userName,
              ));
        },
        child: Column(children: [
          SizedBox(height: 5),
          ListTile(
            dense: false,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.groupName,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Join the conversation as ${widget.userName}",
                style: TextStyle(fontSize: 13)),
          ),
          SizedBox(height: 5),
        ]),
      ),
    );
  }
}
