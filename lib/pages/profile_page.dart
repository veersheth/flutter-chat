import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';
import "../widgets/drawer_widget.dart";

class ProfilePage extends StatefulWidget {
  final String email;
  final String userName;

  const ProfilePage({
    super.key,
    required this.email,
    required this.userName,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        drawer: const DrawerWidget(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.account_circle_rounded,
                size: 200,
                color: Colors.grey[600],
              ),
              kSizedHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const Text("Full Name"), Text(widget.userName)],
              ),
              kSizedHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const Text("Email"), Text(widget.email)],
              )
            ],
          ),
        ));
  }
}
