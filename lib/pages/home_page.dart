import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/service/database_service.dart';
import '../widgets/drawer_widget.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

import '../widgets/group_tile.dart';

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
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
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

    // getting list of snapshot in stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
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
        surfaceTintColor: Theme.of(context).colorScheme.primary,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addGroupDialog(context);
        },
        icon: Icon(
          Icons.add_rounded,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: Text("Create Group"),
      ),
    );
  }

  addGroupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Create a group",
                  // textAlign: TextAlign.left,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading
                        ?
                        // loading indicator
                        Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )

                        // group requirements
                        : TextField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (newName) {
                              setState(() {
                                groupName = newName;
                              });
                            },
                          ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                    onPressed: () async {
                      if (groupName != "") {
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName)
                            .whenComplete(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackbar(context, "Group Created");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.surfaceTint)),
                    child: Text(
                      "Create",
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onInverseSurface),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary),
          );
        }
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
