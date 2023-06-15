import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/service/database_service.dart';
import '../widgets/drawer_widget.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;

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

    // getting list of snapshots in stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshots) {
      setState(() {
        groups = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Chat",
          style: TextStyle(),
        ),
        surfaceTintColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      drawer: const DrawerWidget(),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addGroupDialog(context);
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }

  addGroupDialog(BuildContext context) {}

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (BuildContext context, AsyncSnapshot snapshots) {
        // make checks
        if (snapshots.hasData) {
          if (snapshots.data['groups'] != null) {
            if (snapshots.data['groups'].length != 0) {
              return const Text("HELLOOO");
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
          ;
        } else {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        }
        ;
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(Icons.add_circle_rounded, size: 75),
          // kSizedHeight,
          Text(
            "You have not joined any groups, tap on the add icon to create a group or search for a group to join",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
