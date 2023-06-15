import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';
import '../pages/home_page.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidget();
}

class _DrawerWidget extends State<DrawerWidget> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 50),
      children: <Widget>[
        Icon(
          Icons.account_circle_rounded,
          size: 125,
          color: Colors.grey[600],
        ),
        kSizedHeight,
        Text(
          userName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        kSizedHeight,
        const Divider(height: 2, indent: 10, endIndent: 10),
        DrawerListItem(
          icon: Icons.group_rounded,
          title: "Groups",
          tapFunc: () {
            nextScreen(context, const HomePage());
          },
        ),
        DrawerListItem(
          icon: Icons.person_rounded,
          title: "Profile",
          tapFunc: () {
            nextScreen(context, ProfilePage(email: email, userName: userName));
          },
        ),
        DrawerListItem(
          icon: Icons.exit_to_app_rounded,
          title: "Signout",
          tapFunc: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Sign out"),
                    content: const Text("Are you sure you want to sign out?"),
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: () {
                          authService.signout().whenComplete(() {
                            nextScreenReplace(context, const LoginPage());
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).primaryColor),
                        ),
                        child: Text("Okay",
                            style: TextStyle(
                                color: Theme.of(context).canvasColor)),
                      ),
                    ],
                  );
                });
          },
        ),
      ],
    ));
  }
}

class DrawerListItem extends StatelessWidget {
  final Function tapFunc;
  final IconData icon;
  final String title;

  const DrawerListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.tapFunc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        tapFunc();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Icon(
        icon,
        size: 20,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
    );
  }
}
